import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehicle_provider.dart';
import '../models/vehicle.dart';

class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Veículos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/add_vehicle');
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: vehicleProvider.fetchVehicles(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Ocorreu um erro ao carregar os veículos.'));
          } else {
            return Consumer<VehicleProvider>(
              builder: (ctx, vehicleProvider, _) => ListView.builder(
                itemCount: vehicleProvider.vehicles.length,
                itemBuilder: (ctx, i) {
                  Vehicle vehicle = vehicleProvider.vehicles[i];
                  return ListTile(
                    title: Text(vehicle.model),
                    subtitle: Text(vehicle.plate),
                    onTap: () {
                      Navigator.of(context).pushNamed('/add_vehicle', arguments: vehicle);
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Confirmar exclusão'),
                            content: const Text('Deseja realmente excluir este veículo?'),
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
                                  vehicleProvider.deleteVehicle(vehicle.id!);
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
