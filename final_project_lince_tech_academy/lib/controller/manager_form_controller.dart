// manager_controller.dart

import '../models/manager_model.dart';
import '../providers/manager_provider.dart';

class ManagerController {
  final ManagerProvider _provider;

  ManagerController(this._provider);

  Future<void> addManager(ManagerModels manager) async {
    await _provider.addManager(manager);
  }

  Future<void> updateManager(ManagerModels manager) async {
    await _provider.updateManager(manager);
  }

  Future<List<ManagerModels>> fetchManagers() async {
    return await _provider.fetchManagers();
  }
}
