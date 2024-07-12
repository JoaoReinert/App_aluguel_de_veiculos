///modelo de ano do veiculo
class YearModel{
  ///id para identificar qual o ano
  final String? id;
  ///nome do ano, exemplo 2024
  final String? name;

  ///construtor
  YearModel({this.id, this.name});

  ///metodo para converter um Map JSON em uma instacia do modelo
  static YearModel fromJson(Map<String, dynamic> json) {
    return YearModel(id: json['code'], name: json['name']);
  }
}