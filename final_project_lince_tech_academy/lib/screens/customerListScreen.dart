import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/customerProvider.dart';
import 'customerFormScreen.dart';

class CustomerListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
      ),
      body: Consumer<CustomerProvider>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.customers.length,
            itemBuilder: (context, index) {
              final customer = provider.customers[index];
              return ListTile(
                title: Text(customer.name),
                subtitle: Text(customer.phone),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomerFormScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
