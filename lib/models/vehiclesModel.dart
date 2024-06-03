class VehiclesModel {
  final String? id;
  final String brand;
  final String model;
  final String plate;
  final String year;
  final double dailyRate;
  final String urlImage;

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
