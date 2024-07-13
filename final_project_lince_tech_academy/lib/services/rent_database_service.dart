import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/rent_model.dart';

/// Serviço para gerenciar o banco de dados SQLite para aluguéis.
class RentDatabaseService {
  static final RentDatabaseService instance = RentDatabaseService._init();
  static Database? _database;

  RentDatabaseService._init();

  /// Retorna o banco de dados SQLite, inicializando-o se ainda não estiver inicializado.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('rent.db');
    return _database!;
  }

  /// Inicializa o banco de dados SQLite.
  Future<Database> _initDB(String filePath) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  /// Cria a estrutura do banco de dados ao ser criado pela primeira vez.
  Future<void> _createDB(Database db, int version) async {
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

  /// Insere um novo aluguel no banco de dados.
  Future<void> insertRent(RentModels rent) async {
    final db = await instance.database;
    await db.insert('rents', rent.toMap());
  }

  /// Atualiza um aluguel existente no banco de dados.
  Future<void> updateRent(RentModels rent) async {
    final db = await instance.database;
    await db.update(
      'rents',
      rent.toMap(),
      where: 'id = ?',
      whereArgs: [rent.id],
    );
  }

  /// Retorna uma lista de todos os aluguéis cadastrados no banco de dados.
  Future<List<Map<String, dynamic>>> getAllRents() async {
    final db = await instance.database;
    return await db.query('rents');
  }

  /// Exclui um aluguel do banco de dados com base no ID.
  Future<void> deleteRent(int id) async {
    final db = await instance.database;
    await db.delete(
      'rents',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
