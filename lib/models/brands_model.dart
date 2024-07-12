///criação do modelo de marcas
class BrandsModel {
  ///variavel com id unico para identificar a marca
  final String? id;
  ///variavel com name para o nome da marca
  final String? name;

  ///construtor
  BrandsModel({this.id, this.name});

  ///metodo para converter um Map JSON em uma instacia do modelo
  static BrandsModel fromJson(Map<String, dynamic> json) {
    return BrandsModel(id: json['code'], name: json['name']);
  }
}