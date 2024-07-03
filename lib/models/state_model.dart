import '../controllers/database.dart';

class EstadoModel {
  int cdEstado;
  String sgEstado;
  String nmEstado;

  EstadoModel({
    required this.cdEstado,
    required this.sgEstado,
    required this.nmEstado,
  });

  factory EstadoModel.fromMap(Map<String, dynamic> map) {
    return EstadoModel(
      cdEstado: map[EstadoTable.cdEstado],
      sgEstado: map[EstadoTable.sgEstado],
      nmEstado: map[EstadoTable.nmEstado],
    );
  }
}