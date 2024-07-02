import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/manager_provider.dart';
import '../models/manager_model.dart';
import 'manager_form_screen.dart';

class ManagerListScreen extends StatelessWidget {
  const ManagerListScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final managerProvider = Provider.of<ManagerProvider>(context);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      managerProvider.fetchManagers();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Gerentes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil(ModalRoute.withName('/'));
          },
        ),
      ),
      body: Consumer<ManagerProvider>(
        builder: (ctx, managerProvider, _) {
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ManagerFormScreen(manager: manager),
                            ),
                          );
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ManagerFormScreen(manager: manager),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
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
