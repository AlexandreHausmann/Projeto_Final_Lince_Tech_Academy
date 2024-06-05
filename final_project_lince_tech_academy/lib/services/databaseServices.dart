import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/customer.dart';
import '../models/manager.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'ss_automoveis.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE customers(id INTEGER PRIMARY KEY, name TEXT, phone TEXT, cnpj TEXT, city TEXT, state TEXT)',
        );
        db.execute(
          'CREATE TABLE managers(id INTEGER PRIMARY KEY, name TEXT, phone TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertCustomer(Customer customer) async {
    final db = await database;
    await db.insert(
      'customers',
      customer.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCustomer(Customer customer) async {
    final db = await database;
    await db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('customers');
    return List.generate(maps.length, (i) {
      return Customer.fromMap(maps[i]);
    });
  }

  Future<void> insertManager(Manager manager) async {
    final db = await database;
    await db.insert(
      'managers',
      manager.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateManager(Manager manager) async {
    final db = await database;
    await db.update(
      'managers',
      manager.toMap(),
      where: 'id = ?',
      whereArgs: [manager.id],
    );
  }

  Future<List<Manager>> getAllManagers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('managers');
    return List.generate(maps.length, (i) {
      return Manager.fromMap(maps[i]);
    });
  }
}