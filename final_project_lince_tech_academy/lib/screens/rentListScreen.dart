import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/rent.dart';
import '../providers/rentProvider.dart';
import 'rentFormScreen.dart';

class RentListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aluguéis'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/logoFundo.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          Consumer<RentProvider>(
            builder: (context, rentProvider, child) {
              rentProvider.fetchRents();
              final rents = rentProvider.rents;

              return ListView.builder(
                itemCount: rents.length,
                itemBuilder: (context, index) {
                  final rent = rents[index];
                  return ListTile(
                    title: Text(rent.clientName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Veículo: ${rent.vehicleModel}'),
                        Text('Início: ${rent.startDate.toLocal()}'.split(' ')[0]),
                        Text('Término: ${rent.endDate.toLocal()}'.split(' ')[0]),
                        Text('Total de dias: ${rent.totalDays}'),
                        Text('Valor total: R\$${rent.totalAmount.toStringAsFixed(2)}'),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RentFormScreen(rent: rent)),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
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
