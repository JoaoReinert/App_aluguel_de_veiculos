
import '../controllers/states_table.dart';

///modelo de estados
class EstadoModel {
  ///codigo do estado
  int cdEstado;
  ///sigla do estado
  String sgEstado;
  ///nome do estado
  String nmEstado;

  ///construtor
  EstadoModel({
    required this.cdEstado,
    required this.sgEstado,
    required this.nmEstado,
  });

  /// retorna uma nova instância com os dados fornecidos no map.
  factory EstadoModel.fromMap(Map<String, dynamic> map) {
    return EstadoModel(
      cdEstado: map[EstadoTable.cdEstado],
      sgEstado: map[EstadoTable.sgEstado],
      nmEstado: map[EstadoTable.nmEstado],
    );
  }
}