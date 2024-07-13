import 'package:flutter/foundation.dart';
import '../models/manager_model.dart';
import '../services/manager_database_service.dart';

/// Provider responsável por gerenciar o estado e lógica de negócios relacionados aos gerentes.
class ManagerProvider with ChangeNotifier {
  final DbManagerService _dbService = DbManagerService();
  List<ManagerModels> _managers = [];


/// Lista de gerentes armazenados no provider.
  List<ManagerModels> get managers => List<ManagerModels>.from(_managers);

  /// Busca a lista de gerentes do serviço de banco de dados e notifica os ouvintes sobre as alterações.
  Future<List<ManagerModels>> fetchManagers() async {
    _managers = await _dbService.getManagers();
    notifyListeners();
    return _managers;
  }

  /// Adiciona um novo gerente utilizando o serviço de banco de dados e atualiza a lista de gerentes.
  Future<void> addManager(ManagerModels manager) async {
    final newManager = await _dbService.addManager(manager);
    _managers.add(newManager);
    notifyListeners();
  }

  /// Atualiza um gerente existente utilizando o serviço de banco de dados e atualiza a lista de gerentes.
  Future<void> updateManager(ManagerModels manager) async {
    await _dbService.updateManager(manager);
    final index = _managers.indexWhere((m) => m.id == manager.id);
    if (index != -1) {
      _managers[index] = manager;
      notifyListeners();
    }
  }

  /// Deleta um gerente pelo seu ID utilizando o serviço de banco de dados e atualiza a lista de gerentes.
  Future<void> deleteManager(String id) async {
    await _dbService.deleteManager(id);
    _managers.removeWhere((manager) => manager.id == id);
    notifyListeners();
  }
}
