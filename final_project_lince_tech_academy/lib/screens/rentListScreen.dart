import 'package:final_project_lince_tech_academy/screens/rentFormScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rent.dart';
import '../providers/rentProvider.dart';
import 'package:intl/intl.dart';

class RentListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aluguéis Realizados'),
      ),
      body: Consumer<RentProvider>(
        builder: (context, rentProvider, child) {
          rentProvider.fetchRents();
          final rents = rentProvider.rents;

          return ListView.builder(
            itemCount: rents.length,
            itemBuilder: (context, index) {
              final rent = rents[index];
              return ListTile(
                title: Text('Cliente: ${rent.clientId}'), // Substitua pelo nome do cliente
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Data de Início: ${DateFormat.yMd().format(rent.startDate)}'),
                    Text('Data de Término: ${DateFormat.yMd().format(rent.endDate)}'),
                    Text('Número de Dias: ${rent.numberOfDays}'),
                    Text('Valor Total: R\$ ${rent.totalAmount.toStringAsFixed(2)}'),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RentFormScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}