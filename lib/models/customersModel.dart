class CustomerModel {
  final String? id;
  final String name;
  final String phone;
  final String cnpj;
  final String city;
  final String state;

  CustomerModel(
      {this.id,
      required this.name,
      required this.phone,
      required this.cnpj,
      required this.city,
      required this.state});
}
