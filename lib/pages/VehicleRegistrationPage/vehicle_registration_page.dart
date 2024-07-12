import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../controllers/vehicles_table.dart';
import '../../models/brands_model.dart';
import '../../models/vehicle_models_model.dart';
import '../../models/vehicles_model.dart';
import '../../models/year_model.dart';
import '../../theme.dart';

///criacao do estado da tela
class VehicleState extends ChangeNotifier {

  ///key para o fomrulario de registro de veiculo
  final vehicleKey = GlobalKey<FormState>();
  ///controlador de veiculo para pegar funcoes no banco de dados
  final controller = VehicleController();
  ///lista de tipos de veiculos para filtragem
  List<String> vehicleTypes = <String>['Cars', 'Motorcycles', 'Trucks'];
  String? _selectedType;
  ///lista de marcas do veiculo
  List<BrandsModel> vehicleBrands = [];
  BrandsModel? _selectedBrand;
  ///lista de modelos do veiculo
  List<ModelsModel> vehicleModels = [];
  ModelsModel? _selectedModel;
  ///lista de anos do veiculo
  List<YearModel> vehicleYear = [];
  YearModel? _selectedYear;
  final _controllerPlate = TextEditingController();
  final _controllerDailyRate = TextEditingController();
  final _listVehicles = <VehiclesModels>[];
  ///getter para o tipo selecionado do veiculo
  String? get selectedType => _selectedType;
  ///getter para a marca selecionado do veiculo
  BrandsModel? get selectedBrand => _selectedBrand;
  ///getter para o modelo selecionado do veiculo
  ModelsModel? get selectedModel => _selectedModel;
  ///getter para o ano selecionado do veiculo
  YearModel? get selectedYear => _selectedYear;
  ///controlador da placa para o formulario
  TextEditingController get controllerPlate => _controllerPlate;
  ///controlador do preço da diaria para o formulario
  TextEditingController get controllerDailyRate => _controllerDailyRate;
  ///controlador da lista de veiculos
  List<VehiclesModels> get listVehicle => _listVehicles;

  ///funcao para carregar a pagina certinha quando for chamada
  Future<void> load() async {
    final list = await controller.select();
    _listVehicles.clear();
    _listVehicles.addAll(list);
    notifyListeners();
  }
  ///funcao para inserir o veiculo na tabela de veiculos do banco
  Future<void> insert() async {
      final vehicles = VehiclesModels(
          type: selectedType,
          brand: selectedBrand,
          model: selectedModel,
          plate: controllerPlate.text,
          year: selectedYear,
          dailyRate: controllerDailyRate.text,
      );

      await controller.insert(vehicles);
      await saveImages();
      await load();

      _selectedType = null;
      _selectedBrand = null;
      _selectedModel = null;
      controllerPlate.clear();
      _selectedYear = null;
      controllerDailyRate.clear();
      vehiclesImages?.clear();
      notifyListeners();
  }

  ///funcao para deletar o veiculo
  Future<void> delete(VehiclesModels vehicle) async {
    await controller.delete(vehicle);
    await load();
    notifyListeners();
  }

  ///funcao para colocar o tipo de veiculo no drop down
  void updateType(String newValue) {
    _selectedType = newValue.toLowerCase();
    showBrands();
    notifyListeners();
  }
  ///funcao para colocar a marca do veiculo no drop down
  void updateBrand(BrandsModel newValue) {
    _selectedBrand = newValue;
    showModels();
    notifyListeners();
  }
  ///funcao para colocar o modelo de veiculo no drop down
  void updateModel(ModelsModel newValue) {
    _selectedModel = newValue;
    showYear();
    notifyListeners();
  }
  ///funcao para colocar o ano de veiculo no drop down
  void updateYear(YearModel newValue) {
    _selectedYear = newValue;
    notifyListeners();
  }
  ///funcao para carregar todas as marcas da api de acordo com o tipo de veiculo
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
  ///funcao para carregar todos os modelos da api de acordo com
  ///o tipo de veiculo e marca
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
        vehicleModels.add(ModelsModel.fromJson(it));
      }
      notifyListeners();
    }
  }
  ///funcao para carregar todos os anos da api de acordo com o tipo de veiculo,
  ///a marca e o modelo
  Future<void> showYear() async {
    if (selectedModel != null) {
      _selectedYear = null;
      vehicleYear = [];
      final response = await http.get(
        Uri.parse(
            'https://fipe.parallelum.com.br/api/v2/$selectedType/brands/${selectedBrand!
                .id}/models/${selectedModel!.id}/years'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        for (final it in data) {
          vehicleYear.add(YearModel.fromJson(it));
        }
      }
      notifyListeners();
    }
  }
  ///lista de imagens do veiculo
  List<File>? vehiclesImages = [];

  ///funcao para pegar essas imagens
  Future<void> pickImages(ImageSource source) async {
    var imagePicker = ImagePicker();
    var imageCropper = ImageCropper();
    var pickedImage = await imagePicker.pickImage(source: source);

    if (pickedImage != null) {
      var cropped = await imageCropper.cropImage(
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

  ///funcao para salvar as imagens
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
      await appDirectoryVehiclesId.create(recursive: true);

    }

    try {
      for (var i = 0; i < vehiclesImages!.length; i++) {
        final vehicleImage = vehiclesImages![i];
        final fileVehicle = File('${appDirectoryVehiclesId.path}/$i.png');

        final bytes = await vehicleImage.readAsBytes();

        await fileVehicle.writeAsBytes(bytes);

      }
    } catch (e, trace) {
      print('error: $e, $trace');
    }
  }
}
///criacao da pagina
class VehicleRegister extends StatelessWidget {
  ///construtor
  const VehicleRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VehicleState(),
      child: Consumer<VehicleState>(
        builder: (_, state, __) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              title: const Text('Vehicle Registration'),
              centerTitle: true,
              automaticallyImplyLeading: false,
              toolbarHeight: 60,
            ),
            backgroundColor: Colors.blue,
            body: SingleChildScrollView(
              child: Form(
                key: state.vehicleKey,
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
                            constraints: const BoxConstraints(maxHeight: 300),
                            menuProps: menuPropsDecoration(),
                            showSearchBox: true,
                          ),
                          items: state.vehicleTypes,
                          onChanged: (value) {
                            if (value != null) {
                              state.updateType(value);
                            }
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Enter the vehicle type';
                            }
                            return null;
                          },
                          selectedItem: state.selectedType,
                        ),
                        const SizedBox(
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
                          itemAsString: (brands) => brands.name!,
                          onChanged: (value) {
                            if (value != null) {
                              state.updateBrand(value);
                            }
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Enter the vehicle brand';
                            }
                            return null;
                          },
                          selectedItem: state.selectedBrand,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DropdownSearch<ModelsModel>(
                          enabled: state.selectedBrand != null,
                          dropdownDecoratorProps: dropdownDecoration('Model'),
                          popupProps: PopupProps.menu(
                            menuProps: menuPropsDecoration(),
                            searchFieldProps: searchFieldDecoration(),
                            showSearchBox: true,
                          ),
                          items: state.vehicleModels,
                          itemAsString: (models) => models.name!,
                          onChanged: (value) {
                            if (value != null) {
                              state.updateModel(value);
                            }
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Enter the vehicle model';
                            }
                            return null;
                          },
                          selectedItem: state.selectedModel,
                        ),
                        const SizedBox(
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
                                itemAsString: (year) => year.name!,
                                onChanged: (value) {
                                  if (value != null) {
                                    state.updateYear(value);
                                  }
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Enter the year';
                                  }
                                  return null;
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
                                    return 'Enter the plate';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: state.controllerDailyRate,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                          decoration: decorationForm('Daily Rate'),
                          validator: (value) {
                            if (value != null && value.isEmpty) {
                              return 'Enter the vehicle daily rate';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
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
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (state.vehicleKey.currentState!.validate()) {
                              await state.insert();
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 100,
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
                leading: const Icon(Icons.photo, color: Colors.grey),
                title: const Text('Galery'),
                onTap: () {
                  Navigator.of(context).pop();
                  state.pickImages(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: Colors.grey,
                ),
                title: const Text('Camera'),
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
