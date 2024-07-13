import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/manager_model.dart';

/// Serviço para gerenciar o banco de dados SQLite para gerentes.
class DbManagerService {
  static Database? _database;

  /// Retorna o banco de dados SQLite, inicializando-o se ainda não estiver inicializado.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  /// Inicializa o banco de dados SQLite.
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'manager_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Cria a estrutura do banco de dados ao ser criado pela primeira vez.
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

  /// Retorna uma lista de todos os gerentes cadastrados no banco de dados.
  Future<List<ManagerModels>> getManagers() async {
    final db = await database;
    final result = await db.query('managers');
    return result.map((map) => ManagerModels.fromMap(map)).toList();
  }

  /// Adiciona um novo gerente ao banco de dados.
  Future<ManagerModels> addManager(ManagerModels manager) async {
    final db = await database;
    await db.insert('managers', manager.toMap());
    return manager;
  }

  /// Atualiza um gerente existente no banco de dados.
  Future<void> updateManager(ManagerModels manager) async {
    final db = await database;
    await db.update('managers', manager.toMap(), where: 'id = ?', whereArgs: [manager.id]);
  }

  /// Exclui um gerente do banco de dados com base no ID.
  Future<void> deleteManager(String id) async {
    final db = await database;
    await db.delete('managers', where: 'id = ?', whereArgs: [id]);
  }
}
