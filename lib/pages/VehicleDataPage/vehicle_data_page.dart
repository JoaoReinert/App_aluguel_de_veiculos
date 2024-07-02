import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/vehicles_model.dart';

class VehicleDataPage extends StatelessWidget {
  VehicleDataPage({super.key, required this.vehicle});

  final VehiclesModels vehicle;

  Future<List<String>> pickImages(String plate) async {
    final List<String> imagesPath = [];
    final appDocumentsDirectory = await getApplicationSupportDirectory();

    final images = '${appDocumentsDirectory.path}/images/vehicles/$plate';
    final directory = Directory(images);
    if (await directory.exists()) {
      var files = directory.listSync();

      for (var file in files) {
        if (file.path.contains('.png')) {
          imagesPath.add(file.path);
        }
      }
      return imagesPath;
    } else {
      return imagesPath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: 30,
        centerTitle: true,
      ),
      backgroundColor: Colors.blue,
      body: Container(
        margin: const EdgeInsets.all(8),
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
                    future: pickImages(vehicle.plate),
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
                          style: TextStyle(color: Colors.black, fontSize: 18),
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
                          style: TextStyle(color: Colors.black, fontSize: 18),
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
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'R\$${vehicle.dailyRate},00',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
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
  }
}
