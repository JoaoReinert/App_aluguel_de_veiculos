import '../enum_states.dart';

///classe modelo dos gerentes
class ManagerModel {

  ///id para identificar qual o gerente do banco
  late int? id;
  ///nome do gerente
  final String name;
  ///cpf do gerente
  final String cpf;
  ///estado do gerente
  final States? state;
  ///telefone do gerente
  final String phone;
  ///comissao do gerente
  final String comission;

  ///instacia do modelo para ser obrigatorio a passagem de dados
  ManagerModel(
      {this.id,
      required this.name,
      required this.cpf,
      required this.state,
      required this.phone,
      required this.comission});
}
