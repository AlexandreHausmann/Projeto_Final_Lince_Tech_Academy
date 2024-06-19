import 'package:flutter/material.dart';
import '../models/manager.dart';
import '../services/manager_database_service.dart';

class ManagerProvider extends ChangeNotifier {
  final ManagerDatabaseService _dbService = ManagerDatabaseService.instance;
  List<Manager> _managers = [];

  List<Manager> get managers => _managers;

  void fetchManagers() {
    _dbService.getAllManagers().then((fetchedManagers) {
      _managers = fetchedManagers.map((e) => Manager.fromMap(e)).toList();
      notifyListeners();
    }).catchError((error) {
    });
  }

  void addManager(Manager manager) {
    _dbService.insertManager(manager).then((_) {
      fetchManagers();
    }).catchError((error) {
    });
  }

  void updateManager(Manager manager) {
    _dbService.updateManager(manager).then((_) {
      fetchManagers();
    }).catchError((error) {
    });
  }

  void deleteManager(int id) {
    _dbService.deleteManager(id).then((_) {
      fetchManagers();
    }).catchError((error) {
    });
  }
}
