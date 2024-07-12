///modelo de modelo de veiculos
class ModelsModel {
  /// id para identificar qual modelo
  final String? id;
  ///nome do modelo
  final String? name;
  ///construtor
  ModelsModel({this.id, this.name});

  ///metodo para converter um Map JSON em uma instacia do modelo
  static ModelsModel fromJson(Map<String, dynamic> json) {
    return ModelsModel(id: json['code'], name: json['name']);
  }
}
