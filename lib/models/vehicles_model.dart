import 'package:projeto_final_lince/models/vehicle_models_model.dart';
import 'package:projeto_final_lince/models/year_model.dart';

import 'brands_model.dart';

///classe modelo dos veiculos
class VehiclesModels {
  ///id para identificar no banco qual é o carro
  late int? id;
  ///tipo do veiculo
  final String? type;
  ///marca do veiculo
  final BrandsModel? brand;
  ///modelo do veiculo
  final ModelsModel? model;
  ///placa do veiculo
  final String plate;
  ///ano do veiculo
  final YearModel? year;
  ///diaria do veiculo
  final String dailyRate;
  ///imagem do veiculo
  final List<String>? images;

  ///instacia do modelo para ser obrigatorio a passagem de dados
  VehiclesModels({
    this.id,
    required this.type,
    required this.brand,
    required this.model,
    required this.plate,
    required this.year,
    required this.dailyRate,
    this.images
  });
}
