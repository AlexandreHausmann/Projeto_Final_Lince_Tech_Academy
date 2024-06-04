import 'package:flutter/material.dart';
import 'manegerFormScreen.dart';

class ManagerListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerentes'),
      ),
      body: Center(
        child: Text('Lista de Gerentes conferir no cód '), // falta puxar a lista -> database
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ManagerFormScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
