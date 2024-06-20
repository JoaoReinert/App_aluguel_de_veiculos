import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../models/brands_model.dart';
import '../../models/vehicle_models_model.dart';
import '../../theme.dart';

class VehicleState extends ChangeNotifier {
  List<String> vehicleTypes = ['cars', 'motorcycles', 'trucks'];
  String? selectedType;
  List<BrandsModel> vehicleBrands = [];
  BrandsModel? selectedBrand;
  List<VehicleModels> vehicleModels = [];
  VehicleModels? selectedModel;

  final _controllerVehicleType = TextEditingController();
  TextEditingController get controllerVehicleType => _controllerVehicleType;

  Future<void> showBrands () async {
    if (selectedType != null) {
      selectedBrand = null;
      vehicleBrands = [];
      final response = await http.get(Uri.parse('https://fipe.parallelum.com.br/api/v2/$selectedType/brands'),);
      final List <dynamic> data = jsonDecode(response.body);
      for (final it in data) {
        vehicleBrands.add(BrandsModel.fromJson(it));
      }
      notifyListeners();
    }
  }
  Future<void> showModels () async {
    if (selectedBrand != null) {
      selectedModel = null;
      vehicleModels = [];
      final response = await http.get(Uri.parse('https://fipe.parallelum.com.br/api/v2/$selectedType/brands/'
          '${selectedBrand!.id}/models'),);
      final List <dynamic> data = jsonDecode(response.body);
      for (final it in data) {
        vehicleModels.add(VehicleModels.fromJson(it));
      }
      notifyListeners();
    }
  }
}

class VehicleRegisterrrr extends StatelessWidget {
  const VehicleRegisterrrr({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( create: (context) => VehicleState(),
      child: Consumer<VehicleState>(
        builder: (_, state,__) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Center(child: Text('Vehicle Registration'),),
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
                      DropdownSearch<String>(
                        dropdownDecoratorProps: dropdownDecoration('Type'),
                        popupProps: PopupProps.menu(
                          searchFieldProps: searchFieldDecoration(),
                          showSearchBox: true,
                        ),
                        items: state.vehicleTypes,
                        selectedItem: state.selectedType,
                      ),
                      SizedBox(height: 20,),
                      DropdownSearch<BrandsModel>(
                        dropdownDecoratorProps: dropdownDecoration('Brand'),
                        popupProps: PopupProps.menu(
                          searchFieldProps: searchFieldDecoration(),
                          showSearchBox: true,
                        ),
                        items: state.vehicleBrands,
                        onChanged: (value) {
                          state.selectedBrand = value;
                          state.showModels();
                        },
                        selectedItem: state.selectedBrand,
                      ),
                      SizedBox(height: 20,),
                      DropdownSearch<VehicleModels>(
                        dropdownDecoratorProps: dropdownDecoration('Model'),
                        popupProps: PopupProps.menu(
                          searchFieldProps: searchFieldDecoration(),
                          showSearchBox: true,
                        ),
                        items: state.vehicleModels,
                        onChanged: (value) {
                          state.selectedModel = value;
                        },
                        selectedItem: state.selectedModel,
                      )
                    ],
                  ),
                ),
              ),
          );
        }
      ),
    );
  }
}
