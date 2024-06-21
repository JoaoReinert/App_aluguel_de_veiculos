class YearModel{
  final String id;
  final String name;

  YearModel({required this.id, required this.name});

  static fromJson(Map<String, dynamic> json) {
    return YearModel(id: json['code'], name: json['name']);
  }
}