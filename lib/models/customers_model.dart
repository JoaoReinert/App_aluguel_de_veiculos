import '../enum_states.dart';

///classe modelo dos clientes
class CustomerModel {
  ///id para identificar no banco qual cliente que é
  late int? id;
  ///nome do cliente
  final String name;
  ///telefone do cliente
  final String phone;
  ///cnpj do cliente
  final String cnpj;
  ///cidade do cliente
  final String city;
  ///estado do cliente
  final States? state;

  ///instacia do modelo para ser obrigatorio a passagem de dados
  CustomerModel(
      {this.id,
      required this.name,
      required this.phone,
      required this.cnpj,
      required this.city,
      required this.state});
}
