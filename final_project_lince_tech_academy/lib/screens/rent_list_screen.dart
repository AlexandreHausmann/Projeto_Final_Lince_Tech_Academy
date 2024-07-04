import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rent_provider.dart';
import '../models/rent_model.dart';

class RentListScreen extends StatelessWidget {
  const RentListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<RentProvider>(context, listen: false).fetchRents();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Aluguéis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/add_rent');
            },
          ),
        ],
      ),
      body: Consumer<RentProvider>(
        builder: (ctx, rentProvider, _) {
          if (rentProvider.rents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Não há aluguéis cadastrados'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/add_rent');
                    },
                    child: const Text('Adicionar Aluguel'),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: rentProvider.rents.length,
              itemBuilder: (ctx, i) {
                RentModels rent = rentProvider.rents[i];
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Confirmar exclusão'),
                        content: const Text('Deseja realmente excluir este aluguel?'),
                        actions: [
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () => Navigator.of(ctx).pop(false),
                          ),
                          TextButton(
                            child: const Text('Excluir'),
                            onPressed: () => Navigator.of(ctx).pop(true),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    rentProvider.cancelRent(rent.id!);
                  },
                  child: ListTile(
                    title: Text('Aluguel ${rent.id}'),
                    subtitle: Text('Cliente: ${rent.customerName} - Veículo: ${rent.vehicleModel}'),
                    onTap: () {
                      Navigator.of(context).pushNamed('/add_rent', arguments: rent);
                    },
                    trailing: const Icon(Icons.arrow_forward),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
