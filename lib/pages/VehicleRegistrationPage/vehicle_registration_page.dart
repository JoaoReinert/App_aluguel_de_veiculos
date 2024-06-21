import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../../models/brands_model.dart';
import '../../models/vehicle_models_model.dart';
import '../../models/year_model.dart';
import '../../theme.dart';

class VehicleState extends ChangeNotifier {
  List<String> vehicleTypes = ['Cars', 'Motorcycles', 'Trucks'];
  String? _selectedType;
  List<BrandsModel> vehicleBrands = [];
  BrandsModel? _selectedBrand;
  List<VehicleModels> vehicleModels = [];
  VehicleModels? _selectedModel;
  List<YearModel> vehicleYear = [];
  YearModel? _selectedYear;

  final _controllerPlate = TextEditingController();

  String? get selectedType => _selectedType;

  BrandsModel? get selectedBrand => _selectedBrand;

  VehicleModels? get selectedModel => _selectedModel;

  YearModel? get selectedYear => _selectedYear;

  TextEditingController get controllerPlate => _controllerPlate;

  // Future<void> load () async{
  //   final list = controller.select();
  //   _listVehicles.clear();
  //   _listVehicles.addAll(list);
  //   notifyListeners();
  // }

  void updateType(String newValue) {
    _selectedType = newValue.toLowerCase();
    showBrands();
    notifyListeners();
  }

  void updateBrand(BrandsModel newValue) {
    _selectedBrand = newValue;
    showModels();
    notifyListeners();
  }

  void updateModel(VehicleModels newValue) {
    _selectedModel = newValue;
    showYear();
    notifyListeners();
  }

  void updateYear(YearModel newValue) {
    _selectedYear = newValue;
    notifyListeners();
  }

  Future<void> showBrands() async {
    if (selectedType != null) {
      _selectedBrand = null;
      vehicleBrands = [];
      final response = await http.get(
        Uri.parse('https://fipe.parallelum.com.br/api/v2/$selectedType/brands'),
      );
      final List<dynamic> data = jsonDecode(response.body);
      for (final it in data) {
        vehicleBrands.add(BrandsModel.fromJson(it));
      }
      notifyListeners();
    }
  }

  Future<void> showModels() async {
    if (selectedBrand != null) {
      _selectedModel = null;
      vehicleModels = [];
      final response = await http.get(
        Uri.parse('https://fipe.parallelum.com.br/api/v2/$selectedType/brands/'
            '${selectedBrand!.id}/models'),
      );
      final List<dynamic> data = jsonDecode(response.body);
      for (final it in data) {
        vehicleModels.add(VehicleModels.fromJson(it));
      }
      notifyListeners();
    }
  }

  Future<void> showYear() async {
    if (selectedModel != null) {
      _selectedYear = null;
      vehicleYear = [];
      final response = await http.get(
        Uri.parse(
            'https://fipe.parallelum.com.br/api/v2/$selectedType/brands/${selectedBrand!.id}/models/${selectedModel!.id}/anos'),
      );
      print(response.body);
      if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      for (final it in data) {
        vehicleYear.add(YearModel.fromJson(it));
      }
      } else {
        print('erro');
      }
      notifyListeners();
    }
  }
}

class VehicleRegisterrrr extends StatelessWidget {
  const VehicleRegisterrrr({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VehicleState(),
      child: Consumer<VehicleState>(builder: (_, state, __) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Center(
              child: Text('Vehicle Registration'),
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
                  DropdownSearch<String>(
                    dropdownDecoratorProps: dropdownDecoration('Type'),
                    popupProps: PopupProps.menu(
                      searchFieldProps: searchFieldDecoration(),
                      constraints: BoxConstraints(maxHeight: 300),
                      menuProps: menuPropsDecoration(),
                      showSearchBox: true,
                    ),
                    items: state.vehicleTypes,
                    selectedItem: state.selectedType,
                    onChanged: (value) {
                      if (value != null) {
                        state.updateType(value);
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownSearch<BrandsModel>(
                    dropdownDecoratorProps: dropdownDecoration('Brand'),
                    popupProps: PopupProps.menu(
                      menuProps: menuPropsDecoration(),
                      searchFieldProps: searchFieldDecoration(),
                      showSearchBox: true,
                    ),
                    items: state.vehicleBrands,
                    itemAsString: (BrandsModel brands) => brands.name,
                    onChanged: (value) {
                      if (value != null) {
                        state.updateBrand(value);
                      }
                    },
                    selectedItem: state.selectedBrand,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownSearch<VehicleModels>(
                    dropdownDecoratorProps: dropdownDecoration('Model'),
                    popupProps: PopupProps.menu(
                      menuProps: menuPropsDecoration(),
                      searchFieldProps: searchFieldDecoration(),
                      showSearchBox: true,
                    ),
                    items: state.vehicleModels,
                    itemAsString: (VehicleModels models) => models.name,
                    onChanged: (value) {
                      if (value != null) {
                        state.updateModel(value);
                      }
                    },
                    selectedItem: state.selectedModel,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownSearch<YearModel>(
                    dropdownDecoratorProps: dropdownDecoration('Year'),
                    popupProps: PopupProps.menu(
                      menuProps: menuPropsDecoration(),
                      searchFieldProps: searchFieldDecoration(),
                      showSearchBox: true,
                    ),
                    items: state.vehicleYear,
                    itemAsString: (YearModel year) => year.name,
                    onChanged: (value) {
                      if (value != null) {
                        state.updateYear(value);
                      }
                    },
                    selectedItem: state.selectedYear,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: state.controllerPlate,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontSize: 15, color: Colors.black),
                    decoration: decorationForm('Plate'),
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Enter the vehicle plate';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
