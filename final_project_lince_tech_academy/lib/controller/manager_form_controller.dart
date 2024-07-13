import '../models/manager_model.dart';
import '../providers/manager_provider.dart';

/// Classe Controller para gerenciar operações relacionadas aos gerentes.
class ManagerController {
  final ManagerProvider _provider;

  /// Construtor que requer uma instância de [ManagerProvider].
  ManagerController(this._provider);

  /// Adiciona um novo gerente ao provedor de dados.
  /// [manager]: O modelo de gerente a ser adicionado.
  Future<void> addManager(ManagerModels manager) async {
    await _provider.addManager(manager);
  }

  /// Atualiza um gerente existente no provedor de dados.
  /// [manager]: O modelo de gerente com informações atualizadas.
  Future<void> updateManager(ManagerModels manager) async {
    await _provider.updateManager(manager);
  }

  /// Busca uma lista de todos os gerentes do provedor de dados.
  /// Retorna uma lista de [ManagerModels].
  Future<List<ManagerModels>> fetchManagers() async {
    return await _provider.fetchManagers();
  }
}
