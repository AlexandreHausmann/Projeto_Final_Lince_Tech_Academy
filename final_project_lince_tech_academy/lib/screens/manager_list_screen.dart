import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/manager_provider.dart';
import '../models/manager.dart';
import 'manager_form_screen.dart';

class ManagerListScreen extends StatelessWidget {
  const ManagerListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final managerProvider = Provider.of<ManagerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Gerentes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/add_manager');
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: managerProvider.fetchManagers(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Ocorreu um erro ao carregar os gerentes.'));
          } else {
            return Consumer<ManagerProvider>(
              builder: (ctx, managerProvider, _) => ListView.builder(
                itemCount: managerProvider.managers.length,
                itemBuilder: (ctx, i) {
                  Manager manager = managerProvider.managers[i];
                  return ListTile(
                    title: Text(manager.name),
                    subtitle: Text(manager.phone),
                    onTap: () {
                      Navigator.of(context).pushNamed('/add_manager', arguments: manager);
                    },
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
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
