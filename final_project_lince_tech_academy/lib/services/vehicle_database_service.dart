import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/vehicle.dart';

class VehicleDatabaseService {
  static final VehicleDatabaseService instance = VehicleDatabaseService._init();
  static Database? _database;

  VehicleDatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('vehicles.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE vehicles (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      brand TEXT,
      model TEXT,
      plate TEXT,
      year INTEGER,
      dailyRate REAL,
      imagePath TEXT
    )
    ''');
  }

  Future<List<Map<String, dynamic>>> getAllVehicles() async {
    final db = await instance.database;
    return await db.query('vehicles');
  }

  Future<int> insertVehicle(Vehicle vehicle) async {
    final db = await instance.database;
    return await db.insert('vehicles', vehicle.toMap());
  }

  Future<int> updateVehicle(Vehicle vehicle) async {
    final db = await instance.database;
    return await db.update(
      'vehicles',
      vehicle.toMap(),
      where: 'id = ?',
      whereArgs: [vehicle.id],
    );
  }

  Future<void> deleteVehicle(int vehicleId) async {
    final db = await instance.database;
    await db.delete(
      'vehicles',
      where: 'id = ?',
      whereArgs: [vehicleId],
    );
  }
}
