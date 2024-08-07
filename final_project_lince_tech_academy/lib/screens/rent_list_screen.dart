import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/rent_model.dart';
import '../providers/rent_provider.dart';
import 'rent_form_screen.dart';

/// Tela que exibe a lista de contratos de aluguel.
class RentListScreen extends StatelessWidget {
/// key é uma chave opcional para identificar de forma única o widget.
  const RentListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rentProvider = Provider.of<RentProvider>(context);

    /// Carrega os contratos de aluguel após a construção inicial da tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      rentProvider.fetchRents();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Aluguéis'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil(ModalRoute.withName('/'));
          },
        ),
      ),
      body: Consumer<RentProvider>(
        builder: (ctx, rentProvider, _) {
          if (rentProvider.rents.isEmpty) {
            /// Exibe uma mensagem se não houver contratos de aluguel cadastrados
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Não há aluguéis cadastrados'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      /// Navega para a tela de formulário para adicionar um novo aluguel
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RentFormScreen()),
                      ).then((_) {
                        rentProvider.fetchRents();
                      });
                    },
                    child: const Text('Adicionar Aluguel'),
                  ),
                ],
              ),
            );
          } else {
            // Exibe a lista de contratos de aluguel
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: rentProvider.rents.length,
                    itemBuilder: (ctx, i) {
                      RentModels rent = rentProvider.rents[i];
                      return ListTile(
                        title: Text(rent.clientName),
                        subtitle: Text('Veículo: ${rent.vehicleModel} - Valor: R\$ ${rent.totalAmount.toStringAsFixed(2)}'),
                        onTap: () {
                          /// Navega para a tela de formulário para visualizar ou editar o aluguel selecionado
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RentFormScreen(rent: rent),
                            ),
                          );
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Navega para a tela de formulário para editar o aluguel selecionado
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => RentFormScreen(rent: rent),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // Exibe um diálogo de confirmação para exclusão do aluguel
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Confirmar exclusão'),
                                    content: const Text('Deseja realmente excluir este aluguel?'),
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
                                          rentProvider.cancelRent(rent.id!);
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
                // Botão para adicionar um novo aluguel
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RentFormScreen()),
                      ).then((_) {
                        rentProvider.fetchRents();
                      });
                    },
                    child: const Text('Adicionar Aluguel'),
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