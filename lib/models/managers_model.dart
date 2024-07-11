import 'package:projeto_final_lince/models/state_model.dart';

///classe modelo dos gerentes
class ManagerModel {

  ///id para identificar qual o gerente do banco
  late int? id;
  ///nome do gerente
  String name;
  ///cpf do gerente
  String cpf;
  ///telefone do gerente
   String phone;
  ///comissao do gerente
   String comission;
  ///estado
  final EstadoModel state;

  ///instacia do modelo para ser obrigatorio a passagem de dados
  ManagerModel(
      {this.id,
      required this.name,
      required this.cpf,
      required this.phone,
      required this.comission,
        required this.state
      });
}
