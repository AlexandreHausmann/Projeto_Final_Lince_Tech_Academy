import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rent_provider.dart';
import '../models/rent.dart';

class RentListScreen extends StatelessWidget {
  const RentListScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final rentProvider = Provider.of<RentProvider>(context);

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
      body: FutureBuilder(
        future: rentProvider.fetchRents(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Ocorreu um erro ao carregar os aluguéis.'));
          } else {
            return Consumer<RentProvider>(
              builder: (ctx, rentProvider, _) => ListView.builder(
                itemCount: rentProvider.rents.length,
                itemBuilder: (ctx, i) {
                  Rent rent = rentProvider.rents[i];
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
              ),
            );
          }
        },
      ),
    );
  }
}
