import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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
            'https://fipe.parallelum.com.br/api/v2/$selectedType/brands/${selectedBrand!.id}/models/${selectedModel!.id}/years'),
      );
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

  List<File>? vehiclesImages = [];

  Future<void> pickImages(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    ImageCropper imageCropper = ImageCropper();
    XFile? pickedImage = await imagePicker.pickImage(source: source);

    if (pickedImage != null) {
      CroppedFile? cropped = await imageCropper.cropImage(
          sourcePath: pickedImage.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxHeight: 500,
          maxWidth: 500,
          compressFormat: ImageCompressFormat.jpg);
      if (cropped != null) {
        vehiclesImages?.add(File(cropped.path));
      }
      notifyListeners();
    }
  }

  Future<void> saveImages() async {
    final appDocumentsDirectory = await getApplicationSupportDirectory();

    final pathImages = '${appDocumentsDirectory.path}/images';
    final appDirectoryImages = Directory(pathImages);

    if (!appDirectoryImages.existsSync()) {
      await appDirectoryImages.create();
    }
    final pathVehicles = '${appDocumentsDirectory.path}/images/vehicles';
    final appDirectoryVehicles = Directory(pathVehicles);

    if (!appDirectoryVehicles.existsSync()) {
      await appDirectoryVehicles.create();
    }
    final appDirectoryNameVehicles = _controllerPlate.text.trim();
    final pathIdVehicles =
        '${appDirectoryVehicles.path}/$appDirectoryNameVehicles';
    final appDirectoryVehiclesId = Directory(pathIdVehicles);

    if (!appDirectoryVehiclesId.existsSync()) {
      await appDirectoryVehiclesId.create();
    }
    try {
      for (int i = 0; i < vehiclesImages!.length; i++) {
        final VehicleImage = vehiclesImages![i];
        final fileVehicle = File('${appDirectoryVehiclesId.path}/$i.png');

        final bytes = await VehicleImage.readAsBytes();

        await fileVehicle.writeAsBytes(bytes);
      }
    } catch (e, trace) {
      print('error: $e, $trace');
    }
  }
}

class VehicleRegister extends StatelessWidget {
  const VehicleRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VehicleState(),
      child: Consumer<VehicleState>(
        builder: (_, state, __) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              title: const Text('Vehicle Registration'),
              centerTitle: true,
              automaticallyImplyLeading: false,
              toolbarHeight: 60,
            ),
            backgroundColor: Colors.blue,
            body: SingleChildScrollView(
              child: Container(
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
                        enabled: true,
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
                        enabled: state.selectedType != null,
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
                        enabled: state.selectedBrand != null,
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
                      Row(
                        children: [
                          Expanded(
                            child: DropdownSearch<YearModel>(
                              enabled: state.selectedModel != null,
                              dropdownDecoratorProps:
                                  dropdownDecoration('Year'),
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
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: state.controllerPlate,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black),
                              decoration: decorationForm('Plate'),
                              validator: (value) {
                                if (value != null && value.isEmpty) {
                                  return 'Enter the vehicle plate';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () => _showBottomSheet(context, state),
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      if (state.vehiclesImages != null &&
                          state.vehiclesImages!.isNotEmpty)
                        GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 4,
                          ),
                          itemCount: state.vehiclesImages!.length,
                          itemBuilder: (context, index) {
                            final images = state.vehiclesImages![index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                images,
                              ),
                            );
                          },
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 150,
                              vertical: 7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showBottomSheet(BuildContext context, VehicleState state) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo, color: Colors.grey),
                title: Text('Galery'),
                onTap: () {
                  Navigator.of(context).pop();
                  state.pickImages(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Colors.grey,
                ),
                title: Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  state.pickImages(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
