import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/database.dart';
import '../../models/vehicles_model.dart';
import '../../utils/standard_delete_dialog.dart';
import '../../utils/standard_form_button.dart';

class FunctionsListVehicle extends ChangeNotifier {

  FunctionsListVehicle() {
    load();
  }

  final controller = VehicleController();
  final _listVehicle = <VehiclesModels>[];
  List<VehiclesModels> get listVehicle => _listVehicle;

  Future<void> load () async {
    final list = await controller.select();
    _listVehicle.clear();
    _listVehicle.addAll(list);
    notifyListeners();
  }

  Future<void> delete(VehiclesModels vehicle) async {
    await controller.delete(vehicle);
    await load();
    notifyListeners();
  }


}
///criacao da tela de resgistro do veiculo
class VehicleListPage extends StatelessWidget {
  ///instancia da classe
  const VehicleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( create: (context) => FunctionsListVehicle(),
      child: Consumer<FunctionsListVehicle>(
        builder: (_,state,__) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Vehicles'),
              actions: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: StandardFormButton(
                    onpressed: () async {
                      await Navigator.pushNamed(context, '/vehicle');
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
              child: Builder(
                builder: (context) {
                  if (state.listVehicle.isEmpty) {
                    return const Center(
                      child: Text('No vehicles registered',
                        style: TextStyle(fontSize: 18, color: Colors.grey),),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: state.listVehicle.length,
                      itemBuilder: (context, index) {
                        final vehicle = state.listVehicle[index];
                        return Padding(
                          padding: const EdgeInsets.all(2),
                          child: Card(
                            color: const Color.fromARGB(255, 203, 202, 202),
                            elevation: 3,
                            shadowColor: Colors.black,
                            child: ListTile(
                              onTap: () {
                                 Navigator.pushNamed(context, '/vehiclesDataPage',
                                    arguments: vehicle);
                              },
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              title: Text(
                                vehicle.model!.name!,
                                style: const TextStyle(fontSize: 20),
                              ),
                              subtitle: Text('Daily rate: ${vehicle.dailyRate}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            StandardDeleteDialog(
                                              name: vehicle.model!.name!,
                                              function: () async {
                                                await state.delete(vehicle);
                                              },
                                            ),
                                      );
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },),
            ),
          );
        }
      ),
    );
  }
}
