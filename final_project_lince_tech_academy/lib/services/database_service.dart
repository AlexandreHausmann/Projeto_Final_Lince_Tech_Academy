import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/customer.dart';
import '../models/manager.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

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
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT,
        cnpj TEXT,
        city TEXT,
        state TEXT
      )
    ''');

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

  // Customer methods
  Future<void> insertCustomer(Customer customer) async {
    final db = await instance.database;
    await db.insert('customers', customer.toMap());
  }

  Future<void> updateCustomer(Customer customer) async {
    final db = await instance.database;
    await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<void> deleteCustomer(int customerId) async {
    final db = await instance.database;
    await db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [customerId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    final db = await instance.database;
    return await db.query('customers');
  }

  // Manager methods
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
    return await db.query('managers');
  }
}