import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/vehicles_table.dart';
import '../../models/vehicles_model.dart';
import '../../pdf/pdf.dart';
import '../../theme.dart';
import '../../utils/standard_dialog.dart';
import '../../utils/vehicle_utils.dart';
///criacao do state da tela
class VehicleDataPageState extends ChangeNotifier {
  ///variavel do veiculo selecionado
  final VehiclesModels vehicle;
  ///controlador de preço para poder editar
  final TextEditingController controllerPrice = TextEditingController();
  ///controlador de veiculo para pode editar
  final controllerVehicle = VehicleController();
  ///chave para edicao do preço
  final editVehicleKey = GlobalKey<FormState>();

  ///construtor
  VehicleDataPageState(this.vehicle);
  ///funcao para edit do preço
  Future<void> updatePrice(BuildContext context, String newPrice) async {
    vehicle.dailyRate = newPrice;
    await controllerVehicle.updatePrice(vehicle.id!, newPrice);
    notifyListeners();
  }

}
///criacao da tela
class VehicleDataPage extends StatelessWidget {
  ///construtor
  const VehicleDataPage({super.key, required this.vehicle});
  ///variavel do veiculo
  final VehiclesModels vehicle;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VehicleDataPageState(vehicle),
      child: Consumer<VehicleDataPageState>(builder: (_, state, __) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: true,
            toolbarHeight: 30,
            centerTitle: true,
          ),
          backgroundColor: Colors.blue,
          body: Container(
            margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Center(
                      child: FutureBuilder<List<String>>(
                        future: vehicle.getImages(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Icon(
                              Icons.image_not_supported,
                              size: 100,
                            );
                          } else {
                            return CarouselSlider(
                              options: CarouselOptions(
                                height: 200,
                                enableInfiniteScroll: false,
                              ),
                              items: snapshot.data!.map((imagePath) {
                                return Builder(
                                  builder: (context) {
                                    return Image.file(
                                      File(imagePath),
                                    );
                                  },
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.directions_car_filled_outlined),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Brand -',
                              style:
                              TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              vehicle.brand!.name!,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.directions_car),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Model -',
                              style:
                              TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                vehicle.model!.name!,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.confirmation_num),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Plate -',
                              style:
                              TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              vehicle.plate,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Year -',
                              style:
                              TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              vehicle.year!.name!,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.attach_money_outlined),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Daily rate -',
                              style:
                              TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              formatMoney(double.parse(vehicle.dailyRate)),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StandardDialog(
                                      formKey: state.editVehicleKey,
                                      title: 'Edit Daily Rate',
                                      actions: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style:
                                              TextStyle(color: Colors.red),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              if (state.editVehicleKey.currentState!.validate()) {
                                                final newPrice =
                                                    state.controllerPrice.text;
                                                if (newPrice.isNotEmpty) {
                                                  state.updatePrice(context,
                                                      state.controllerPrice
                                                          .text);
                                                  Navigator.pop(context);
                                                }
                                              }
                                            },
                                            child: const Text(
                                              'Save',
                                              style:
                                              TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      ),
                                      items: [
                                        TextFormField(
                                          controller: state.controllerPrice,
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black),
                                          decoration:
                                          decorationForm('New Price'),
                                          validator: (value) {
                                            if (value != null &&
                                                value.isEmpty) {
                                              return 'Enter the new price';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              elevation: 0,
                              backgroundColor: Colors.blue,
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/rentsRegisterPage',
                                  arguments: vehicle);
                            },
                            child: const Text(
                              'RENT NOW',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
