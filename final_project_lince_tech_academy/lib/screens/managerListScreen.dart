import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'managerFormScreen.dart';
import '../providers/managerProvider.dart';

class ManagerListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerentes'),
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
          Consumer<ManagerProvider>(
            builder: (context, provider, child) {
              return ListView.builder(
                itemCount: provider.managers.length,
                itemBuilder: (context, index) {
                  final manager = provider.managers[index];
                  return ListTile(
                    title: Text(manager.name),
                    subtitle: Text(manager.phone),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ManagerFormScreen(manager: manager)),
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
            MaterialPageRoute(builder: (context) => ManagerFormScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}