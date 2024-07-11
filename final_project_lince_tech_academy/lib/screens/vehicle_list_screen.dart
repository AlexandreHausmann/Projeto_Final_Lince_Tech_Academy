import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vehicle_provider.dart';
import '../models/vehicle_model.dart';
import 'vehicle_form_screen.dart';

class VehicleListScreen extends StatelessWidget {
  const VehicleListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      vehicleProvider.refreshVehicles();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Veículos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil(ModalRoute.withName('/'));
          },
        ),
      ),
      body: Consumer<VehicleProvider>(
        builder: (ctx, vehicleProvider, _) {
          if (vehicleProvider.vehicles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Não há veículos cadastrados.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const VehicleFormScreen()),
                      ).then((_) {
                        vehicleProvider.refreshVehicles();
                      });
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
                    itemBuilder: (ctx, index) {
                      VehicleModels vehicle = vehicleProvider.vehicles[index];
                      return _buildVehicleListItem(context, vehicle);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const VehicleFormScreen()),
                      ).then((_) {
                        vehicleProvider.refreshVehicles();
                      });
                    },
                    child: const Text('Adicionar Veículo'),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildVehicleListItem(BuildContext context, VehicleModels vehicle) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text('${vehicle.brand} - ${vehicle.model}'),
        subtitle: Text(
          'Placa: ${vehicle.plate}\nAno: ${vehicle.year}\nCusto Diária: R\$ ${vehicle.dailyRate.toStringAsFixed(2)}',
        ),
        leading: _buildVehicleImage(vehicle.imagePath), // Display the vehicle image
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => VehicleFormScreen(vehicle: vehicle),
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
                    builder: (_) => VehicleFormScreen(vehicle: vehicle),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmationDialog(context, vehicle);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleImage(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: FileImage(
          File(imagePath),
        ),
      );
    } else {
      return const CircleAvatar(
        child: Icon(Icons.directions_car),
      );
    }
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, VehicleModels vehicle) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja excluir este veículo?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: const Text('Confirmar'),
            onPressed: () async {
              await Provider.of<VehicleProvider>(context, listen: false).deleteVehicle(vehicle.id!);
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
