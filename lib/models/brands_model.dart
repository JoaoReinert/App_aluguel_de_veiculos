class BrandsModel {
  final String? id;
  final String? name;

  BrandsModel({this.id, this.name});

  static fromJson(Map<String, dynamic> json) {
    return BrandsModel(id: json['code'], name: json['name']);
  }
}