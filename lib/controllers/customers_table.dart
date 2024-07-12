import '../models/customers_model.dart';
import '../models/managers_model.dart';
import '../models/state_model.dart';
import 'database.dart';
import 'managers_table.dart';
import 'states_table.dart';

///criacao da tabela de clientes
class CustomerTable {
  static const String createTable = '''
  CREATE TABLE $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $name TEXT NOT NULL,
  $phone TEXT NOT NULL,
  $cnpj TEXT NOT NULL,
  $city TEXT NOT NULL,
  $state TEXT NOT NULL,
  $companyName TEXT NOT NULL,
  $codeState INTEGER,
  $managerId INTEGER,
  FOREIGN KEY ($codeState) REFERENCES ${EstadoTable.tableName}(${EstadoTable.cdEstado}),
  FOREIGN KEY ($managerId) REFERENCES ${ManagerTable.tableName}(${ManagerTable.id})
  );
  ''';

  static const String tableName = 'customer';

  static const String id = 'id';
  static const String name = 'name';
  static const String phone = 'phone';
  static const String cnpj = 'cnpj';
  static const String city = 'city';
  static const String state = 'state';
  static const String companyName = 'companyName';
  static const String codeState = 'codeState';
  static const String managerId = 'managerId';

  static Map<String, dynamic> tomap(CustomerModel customer) {
    final map = <String, dynamic>{};

    map[CustomerTable.id] = customer.id;
    map[CustomerTable.name] = customer.name;
    map[CustomerTable.phone] = customer.phone;
    map[CustomerTable.cnpj] = customer.cnpj;
    map[CustomerTable.city] = customer.city;
    map[CustomerTable.state] = customer.state.sgEstado;
    map[CustomerTable.companyName] = customer.companyName;
    map[CustomerTable.codeState] = customer.state.cdEstado;
    map[CustomerTable.managerId] = customer.manager?.id;

    return map;
  }
}

///classe para criancao de metodos insert e delete
class CustomerController {
  Future<CustomerModel?> selectId(int customerId) async {
    final database = await getDatabase();
    final result = await database.rawQuery('''
    SELECT ${CustomerTable.tableName}.*, 
             ${EstadoTable.tableName}.${EstadoTable.cdEstado} as stateCdEstado,
             ${EstadoTable.tableName}.${EstadoTable.sgEstado} as stateSgEstado,
             ${EstadoTable.tableName}.${EstadoTable.nmEstado} as stateNmEstado,
           ${ManagerTable.tableName}.${ManagerTable.id} as managerId,
           ${ManagerTable.tableName}.${ManagerTable.name} as managerName,
           ${ManagerTable.tableName}.${ManagerTable.cpf} as managerCpf,
           ${ManagerTable.tableName}.${ManagerTable.phone} as managerPhone,
           ${ManagerTable.tableName}.${ManagerTable.comission} as managerComission,
           ${ManagerTable.tableName}.${ManagerTable.codeState} as managerCodeState
    FROM ${CustomerTable.tableName}
    LEFT JOIN ${ManagerTable.tableName}
    ON ${CustomerTable.tableName}.${CustomerTable.managerId} = ${ManagerTable.tableName}.${ManagerTable.id}
    LEFT JOIN ${EstadoTable.tableName}
    ON ${CustomerTable.tableName}.${CustomerTable.codeState} = ${EstadoTable.tableName}.${EstadoTable.cdEstado}
    WHERE ${CustomerTable.tableName}.${CustomerTable.id} = ?
  ''', [customerId]);

    if (result.isNotEmpty) {
      final item = result.first;
      return CustomerModel(
        id: item[CustomerTable.id] as int,
        name: item[CustomerTable.name] as String,
        phone: item[CustomerTable.phone] as String,
        cnpj: item[CustomerTable.cnpj] as String,
        city: item[CustomerTable.city] as String,
        state: EstadoModel(
          cdEstado: item['stateCdEstado'] as int,
          nmEstado: item['stateNmEstado'] as String? ?? '',
          sgEstado: item['stateSgEstado'] as String? ?? '',
        ),
        companyName: item[CustomerTable.companyName] as String,
        manager: item['managerId'] != null
            ? ManagerModel(
          id: item['managerId'] as int,
          name: item['managerName'] as String? ?? '',
          cpf: item['managerCpf'] as String? ?? '',
          phone: item['managerPhone'] as String? ?? '',
          comission: item['managerComission'] as String? ?? '',
          state: EstadoModel(
            cdEstado: item['managerCodeState'] as int,
            nmEstado: item['stateNmEstado'] as String? ?? '',
            sgEstado: item['stateSgEstado'] as String? ?? '',
          ),
        )
            : null,
      );
    }
    return null;
  }

  Future<bool> registeredStatesVerification(int stateCode) async {
    final database = await getDatabase();
    final result = await database.rawQuery(
      'SELECT * FROM ${CustomerTable.tableName} WHERE ${CustomerTable.codeState} = ?',
      [stateCode],
    );
    return result.isNotEmpty;
  }

//funcao para cadastrar apenas clientes dos estados que ja tem gerentes
  Future<bool> stateVerification(int state) async {
    final database = await getDatabase();
    final result = await database.query(
      ManagerTable.tableName,
      where: '${ManagerTable.codeState} = ?',
      whereArgs: [state],
    );
    return result.isNotEmpty;
  }

  ///funcao insert para inserir dados no banco
  Future<void> insert(CustomerModel customer) async {
    final database = await getDatabase();

    final result = await database.query(
      ManagerTable.tableName,
      where: '${ManagerTable.codeState} = ?',
      whereArgs: [customer.state.cdEstado],
    );

    if (result.isNotEmpty) {
      final manager = result.first;
      customer.manager = ManagerModel(
        id: manager[ManagerTable.id] as int,
        name: manager[ManagerTable.name] as String,
        cpf: manager[ManagerTable.cpf] as String,
        phone: manager[ManagerTable.phone] as String,
        comission: manager[ManagerTable.comission] as String,
        state: customer.state,
      );
    }

    final map = CustomerTable.tomap(customer);
    await database.insert(CustomerTable.tableName, map);
    return;
  }

  ///funcao delete para deletar dados no banco
  Future<void> delete(CustomerModel customer) async {
    final database = await getDatabase();

    await database.delete(
      CustomerTable.tableName,
      where: '${CustomerTable.id} = ?',
      whereArgs: [customer.id],
    );
  }

  ///funcao select para pegar dados no banco
  Future<List<CustomerModel>> select() async {
    final database = await getDatabase();

    final result = await database.rawQuery('''
    SELECT ${CustomerTable.tableName}.*, 
         ${EstadoTable.nmEstado}, 
         ${EstadoTable.cdEstado}, 
         ${EstadoTable.sgEstado},
         ${ManagerTable.tableName}.${ManagerTable.id} as managerId,
           ${ManagerTable.tableName}.${ManagerTable.name} as managerName,
           ${ManagerTable.tableName}.${ManagerTable.cpf} as managerCpf,
           ${ManagerTable.tableName}.${ManagerTable.phone} as managerPhone,
           ${ManagerTable.tableName}.${ManagerTable.comission} as managerComission,
           ${ManagerTable.tableName}.${ManagerTable.codeState} as managerCodeState
    FROM ${CustomerTable.tableName}
    INNER JOIN ${EstadoTable.tableName}
    ON ${CustomerTable.tableName}.${CustomerTable.codeState} = ${EstadoTable.tableName}.${EstadoTable.cdEstado}
    LEFT JOIN ${ManagerTable.tableName}
    ON ${CustomerTable.tableName}.${CustomerTable.managerId} = ${ManagerTable.tableName}.${ManagerTable.id}
    ''');

    var list = <CustomerModel>[];

    for (final item in result) {
      list.add(CustomerModel(
        id: item[CustomerTable.id] as int,
        name: item[CustomerTable.name] as String? ?? '',
        phone: item[CustomerTable.phone] as String? ?? '',
        cnpj: item[CustomerTable.cnpj] as String? ?? '',
        city: item[CustomerTable.city] as String? ?? '',
        state: EstadoModel(
          sgEstado: item[EstadoTable.sgEstado] as String? ?? '',
          nmEstado: item[EstadoTable.nmEstado] as String? ?? '',
          cdEstado: item[EstadoTable.cdEstado] as int,
        ),
        companyName: item[CustomerTable.companyName] as String? ?? '',
        manager: item['managerId'] != null
            ? ManagerModel(
          id: item['managerId'] as int,
          name: item['managerName'] as String? ?? '',
          cpf: item['managerCpf'] as String? ?? '',
          phone: item['managerPhone'] as String? ?? '',
          comission: item['managerComission'] as String? ?? '',
          state: EstadoModel(
            sgEstado: item[EstadoTable.sgEstado] as String? ?? '',
            nmEstado: item[EstadoTable.nmEstado] as String? ?? '',
            cdEstado: item['managerCodeState'] as int,
          ),
        )
            : null,
      ));
    }

    return list;
  }

  Future<void> updateName (int customerId, String newName) async {
    final database = await getDatabase();
    await database.update(
      CustomerTable.tableName,
      {CustomerTable.name: newName},
      where: '${CustomerTable.id} = ?',
      whereArgs: [customerId],
    );
  }

  Future<void> updatePhone (int customerId, String newPhone) async {
    final database = await getDatabase();
    await database.update(
      CustomerTable.tableName,
      {CustomerTable.phone: newPhone},
      where: '${CustomerTable.id} = ?',
      whereArgs: [customerId],
    );
  }

  Future<void> updateCity (int customerId, String newCity) async {
    final database = await getDatabase();
    await database.update(
      CustomerTable.tableName,
      {CustomerTable.city: newCity},
      where: '${CustomerTable.id} = ?',
      whereArgs: [customerId],
    );
  }

}