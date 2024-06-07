///classe modelo dos gerentes
class ManagerModel {

  ///id para identificar qual o gerente do banco
  final String? id;
  ///nome do gerente
  final String name;
  ///cpf do gerente
  final int cpf;
  ///estado do gerente
  final String state;
  ///telefone do gerente
  final String phone;
  ///comissao do gerente
  final double comission;

  ///instacia do modelo para ser obrigatorio a passagem de dados
  ManagerModel(
      {this.id,
      required this.name,
      required this.cpf,
      required this.state,
      required this.phone,
      required this.comission});
}
