import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/brands_model.dart';
import '../models/customers_model.dart';
import '../models/managers_model.dart';
import '../models/state_model.dart';
import '../models/vehicle_models_model.dart';
import '../models/vehicles_model.dart';
import '../models/year_model.dart';

///iniciando o banco de dados
Future<Database> getDatabase() async {
  final path = join(
    await getDatabasesPath(),
    'customers.db',
  );

  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(CustomerTable.createTable);
      db.execute(ManagerTable.createTable);
      db.execute(VehicleTable.createTable);
      db.execute(EstadoTable.createTable);
      EstadoTable.insertInitialData(db);
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute(
            'ALTER TABLE ${CustomerTable.tableName} ADD COLUMN ${CustomerTable.companyName} TEXT NOT NULL DEFAULT ""');
      }
      if (oldVersion < 3) {
        await db.execute(ManagerTable.createTable);
      }
      if (oldVersion < 4) {
        await db.execute(VehicleTable.createTable);
      }
      if (oldVersion < 5) {
        await db.execute(EstadoTable.createTable);
      }
      if (oldVersion < 6) {
        await EstadoTable.insertInitialData(db);
      }
    },
    version: 6,
  );
}

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
    map[CustomerTable.state] = customer.state.toString();
    map[CustomerTable.companyName] = customer.companyName;
    map[CustomerTable.codeState] = customer.state.cdEstado;
    map[CustomerTable.managerId] = customer.manager?.id;

    return map;
  }
}

///classe para criancao de metodos insert e delete
class CustomerController {
  ///funcao para cadastrar apenas clientes dos estados que ja tem gerentes
  Future<bool> stateVerification(int state) async{
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
}

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

class ManagerController {
  Future<void> insert(ManagerModel manager) async {
    final database = await getDatabase();
    final map = ManagerTable.toMap(manager);
    await database.insert(ManagerTable.tableName, map);

    return;
  }

  Future<void> delete(ManagerModel manager) async {
    final database = await getDatabase();

    database.delete(ManagerTable.tableName,
        where: '${ManagerTable.id} = ?', whereArgs: [manager.id]);
  }

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
}

class VehicleTable {
  static const String createTable = '''
  CREATE TABLE $tableName(
  $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
  $type TEXT NOT NULL,
  $brand TEXT NOT NULL,
  $model TEXT NOT NULL,
  $year TEXT NOT NULL,
  $plate TEXT NOT NULL,
  $dailyRate TEXT NOT NULL
  );
  ''';

  static const String tableName = 'vehicle';

  static const String id = 'id';
  static const String type = 'type';
  static const String brand = 'brand';
  static const String model = 'model';
  static const String year = 'year';
  static const String plate = 'plate';
  static const String dailyRate = 'dailyRate';

  static Map<String, dynamic> toMap(VehiclesModels vehicle) {
    final map = <String, dynamic>{};

    map[VehicleTable.id] = vehicle.id;
    map[VehicleTable.type] = vehicle.type.toString();
    map[VehicleTable.brand] = vehicle.brand!.name;
    map[VehicleTable.model] = vehicle.model!.name;
    map[VehicleTable.year] = vehicle.year!.name;
    map[VehicleTable.plate] = vehicle.plate;
    map[VehicleTable.dailyRate] = vehicle.dailyRate;

    return map;
  }
}

class VehicleController {
  Future<void> insert(VehiclesModels vehicle) async {
    final database = await getDatabase();
    final map = VehicleTable.toMap(vehicle);

    await database.insert(VehicleTable.tableName, map);
    return;
  }

  Future<void> delete(VehiclesModels vehicle) async {
    final database = await getDatabase();

    await database.delete(
      VehicleTable.tableName,
      where: '${VehicleTable.id} = ?',
      whereArgs: [vehicle.id],
    );
  }

  Future<List<VehiclesModels>> select() async {
    final database = await getDatabase();
    final List<Map<String, dynamic>> result = await database.query(
      VehicleTable.tableName,
    );

    var list = <VehiclesModels>[];

    for (final item in result) {
      list.add(VehiclesModels(
        id: item[VehicleTable.id],
        type: item[VehicleTable.type],
        brand: BrandsModel(name: item['brand']),
        model: ModelsModel(name: item['model']),
        plate: item[VehicleTable.plate],
        year: YearModel(name: item['year']),
        dailyRate: item[VehicleTable.dailyRate],
      ));
    }
    return list;
  }
}

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
