import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/customer.dart';
import '../models/manager.dart';
import '../models/rent.dart';

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

  Future _createDB(Database db, int version) async {
    const customerTable = '''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT,
        cnpj TEXT,
        city TEXT,
        state TEXT
      )
    ''';

    const managerTable = '''
      CREATE TABLE managers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        cpf TEXT,
        state TEXT,
        phone TEXT,
        commissionPercentage REAL
      )
    ''';

    const rentTable = '''
      CREATE TABLE rents (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customerId INTEGER,
        startDate TEXT,
        endDate TEXT,
        totalDays INTEGER,
        totalAmount REAL,
        FOREIGN KEY (customerId) REFERENCES customers(id)
      )
    ''';

    await db.execute(customerTable);
    await db.execute(managerTable);
    await db.execute(rentTable);
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

  Future<List<Map<String, dynamic>>> getAllManagers() async {
    final db = await instance.database;
    return await db.query('managers');
  }

  // Rent methods
  Future<void> insertRent(Rent rent) async {
    final db = await instance.database;
    await db.insert('rents', rent.toMap());
  }

  Future<void> updateRent(Rent rent) async {
    final db = await instance.database;
    await db.update(
      'rents',
      rent.toMap(),
      where: 'id = ?',
      whereArgs: [rent.id],
    );
  }

  Future<void> deleteRent(int id) async {
    final db = await instance.database;
    await db.delete(
      'rents',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getAllRents() async {
    final db = await instance.database;
    return await db.query('rents');
  }
}