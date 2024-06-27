class YearModel{
  final String? id;
  final String? name;

  YearModel({this.id, this.name});

  static fromJson(Map<String, dynamic> json) {
    return YearModel(id: json['code'], name: json['name']);
  }
}