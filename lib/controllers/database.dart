import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../enum_states.dart';
import '../models/brands_model.dart';
import '../models/customers_model.dart';
import '../models/managers_model.dart';
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
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute(
            'ALTER TABLE ${CustomerTable.tableName} ADD COLUMN ${CustomerTable
                .companyName} TEXT NOT NULL DEFAULT ""');
      }
      if (oldVersion < 3) {
        await db.execute(ManagerTable.createTable);
      }
      if(oldVersion < 4) {
        await db.execute(VehicleTable.createTable);
      }
    },
    version: 4,
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
  $companyName TEXT NOT NULL
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

  static Map<String, dynamic> tomap(CustomerModel customer) {
    final map = <String, dynamic>{};

    map[CustomerTable.id] = customer.id;
    map[CustomerTable.name] = customer.name;
    map[CustomerTable.phone] = customer.phone;
    map[CustomerTable.cnpj] = customer.cnpj;
    map[CustomerTable.city] = customer.city;
    map[CustomerTable.state] = customer.state.toString();
    map[CustomerTable.companyName] = customer.companyName;

    return map;
  }
}

///classe para criancao de metodos insert e delete
class CustomerController {
  ///funcao insert para inserir dados no banco
  Future<void> insert(CustomerModel customer) async {
    final database = await getDatabase();
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
    final List<Map<String, dynamic>> result = await database.query(
      CustomerTable.tableName,
    );

    var list = <CustomerModel>[];

    for (final item in result) {
      list.add(CustomerModel(
        id: item[CustomerTable.id],
        name: item[CustomerTable.name] ?? '',
        phone: item[CustomerTable.phone] ?? '',
        cnpj: item[CustomerTable.cnpj] ?? '',
        city: item[CustomerTable.city] ?? '',
        state: States.values.firstWhere(
          orElse: () => States.sc,
              (element) => element.toString() == (item[CustomerTable.state]),
        ),
        companyName: item[CustomerTable.companyName] ?? '',
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
  $state TEXT NOT NULL,
  $phone TEXT NOT NULL,
  $comission TEXT NOT NULL
  );
  ''';

  static const String tableName = 'manager';

  static const String id = 'id';
  static const String name = 'name';
  static const String cpf = 'cpf';
  static const String state = 'state';
  static const String phone = 'phone';
  static const String comission = 'comission';

  static Map<String, dynamic> toMap(ManagerModel manager) {
    final map = <String, dynamic>{};

    map[ManagerTable.id] = manager.id;
    map[ManagerTable.name] = manager.name;
    map[ManagerTable.cpf] = manager.cpf;
    map[ManagerTable.state] = manager.state.toString();
    map[ManagerTable.phone] = manager.phone;
    map[ManagerTable.comission] = manager.comission;

    return map;
  }
}

class ManagerController {
  Future<void> insert(ManagerModel manager) async {
    final database = await getDatabase();
    final map = ManagerTable.toMap(manager);
    print('inserindo gerente------------ $map');
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

    final List<Map<String, dynamic>> result = await database.query(
      ManagerTable.tableName,
    );

    var list = <ManagerModel>[];

    for (final item in result) {
      list.add(ManagerModel(
        id: item[ManagerTable.id],
        name: item[ManagerTable.name] ?? '',
        cpf: item[ManagerTable.cpf] ?? '',
        state: States.values.firstWhere(
          orElse: () => States.sc,
              (element) => element.toString() == (item[ManagerTable.state]),
        ),
        phone: item[ManagerTable.phone] ?? '',
        comission: item[ManagerTable.comission] ?? '',
      ));
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

    await database.delete(VehicleTable.tableName,
      where: '${VehicleTable.id} = ?',
      whereArgs: [vehicle.id],
    );
  }

  Future<List<VehiclesModels>> select() async {
    final database = await getDatabase();
    final List <Map<String, dynamic>> result = await database.query(
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