import 'dart:io';
import 'package:final_project_lince_tech_academy/providers/vehicleProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'vehicleFormScreen.dart';

class VehicleListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Veículos'),
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
          Consumer<VehicleProvider>(
            builder: (context, vehicleProvider, child) {
              vehicleProvider.fetchVehicles();
              final vehicles = vehicleProvider.vehicles;

              return ListView.builder(
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  return ListTile(
                    leading: vehicle.imagePath.isEmpty
                        ? Icon(Icons.directions_car)
                        : Image.file(File(vehicle.imagePath), width: 50, height: 50),
                    title: Text(vehicle.brand),
                    subtitle: Text(vehicle.model),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VehicleFormScreen(vehicle: vehicle)),
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
            MaterialPageRoute(builder: (context) => VehicleFormScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}