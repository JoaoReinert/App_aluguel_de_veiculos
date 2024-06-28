import 'package:flutter/material.dart';

import '../../models/vehicles_model.dart';

class VehicleDataPage extends StatelessWidget {
  VehicleDataPage({super.key, required this.vehicle});

  final VehiclesModels vehicle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              child: Text(
                vehicle.model!.name!,
                style: const TextStyle(fontSize: 25, color: Colors.black),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
      ),
      backgroundColor: Colors.blue,
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Center(
                child: Column(
                  children: [
                    Text(
                      'data',
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Vehicle information',
                      style: TextStyle(color: Colors.black, fontSize: 25)),
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
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        vehicle.brand!.name!,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
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
                        style: TextStyle(color: Colors.black, fontSize: 18),
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
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        vehicle.plate,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
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
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        vehicle.year!.name!,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
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
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'R\$${vehicle.dailyRate},00',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
