import 'package:flutter/material.dart';
import '../models/manager.dart';
import '../services/database_service.dart';

class ManagerProvider with ChangeNotifier {
  List<Manager> _managers = [];

  List<Manager> get managers => _managers;

  ManagerProvider() {
    fetchManagers();
  }

  Future<void> fetchManagers() async {
    final dbService = DatabaseService.instance;
    final dataList = await dbService.getAllManagers();
    _managers = dataList.map((item) => Manager.fromMap(item)).toList();
    notifyListeners();
  }

  Future<void> addManager(Manager manager) async {
    final dbService = DatabaseService.instance;
    await dbService.insertManager(manager);
    await fetchManagers();
  }

  Future<void> updateManager(Manager manager) async {
    final dbService = DatabaseService.instance;
    await dbService.updateManager(manager);
    await fetchManagers();
  }

  Future<void> deleteManager(int id) async {
    final dbService = DatabaseService.instance;
    await dbService.deleteManager(id);
    await fetchManagers();
  }
}
