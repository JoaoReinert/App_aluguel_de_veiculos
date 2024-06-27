class ModelsModel {
  final String? id;
  final String? name;

  ModelsModel({this.id, this.name});

  static fromJson(Map<String, dynamic> json) {
    return ModelsModel(id: json['code'], name: json['name']);
  }
}
