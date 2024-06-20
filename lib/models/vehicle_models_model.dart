class VehicleModels {
  final String id;
  final String name;

  VehicleModels({required this.id, required this.name});

  static fromJson(Map<String, dynamic> json) {
    return VehicleModels(id: json['code'], name: json['name']);
  }
}
