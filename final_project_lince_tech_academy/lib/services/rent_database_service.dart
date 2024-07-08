import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/rent_model.dart';

class RentDatabaseService {
  static final RentDatabaseService instance = RentDatabaseService._init();
  static Database? _database;

  RentDatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('rent.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE rents (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clientName TEXT,
        vehicleModel TEXT,
        startDate TEXT,
        endDate TEXT,
        totalDays INTEGER,
        totalAmount REAL
      )
    ''');
  }

  Future<void> insertRent(RentModels rent) async {
    final db = await instance.database;
    await db.insert('rents', rent.toMap());
  }

  Future<void> updateRent(RentModels rent) async {
    final db = await instance.database;
    await db.update(
      'rents',
      rent.toMap(),
      where: 'id = ?',
      whereArgs: [rent.id],
    );
  }

  Future<List<Map<String, dynamic>>> getAllRents() async {
    final db = await instance.database;
    return await db.query('rents');
  }

  Future<void> deleteRent(int id) async {
    final db = await instance.database;
    await db.delete(
      'rents',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
