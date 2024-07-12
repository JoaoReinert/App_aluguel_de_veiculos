import '../models/brands_model.dart';
import '../models/vehicle_models_model.dart';
import '../models/vehicles_model.dart';
import '../models/year_model.dart';
import 'database.dart';

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
  Future<VehiclesModels?> selectId(int vehicleId) async {
    final database = await getDatabase();
    final result = await database.query(
      VehicleTable.tableName,
      where: '${VehicleTable.id} = ?',
      whereArgs: [vehicleId],
    );
    if (result.isNotEmpty) {
      final item = result.first;
      return VehiclesModels(
        id: item[VehicleTable.id] as int,
        type: item[VehicleTable.type] as String,
        brand: BrandsModel(name: item[VehicleTable.brand] as String),
        model: ModelsModel(name: item[VehicleTable.model] as String),
        plate: item[VehicleTable.plate] as String,
        year: YearModel(name: item[VehicleTable.year] as String),
        dailyRate: item[VehicleTable.dailyRate] as String,
      );
    }
    return null;
  }

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

  Future<void> updatePrice(int vehicleId, String newPrice) async {
    final database = await getDatabase();
    await database.update(
      VehicleTable.tableName,
      {VehicleTable.dailyRate: newPrice},
      where: '${VehicleTable.id} = ? ',
      whereArgs: [vehicleId],
    );
  }
}