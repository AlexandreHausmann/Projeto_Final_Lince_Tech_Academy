import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/rent_provider.dart';
import '../models/rent.dart';
import 'rent_form_screen.dart';

class RentListScreen extends StatelessWidget {
  const RentListScreen({Key? key}) : super(key: key);

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
                  return ListTile(
                    title: Text('ID do Aluguel: ${rent.id}'),
                    subtitle: Text('Cliente: ${rent.customerName}\nVeículo: ${rent.vehicleModel}'),
                    onTap: () {
                      Navigator.of(context).pushNamed('/add_rent', arguments: rent);
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Confirmar exclusão'),
                            content: const Text('Deseja realmente cancelar este aluguel?'),
                            actions: [
                              TextButton(
                                child: const Text('Cancelar'),
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Cancelar Aluguel'),
                                onPressed: () {
                                  rentProvider.cancelRent(rent.id!);
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
