import '../models/managers_model.dart';
import '../models/state_model.dart';
import 'database.dart';
import 'states_table.dart';
///criacao da tabela de gerentes com uma chave estrangeira que referencia
///a tabela de estados
class ManagerTable {
  static const String createTable = '''
   CREATE TABLE $tableName (
  $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $name TEXT NOT NULL,
  $cpf TEXT NOT NULL,
  $phone TEXT NOT NULL,
  $comission TEXT NOT NULL,
  $codeState INTEGER,
  FOREIGN KEY ($codeState) REFERENCES ${EstadoTable.tableName}(${EstadoTable.cdEstado})
  );
 
  ''';

  static const String tableName = 'manager';

  static const String id = 'id';
  static const String name = 'name';
  static const String cpf = 'cpf';
  static const String phone = 'phone';
  static const String comission = 'comission';
  static const String codeState = 'codeState';

  static Map<String, dynamic> toMap(ManagerModel manager) {
    final map = <String, dynamic>{};

    map[ManagerTable.id] = manager.id;
    map[ManagerTable.name] = manager.name;
    map[ManagerTable.cpf] = manager.cpf;
    map[ManagerTable.phone] = manager.phone;
    map[ManagerTable.comission] = manager.comission;
    map[ManagerTable.codeState] = manager.state.cdEstado;

    return map;
  }
}

///controler de gerentes para criacao de funcoes
class ManagerController {
  ///funcao insert para inserir gerente na tabela
  Future<void> insert(ManagerModel manager) async {
    final database = await getDatabase();
    final map = ManagerTable.toMap(manager);
    await database.insert(ManagerTable.tableName, map);

    return;
  }
  ///funcao delete para deletar gerente na tabela
  Future<void> delete(ManagerModel manager) async {
    final database = await getDatabase();

    database.delete(ManagerTable.tableName,
        where: '${ManagerTable.id} = ?', whereArgs: [manager.id]);
  }
  ///funcao select para selecionar os gerentes na tabela
  Future<List<ManagerModel>> select() async {
    final database = await getDatabase();

    final result = await database.rawQuery('''
      SELECT ${ManagerTable.tableName}.*, ${EstadoTable.nmEstado}, ${EstadoTable.cdEstado}, ${EstadoTable.sgEstado} 
      FROM ${ManagerTable.tableName} 
      INNER JOIN ${EstadoTable.tableName} 
      ON ${ManagerTable.tableName}.${ManagerTable.codeState} = ${EstadoTable.tableName}.${EstadoTable.cdEstado}
    ''');

    var list = <ManagerModel>[];

    for (final item in result) {
      list.add(ManagerModel(
          id: item[ManagerTable.id] as int,
          name: item[ManagerTable.name] as String? ?? '',
          cpf: item[ManagerTable.cpf] as String? ?? '',
          phone: item[ManagerTable.phone] as String? ?? '',
          comission: item[ManagerTable.comission] as String? ?? '',
          state: EstadoModel(
            cdEstado: item[EstadoTable.cdEstado] as int,
            nmEstado: item[EstadoTable.nmEstado] as String? ?? '',
            sgEstado: item[EstadoTable.sgEstado] as String? ?? '',
          )));
    }
    return list;
  }
  ///funcao para editar o nome de um gerente na tabela
  Future<void> updateName(int managerId, String newName) async {
    final database = await getDatabase();
    await database.update(
      ManagerTable.tableName,
      {ManagerTable.name: newName},
      where: '${ManagerTable.id} = ?',
      whereArgs: [managerId],
    );
  }
  ///funcao para editar o cpf de um gerente na tabela
  Future<void> updateCPF(int managerId, String newCPF) async {
    final database = await getDatabase();
    await database.update(
      ManagerTable.tableName,
      {ManagerTable.cpf: newCPF},
      where: '${ManagerTable.id} = ?',
      whereArgs: [managerId],
    );
  }
  ///funcao para editar o telefone de um gerente na tabela
  Future<void> updatePhone(int managerId, String newPhone) async {
    final database = await getDatabase();
    await database.update(
      ManagerTable.tableName,
      {ManagerTable.phone: newPhone},
      where: '${ManagerTable.id} = ?',
      whereArgs: [managerId],
    );
  }
  ///funcao para editar a comissao de um gerente na tabela
  Future<void> updateCommission(int managerId, String newCommission) async {
    final database = await getDatabase();
    await database.update(
      ManagerTable.tableName,
      {ManagerTable.comission: newCommission},
      where: '${ManagerTable.id} = ?',
      whereArgs: [managerId],
    );
  }
}