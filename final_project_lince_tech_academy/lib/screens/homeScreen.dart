import 'package:flutter/material.dart';
import 'customerListScreen.dart';
import 'manegerListScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SS Automoveis'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerListScreen()),
                );
              },
              child: Text('Clientes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManagerListScreen()),
                );
              },
              child: Text('Gerentes'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navegação para tela de veículos
              },
              child: Text('Veículos'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navegação para tela de aluguéis
              },
              child: Text('Aluguéis'),
            ),
          ],
        ),
      ),
    );
  }
}
