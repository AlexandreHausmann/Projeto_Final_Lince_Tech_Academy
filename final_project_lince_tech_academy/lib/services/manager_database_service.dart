import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/manager.dart';

class ManagerDatabaseService {
  static final ManagerDatabaseService instance = ManagerDatabaseService._init();
  static Database? _database;

  ManagerDatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE managers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        cpf TEXT,
        state TEXT,
        phone TEXT,
        commissionPercentage REAL
      )
    ''');
  }

  Future<void> insertManager(Manager manager) async {
    final db = await instance.database;
    await db.insert('managers', manager.toMap());
  }

  Future<void> updateManager(Manager manager) async {
    final db = await instance.database;
    await db.update(
      'managers',
      manager.toMap(),
      where: 'id = ?',
      whereArgs: [manager.id],
    );
  }

  Future<void> deleteManager(int managerId) async {
    final db = await instance.database;
    await db.delete(
      'managers',
      where: 'id = ?',
      whereArgs: [managerId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllManagers() async {
    final db = await instance.database;
    return db.query('managers');
  }
}
