import 'managers_model.dart';
import 'state_model.dart';

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

  ///nome da empresa do cliente
  final String companyName;

  ///estado do cliente
  final EstadoModel state;

  ///gerente responsavel pelo cliente
  late ManagerModel? manager;

  ///instacia do modelo para ser obrigatorio a passagem de dados
  CustomerModel(
      {this.id,
      required this.name,
      required this.phone,
      required this.cnpj,
      required this.city,
      required this.state,
      required this.companyName,
        this.manager,
      });
}
