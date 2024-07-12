import 'package:sqflite/sqflite.dart';

import '../models/state_model.dart';
import 'database.dart';

class EstadoTable {
  static const String createTable = '''
   CREATE TABLE $tableName (
  $cdEstado INTEGER PRIMARY KEY AUTOINCREMENT, 
  $sgEstado TEXT NOT NULL,
  $nmEstado TEXT NOT NULL
  );
  ''';

  static Future<void> insertInitialData(Database db) async {
    await db.execute('''
      INSERT INTO $tableName ($sgEstado, $nmEstado) VALUES ('AC', 'Acre'),
      ('AL', 'Alagoas'),
      ('AP', 'Amapá'),
      ('AM', 'Amazonas'),
      ('BA', 'Bahia'),
      ('CE', 'Ceará'),
      ('DF', 'Distrito Federal'),
      ('ES', 'Espírito Santo'),
      ('GO', 'Goiás'),
      ('MA', 'Maranhão'),
      ('MT', 'Mato Grosso'),
      ('MS', 'Mato Grosso do Sul'),
      ('MG', 'Minas Gerais'),
      ('PA', 'Pará'),
      ('PB', 'Paraíba'),
      ('PR', 'Paraná'),
      ('PE', 'Pernambuco'),
      ('PI', 'Piauí'),
      ('RJ', 'Rio de Janeiro'),
      ('RN', 'Rio Grande do Norte'),
      ('RS', 'Rio Grande do Sul'),
      ('RO', 'Rondônia'),
      ('RR', 'Roraima'),
      ('SC', 'Santa Catarina'),
      ('SP', 'São Paulo'),
      ('SE', 'Sergipe'),
      ('TO', 'Tocantins');
    ''');
  }

  static const String tableName = 'ESTADO';

  static const String cdEstado = 'CD_ESTADO';
  static const String sgEstado = 'SG_ESTADO';
  static const String nmEstado = 'NM_ESTADO';

  static Map<String, dynamic> toMap(EstadoModel estado) {
    final map = <String, dynamic>{};

    map[EstadoTable.cdEstado] = estado.cdEstado;
    map[EstadoTable.sgEstado] = estado.sgEstado;
    map[EstadoTable.nmEstado] = estado.nmEstado;

    return map;
  }
}

class EstadoController {
  Future<List<EstadoModel>> select() async {
    final database = await getDatabase();
    final List<Map<String, dynamic>> result = await database.query(
      EstadoTable.tableName,
    );

    var list = <EstadoModel>[];

    for (final item in result) {
      list.add(EstadoModel(
        cdEstado: item[EstadoTable.cdEstado],
        nmEstado: item[EstadoTable.nmEstado],
        sgEstado: item[EstadoTable.sgEstado],
      ));
    }
    return list;
  }
}