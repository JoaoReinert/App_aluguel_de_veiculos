///classe modelo dos veiculos
class VehiclesModel {
  ///id para identificar no banco qual é o carro
  late int? id;
  ///marca do veiculo
  final String brand;
  ///modelo do veiculo
  final String model;
  ///placa do veiculo
  final String plate;
  ///ano do veiculo
  final String year;
  ///diaria do veiculo
  final double dailyRate;
  ///imagens do veiculo
  final String urlImage;

  ///instacia do modelo para ser obrigatorio a passagem de dados
  VehiclesModel({
    this.id,
    required this.brand,
    required this.model,
    required this.plate,
    required this.year,
    required this.dailyRate,
    required this.urlImage,
  });
}
