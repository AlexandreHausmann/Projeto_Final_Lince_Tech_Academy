import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehicle_provider.dart';
import '../models/vehicle_model.dart';

class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<VehicleProvider>(context, listen: false).refreshVehicles();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Veículos'),
      ),
      body: Consumer<VehicleProvider>(
        builder: (ctx, vehicleProvider, _) {
          if (vehicleProvider.vehicles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Não há veículos cadastrados'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/add_vehicle');
                    },
                    child: const Text('Adicionar Veículo'),
                  ),
                ],
              ),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: vehicleProvider.vehicles.length,
                    itemBuilder: (ctx, i) {
                      VehicleModels vehicle = vehicleProvider.vehicles[i];
                      return ListTile(
                        title: Text(vehicle.model),
                        subtitle: Text(vehicle.plate),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.of(context).pushNamed('/add_vehicle', arguments: vehicle);
                              },
                            ),
                            IconButton(
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
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/add_vehicle');
                  },
                  child: const Text('Adicionar Veículo'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
