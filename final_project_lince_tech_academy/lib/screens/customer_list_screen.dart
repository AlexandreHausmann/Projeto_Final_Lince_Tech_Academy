import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/customer_provider.dart';
import '../models/customer.dart';
import 'customer_form_screen.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      customerProvider.fetchCustomers();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Clientes'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil(ModalRoute.withName('/'));
          },
        ),
      ),
      body: Consumer<CustomerProvider>(
        builder: (ctx, customerProvider, _) => customerProvider.customers.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: customerProvider.customers.length,
                      itemBuilder: (ctx, i) {
                        Customer customer = customerProvider.customers[i];
                        return ListTile(
                          title: Text(customer.name),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CustomerFormScreen(customer: customer),
                              ),
                            );
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => CustomerFormScreen(customer: customer),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Confirmar exclusão'),
                                      content: const Text('Deseja realmente excluir este cliente?'),
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
                                            customerProvider.deleteCustomer(customer.id!);
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const CustomerFormScreen()),
                        ).then((_) {
                          // After navigating back from adding a new customer, fetch updated list
                          customerProvider.fetchCustomers();
                        });
                      },
                      child: const Text('Adicionar Cliente'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
