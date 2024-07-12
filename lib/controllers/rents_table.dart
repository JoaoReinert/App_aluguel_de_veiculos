import 'package:projeto_final_lince/controllers/vehicles_table.dart';

import '../models/rents_model.dart';
import 'customers_table.dart';
import 'database.dart';

class RentsTable {
  static const String createTable = '''
    CREATE TABLE $tableName(
      $id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      $vehicleId INTEGER NOT NULL,
      $customerId INTEGER NOT NULL,
      $initialDate TEXT NOT NULL,
      $finalDate TEXT NOT NULL,
      $price TEXT NOT NULL,
      $totalDays INTEGER NOT NULL,
      $managerCommission REAL NOT NULL,
      FOREIGN KEY ($vehicleId) REFERENCES ${VehicleTable.tableName}(${VehicleTable.id}),
      FOREIGN KEY ($customerId) REFERENCES ${CustomerTable.tableName}(${CustomerTable.id})
    );
  ''';

  static const String tableName = 'rent';

  static const String id = 'id';
  static const String vehicleId = 'vehicle';
  static const String customerId = 'customerId';
  static const String initialDate = 'initialDate';
  static const String finalDate = 'finalDate';
  static const String price = 'price';
  static const String totalDays = 'totalDays';
  static const String managerCommission = 'managerCommission';

  static Map<String, dynamic> toMap(RentsModel rent) {
    final map = <String, dynamic>{};

    map[RentsTable.id] = rent.id;
    map[RentsTable.vehicleId] = rent.vehicleId;
    map[RentsTable.customerId] = rent.customerId;
    map[RentsTable.initialDate] = rent.initialDate.toIso8601String();
    map[RentsTable.finalDate] = rent.finalDate.toIso8601String();
    map[RentsTable.price] = rent.price;
    map[RentsTable.totalDays] = rent.totalDays;
    map[RentsTable.managerCommission] = rent.managerCommission;

    return map;
  }
}

class RentsController {
  Future<void> deleteTable() async {
    final database = await getDatabase();
    await database.delete(RentsTable.tableName);
  }

  Future<void> insert(RentsModel rent) async {
    final database = await getDatabase();
    final map = RentsTable.toMap(rent);

    await database.insert(RentsTable.tableName, map);
    return;
  }

  Future<void> delete(RentsModel rents) async {
    final database = await getDatabase();

    await database.delete(
      RentsTable.tableName,
      where: '${RentsTable.id} = ?',
      whereArgs: [rents.id],
    );
  }

  Future<List<RentsModel>> select() async {
    final database = await getDatabase();
    final List<Map<String, dynamic>> result = await database.query(
      RentsTable.tableName,
    );

    var list = <RentsModel>[];

    for (final item in result) {
      list.add(RentsModel(
        id: item[RentsTable.id] as int,
        vehicleId: item[RentsTable.vehicleId] as int,
        price: item[RentsTable.price] as String,
        totalDays: item[RentsTable.totalDays] as int,
        managerCommission: item[RentsTable.managerCommission],
        customerId: item[RentsTable.customerId] as int,
        initialDate: DateTime.parse(item[RentsTable.initialDate] as String),
        finalDate: DateTime.parse(item[RentsTable.finalDate] as String),
      ));
    }
    return list;
  }

  Future<bool> rentalCustomerVerification (int? customerId) async {
    final database = await getDatabase();
    final result = await database.rawQuery(
      'SELECT * FROM ${RentsTable.tableName} WHERE ${RentsTable.customerId} = ?',
      [customerId],
    );
    return result.isNotEmpty;
  }

  Future<bool> rentalVehicleVerification (int? vehicleId) async {
    final database = await getDatabase();
    final result = await database.rawQuery(
      'SELECT * FROM ${RentsTable.tableName} WHERE ${RentsTable.vehicleId} = ?',
      [vehicleId],
    );
    return result.isNotEmpty;
  }
}