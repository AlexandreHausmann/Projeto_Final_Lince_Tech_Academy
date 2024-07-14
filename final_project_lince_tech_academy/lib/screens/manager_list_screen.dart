import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/manager_model.dart';
import '../providers/manager_provider.dart';
import 'manager_form_screen.dart';

/// Tela que exibe uma lista de gerentes.
class ManagerListScreen extends StatelessWidget {
  /// Construtor da tela `ManagerListScreen`.
  const ManagerListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final managerProvider = Provider.of<ManagerProvider>(context);

    /// Carrega a lista de gerentes após a construção inicial da tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      managerProvider.fetchManagers();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Gerentes'),
        /// Botão de voltar que retorna à tela inicial
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil(ModalRoute.withName('/'));
          },
        ),
      ),
      body: Consumer<ManagerProvider>(
        builder: (ctx, managerProvider, _) {
          /// Verifica se não há gerentes cadastrados
          if (managerProvider.managers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Não há gerentes cadastrados.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      /// Navega para a tela de adicionar gerente
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ManagerFormScreen()),
                      ).then((_) {
                        managerProvider.fetchManagers();
                      });
                    },
                    child: const Text('Adicionar Gerente'),
                  ),
                ],
              ),
            );
          } else {
            /// Exibe a lista de gerentes cadastrados
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: managerProvider.managers.length,
                    itemBuilder: (ctx, i) {
                      ManagerModels manager = managerProvider.managers[i];
                      return ListTile(
                        title: Text(manager.name),
                        onTap: () {
                          /// Navega para a tela de edição do gerente selecionado
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ManagerFormScreen(manager: manager),
                            ),
                          );
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Botão de editar
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                /// Navega para a tela de edição do gerente selecionado
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ManagerFormScreen(manager: manager),
                                  ),
                                );
                              },
                            ),
                            /// Botão de deletar
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                /// Mostra o diálogo de confirmação para deletar o gerente
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Confirmar exclusão'),
                                    content: const Text('Deseja realmente excluir este gerente?'),
                                    actions: [
                                      TextButton(
                                        child: const Text('Cancelar'),
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Excluir'),
                                        onPressed: () {
                                          managerProvider.deleteManager(manager.id!);
                                          Navigator.of(ctx).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                /// Botão flutuante para adicionar um novo gerente
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navega para a tela de adicionar gerente
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const ManagerFormScreen()),
                      ).then((_) {
                        managerProvider.fetchManagers();
                      });
                    },
                    child: const Text('Adicionar Gerente'),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}