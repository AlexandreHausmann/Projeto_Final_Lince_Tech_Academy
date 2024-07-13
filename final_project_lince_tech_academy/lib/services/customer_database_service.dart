import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/customer_model.dart';

/// Serviço para gerenciar o banco de dados SQLite para clientes.
class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  /// Construtor privado para inicializar a instância única do serviço de banco de dados.
  DatabaseService._init();

  /// Retorna o banco de dados SQLite, inicializando-o se ainda não estiver inicializado.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  /// Inicializa o banco de dados SQLite.
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Cria a estrutura do banco de dados ao ser criado pela primeira vez.
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
  }

  /// Insere um novo cliente no banco de dados.
  Future<void> insertCustomer(CustomerModels customer) async {
    final db = await instance.database;
    db.insert('customers', customer.toMap());
  }

  /// Atualiza um cliente existente no banco de dados.
  Future<void> updateCustomer(CustomerModels customer) async {
    final db = await instance.database;
    db.update(
      'customers',
      customer.toMap(),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  /// Exclui um cliente do banco de dados.
  Future<void> deleteCustomer(int customerId) async {
    final db = await instance.database;
    db.delete(
      'customers',
      where: 'id = ?',
      whereArgs: [customerId],
    );
  }

  /// Retorna todos os clientes cadastrados no banco de dados.
  Future<List<Map<String, dynamic>>> getAllCustomers() async {
    final db = await instance.database;
    return db.query('customers');
  }
}
