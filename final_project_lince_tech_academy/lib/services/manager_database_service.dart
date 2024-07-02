import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/manager_model.dart';

class DbManagerService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'manager_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE managers(
        id TEXT PRIMARY KEY,
        name TEXT,
        cpf TEXT,
        state TEXT,
        phone TEXT,
        commissionPercentage REAL
      )
    ''');
  }

  Future<List<ManagerModels>> getManagers() async {
    final db = await database;
    final result = await db.query('managers');
    return result.map((map) => ManagerModels.fromMap(map)).toList();
  }

  Future<ManagerModels> addManager(ManagerModels manager) async {
    final db = await database;
    await db.insert('managers', manager.toMap());
    return manager;
  }

  Future<void> updateManager(ManagerModels manager) async {
    final db = await database;
    await db.update('managers', manager.toMap(), where: 'id = ?', whereArgs: [manager.id]);
  }

  Future<void> deleteManager(String id) async {
    final db = await database;
    await db.delete('managers', where: 'id = ?', whereArgs: [id]);
  }
}
