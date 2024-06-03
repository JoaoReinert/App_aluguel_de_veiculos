class ManagerModel {
  final String? id;
  final String name;
  final int cpf;
  final String state;
  final String phone;
  final double comission;

  ManagerModel(
      {this.id,
      required this.name,
      required this.cpf,
      required this.state,
      required this.phone,
      required this.comission});
}
