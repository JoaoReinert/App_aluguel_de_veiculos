import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../controllers/rents_table.dart';
import '../../controllers/vehicles_table.dart';
import '../../models/vehicles_model.dart';
import '../../pdf/pdf.dart';
import '../../theme.dart';
import '../../utils/standard_delete_dialog.dart';
import '../../utils/standard_form_button.dart';

///criacao do state da tela
class FunctionsListVehicle extends ChangeNotifier {
  ///toda vez que a tela for chamada ela seja carregada
  FunctionsListVehicle() {
    load();
  }

  ///controlador de veiculos para pegar funcoes do banco
  final controller = VehicleController();

  ///controlador de aluguel para pegar funcoes do banco
  final controllerRent = RentsController();
  final _listVehicle = <VehiclesModels>[];
  List<VehiclesModels> _listVehicleFilter = <VehiclesModels>[];

  ///controlador para a barra de pesquisa da tela
  final controllerResearch = TextEditingController();

  ///getter para a lista de veiculos
  List<VehiclesModels> get listVehicle => _listVehicleFilter;

  ///funcao para carregar a page
  Future<void> load() async {
    final list = await controller.select();
    _listVehicle.clear();
    _listVehicle.addAll(list);
    _listVehicleFilter = _listVehicle;
    notifyListeners();
  }

  ///funcao para deletar um veiculo
  Future<void> delete(VehiclesModels vehicle) async {
    await controller.delete(vehicle);
    await load();
    notifyListeners();
  }

  ///funcao para pegar a primeira imagem tirada do veiculo
  Future<String?> pickImages(String plate) async {
    final appDocumentsDirectory = await getApplicationSupportDirectory();

    final image = '${appDocumentsDirectory.path}/images/vehicles/$plate/0.png';

    return image;
  }

  ///funcao para verificacao de exclusao do veiculo, se tiver alugado nao pode
  ///ser excluido
  Future<void> verificationDeleteVehicle(
      BuildContext context, VehiclesModels vehicle) async {
    final function = await controllerRent.rentalVehicleVerification(vehicle.id);
    if (function) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('It is not possible to delete this vehicle'),
            content: const Text('This vehicle has a registered rental'),
            actions: [
              TextButton(
                child: const Text(
                  'Exit',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => StandardDeleteDialog(
          name: vehicle.model!.name!,
          function: () async {
            await delete(vehicle);
          },
        ),
      );
    }
  }

  ///funcao de filtragem para a barra de pesquisa da tela
  void filterVehicles(String nameVehicle) {
    if (nameVehicle.isEmpty) {
      _listVehicleFilter = _listVehicle;
    } else {
      _listVehicleFilter = _listVehicle
          .where((vehicle) => vehicle.model!.name!
              .toLowerCase()
              .contains(nameVehicle.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

///criacao da tela de resgistro do veiculo
class VehicleListPage extends StatelessWidget {
  ///instancia da classe
  const VehicleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FunctionsListVehicle(),
      child: Consumer<FunctionsListVehicle>(builder: (_, state, __) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Vehicles'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StandardFormButton(
                  onpressed: () async {
                    await Navigator.pushNamed(context, '/vehicleRegisterPage');
                    state.load();
                  },
                  icon: const Icon(
                    Icons.directions_car,
                    color: Colors.blue,
                  ),
                  label: 'Registration +',
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  controller: state.controllerResearch,
                  onChanged: state.filterVehicles,
                  decoration: decorationSearch(
                    'Search Vehicles',
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state.listVehicle.isEmpty) {
                        return const Center(
                          child: Text(
                            'No vehicles registered',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: state.listVehicle.length,
                          itemBuilder: (context, index) {
                            final vehicle = state.listVehicle[index];
                            return Padding(
                              padding: const EdgeInsets.all(2),
                              child: Card(
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                color: Colors.grey[350],
                                elevation: 3,
                                shadowColor: Colors.black,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/vehiclesDataPage',
                                        arguments: vehicle);
                                  },
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.white, width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  leading: FutureBuilder<String?>(
                                    future: state.pickImages(vehicle.plate),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        if (snapshot.hasData &&
                                            File(snapshot.data!).existsSync()) {
                                          return Image.file(
                                            File(snapshot.data!),
                                            fit: BoxFit.fill,
                                          );
                                        } else {
                                          return const Icon(
                                              Icons.image_not_supported);
                                        }
                                      } else {
                                        return const CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                  title: Text(
                                    vehicle.model!.name!,
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 20),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      Text(
                                        formatMoney(
                                            double.parse(vehicle.dailyRate)),
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      const Divider(color: Colors.black38),
                                      const SizedBox(height: 5),
                                      Text(vehicle.year!.name!),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      await state.verificationDeleteVehicle(
                                          context, vehicle);
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
