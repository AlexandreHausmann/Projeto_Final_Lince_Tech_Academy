import 'package:flutter/material.dart';
import '../models/rent_model.dart';
import '../services/rent_database_service.dart';

/// Provider responsável por gerenciar o estado e lógica de negócios relacionados aos aluguéis.
class RentProvider extends ChangeNotifier {
  final RentDatabaseService _dbService = RentDatabaseService.instance;
  List<RentModels> _rents = [];

  /// Lista de contratos de aluguel armazenados no provider.
  List<RentModels> get rents => [..._rents];
  
  /// Busca a lista de aluguéis do serviço de banco de dados e notifica os ouvintes sobre as alterações.
  Future<void> fetchRents() async {
    final fetchedRents = await _dbService.getAllRents();
    _rents = fetchedRents.map(RentModels.fromMap).toList();
    notifyListeners();
  }

  /// Adiciona um novo aluguel utilizando o serviço de banco de dados e atualiza a lista de aluguéis.
  Future<void> addRent(RentModels rent) async {
    await _dbService.insertRent(rent);
    await fetchRents();
  }

  /// Atualiza um aluguel existente utilizando o serviço de banco de dados e atualiza a lista de aluguéis.
  Future<void> updateRent(RentModels rent) async {
    await _dbService.updateRent(rent);
    await fetchRents();
  }

  /// Cancela um aluguel pelo seu ID utilizando o serviço de banco de dados e atualiza a lista de aluguéis.
  Future<void> cancelRent(int id) async {
    await _dbService.deleteRent(id);
    _rents.removeWhere((rent) => rent.id == id);
    notifyListeners();
  }
}
