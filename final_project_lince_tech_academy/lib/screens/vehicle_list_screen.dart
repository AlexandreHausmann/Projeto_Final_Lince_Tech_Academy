import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/vehicle_model.dart';
import '../providers/vehicle_provider.dart';
import 'vehicle_form_screen.dart';

/// Tela que exibe a lista de veículos cadastrados.
class VehicleListScreen extends StatelessWidget {
  /// key é uma chave opcional para identificar de forma única o widget.
  const VehicleListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vehicleProvider = Provider.of<VehicleProvider>(context);

    /// Atualiza a lista de veículos ao construir a tela.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vehicleProvider.refreshVehicles();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Veículos'),
        // Botão de voltar que retorna à tela inicial.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil(ModalRoute.withName('/'));
          },
        ),
      ),
      body: Consumer<VehicleProvider>(
        builder: (ctx, vehicleProvider, _) {
          /// Verifica se não há veículos cadastrados.
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
                  // Botão para adicionar um novo veículo.
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
            /// Lista os veículos cadastrados.
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
                /// Botão para adicionar um novo veículo no final da lista.
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

  /// Constrói um item de lista para exibir informações de um veículo.
  Widget _buildVehicleListItem(BuildContext context, VehicleModels vehicle) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text('${vehicle.brand} - ${vehicle.model}'),
        subtitle: Text(
          'Placa: ${vehicle.plate}\nAno: ${vehicle.year}\nCusto Diária: R\$ ${vehicle.dailyRate.toStringAsFixed(2)}',
        ),
        /// Exibe a imagem do veículo.
        leading: _buildVehicleImage(vehicle.imagePath),
        onTap: () {
          /// Navega para a tela de formulário de veículo ao clicar no item da lista para edição.
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => VehicleFormScreen(vehicle: vehicle),
            ),
          );
        },
        /// Ícones para editar e excluir o veículo.
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

  /// Constrói o widget de imagem do veículo.
  Widget _buildVehicleImage(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      // Exibe a imagem do veículo se houver uma imagem válida.
      return CircleAvatar(
        backgroundImage: FileImage(
          File(imagePath),
        ),
      );
    } else {
      /// Exibe um ícone padrão caso não haja imagem disponível.
      return const CircleAvatar(
        child: Icon(Icons.directions_car),
      );
    }
  }

  /// Mostra um diálogo de confirmação para excluir o veículo.
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
