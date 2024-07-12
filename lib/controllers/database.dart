
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'customers_table.dart';
import 'managers_table.dart';
import 'rents_table.dart';
import 'states_table.dart';
import 'vehicles_table.dart';

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
      db.execute(RentsTable.createTable);
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
      if (oldVersion < 7) {
        await db.execute(RentsTable.createTable);
      }
    },
    version: 7,
  );
}










