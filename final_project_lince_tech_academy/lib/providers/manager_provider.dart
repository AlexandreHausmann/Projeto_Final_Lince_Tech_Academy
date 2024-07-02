import 'package:flutter/foundation.dart';
import '../models/manager_model.dart';
import '../services/manager_database_service.dart';

class ManagerProvider with ChangeNotifier {
  final DbManagerService _dbService = DbManagerService();
  List<ManagerModels> _managers = [];

  List<ManagerModels> get managers => [..._managers];

  Future<List<ManagerModels>> fetchManagers() async {
    _managers = await _dbService.getManagers();
    notifyListeners();
    return _managers;
  }

  Future<void> addManager(ManagerModels manager) async {
    final newManager = await _dbService.addManager(manager);
    _managers.add(newManager);
    notifyListeners();
  }

  Future<void> updateManager(ManagerModels manager) async {
    await _dbService.updateManager(manager);
    final index = _managers.indexWhere((m) => m.id == manager.id);
    if (index != -1) {
      _managers[index] = manager;
      notifyListeners();
    }
  }

  Future<void> deleteManager(String id) async {
    await _dbService.deleteManager(id);
    _managers.removeWhere((manager) => manager.id == id);
    notifyListeners();
  }
}
