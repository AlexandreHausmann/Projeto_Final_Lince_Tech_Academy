import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/manager_provider.dart';
import 'manager_form_screen.dart';

class ManagerListScreen extends StatelessWidget {
  const ManagerListScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final managerProvider = Provider.of<ManagerProvider>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      managerProvider.fetchManagers();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Gerentes'),
      ),
      body: Consumer<ManagerProvider>(
        builder: (ctx, managerProvider, _) => managerProvider.managers.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: managerProvider.managers.length,
                      itemBuilder: (ctx, index) {
                        final manager = managerProvider.managers[index];
                        return ListTile(
                          title: Text(manager.name),
                          subtitle: Text(manager.state),
                          trailing: IconButton(
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
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Gerente excluído com sucesso'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ManagerFormScreen(manager: manager),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ManagerFormScreen()),
                      );
                    },
                    child: const Text('Adicionar Gerente'),
                  ),
                ],
              ),
      ),
    );
  }
}
