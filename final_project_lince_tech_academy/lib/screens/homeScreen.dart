import 'package:flutter/material.dart';
import 'customerListScreen.dart';
import 'managerListScreen.dart';
import 'customerFormScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/logoFundo.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.7),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SS Automóveis',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 24,
                    color: Color.fromARGB(255, 159, 194, 191),
                  ),
                ),
                SizedBox(height: 20),
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
        ],
      ),
    );
  }
}