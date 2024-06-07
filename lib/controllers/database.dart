import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/customersModel.dart';

Future<Database> getDatabase() async {
  final path = join(
    await getDatabasesPath(),
    'customers.db',
  );

  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(CustomerTable.createTable);
    },
    version: 1,
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
  ''';

  static const String tableName = 'customer';

  static const String id = 'id';

  static const String name = 'name';

  static const String phone = 'phone';

  static const String cnpj = 'cnpj';

  static const String city = 'city';

  static const String state = 'state';

  static Map<String, dynamic> tomap(CustomerModel customer) {
    final map = <String, dynamic>{};

    map[CustomerTable.id] = customer.id;
    map[CustomerTable.name] = customer.name;
    map[CustomerTable.phone] = customer.phone;
    map[CustomerTable.cnpj] = customer.cnpj;
    map[CustomerTable.city] = customer.city;
    map[CustomerTable.state] = customer.state;

    return map;
  }
}

class CustomerController {
  Future<void> insert(CustomerModel customer) async {
    final database = await getDatabase();
    final map = CustomerTable.tomap(customer);

    await database.insert(CustomerTable.tableName, map);

    return;
  }

  Future<void> delete(CustomerModel customer) async {
    final database = await getDatabase();

    database.delete(
      CustomerTable.tableName,
      where: '${CustomerTable.id} = ?',
      whereArgs: [customer.id],
    );
  }

  Future<List<CustomerModel>> select() async {
    final database = await getDatabase();
    final List<Map<String, dynamic>> result = await database.query(
      CustomerTable.tableName,
    );

    var list = <CustomerModel>[];

    for (final item in result) {
      list.add(
        CustomerModel(
          id: item[CustomerTable.id],
          name: item[CustomerTable.name],
          phone: item[CustomerTable.phone],
          cnpj: item[CustomerTable.cnpj],
          city: item[CustomerTable.city],
          state: item[CustomerTable.state],
        ),
      );
    }

    return list;
  }
}
