import 'package:flutter/material.dart';
import '../models/manager_model.dart';
import '../services/manager_database_service.dart';

class ManagerProvider extends ChangeNotifier {
  final ManagerDatabaseService _dbService = ManagerDatabaseService.instance;
  List<ManagerModels> _managers = [];

  List<ManagerModels> get managers => _managers;

  void fetchManagers() {
    _dbService.getAllManagers().then((fetchedManagers) {
      _managers = fetchedManagers.map((e) => ManagerModels.fromMap(e)).toList();
      notifyListeners();
    }).catchError((error) {
    });
  }

  void addManager(ManagerModels manager) {
    _dbService.insertManager(manager).then((_) {
      fetchManagers();
    }).catchError((error) {
    });
  }

  void updateManager(ManagerModels manager) {
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
