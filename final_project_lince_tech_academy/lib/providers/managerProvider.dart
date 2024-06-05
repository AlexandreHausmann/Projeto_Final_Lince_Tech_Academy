import 'package:flutter/material.dart';
import '../models/manager.dart';
import '../services/databaseServices.dart';

class ManagerProvider with ChangeNotifier {
  List<Manager> _managers = [];

  List<Manager> get managers => _managers;

  Future<void> fetchManagers() async {
    final dataList = await DatabaseService.instance.getAllManagers();
    _managers = dataList.map((item) => Manager.fromMap(item as Map<String, dynamic>)).toList();
    notifyListeners();
  }

  void addManager(Manager manager) {
    DatabaseService.instance.insertManager(manager);
    _managers.add(manager);
    notifyListeners();
  }

  void updateManager(Manager manager) {
    DatabaseService.instance.updateManager(manager);
    final index = _managers.indexWhere((m) => m.id == manager.id);
    if (index != -1) {
      _managers[index] = manager;
      notifyListeners();
    }
  }
}