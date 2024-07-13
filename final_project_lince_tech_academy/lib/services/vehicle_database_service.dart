import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/vehicle_model.dart';

/// Serviço para gerenciar o banco de dados SQLite para veículos.
class VehicleDatabaseService {
  static final VehicleDatabaseService instance = VehicleDatabaseService._init();
  static Database? _database;

  VehicleDatabaseService._init();

  /// Retorna o banco de dados SQLite, inicializando-o se ainda não estiver inicializado.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('vehicles.db');
    return _database!;
  }

  /// Inicializa o banco de dados SQLite.
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Cria a estrutura do banco de dados ao ser criado pela primeira vez.
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

  /// Retorna uma lista de todos os veículos cadastrados no banco de dados.
  Future<List<Map<String, dynamic>>> getAllVehicles() async {
    final db = await instance.database;
    return db.query('vehicles');
  }

  /// Insere um novo veículo no banco de dados.
  /// Retorna o ID do veículo inserido.
  Future<int> insertVehicle(VehicleModels vehicle) async {
    final db = await instance.database;
    return db.insert('vehicles', vehicle.toMap());
  }

  /// Atualiza um veículo existente no banco de dados.
  /// Retorna o número de linhas afetadas.
  Future<int> updateVehicle(VehicleModels vehicle) async {
    final db = await instance.database;
    return db.update(
      'vehicles',
      vehicle.toMap(),
      where: 'id = ?',
      whereArgs: [vehicle.id],
    );
  }

  /// Exclui um veículo do banco de dados com base no ID.
  Future<void> deleteVehicle(int vehicleId) async {
    final db = await instance.database;
    await db.delete(
      'vehicles',
      where: 'id = ?',
      whereArgs: [vehicleId],
    );
  }
}
