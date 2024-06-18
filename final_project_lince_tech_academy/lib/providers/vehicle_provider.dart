import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/vehicle_database_service.dart';

class VehicleProvider extends ChangeNotifier {
  final VehicleDatabaseService _dbService = VehicleDatabaseService.instance;
  List<Vehicle> _vehicles = [];

  List<Vehicle> get vehicles => _vehicles;

  Future<void> fetchVehicles() async {
    final fetchedVehicles = await _dbService.getAllVehicles();
    _vehicles = fetchedVehicles.map((e) => Vehicle.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    await _dbService.insertVehicle(vehicle);
    await fetchVehicles();
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    await _dbService.updateVehicle(vehicle);
    await fetchVehicles();
  }

  Future<void> deleteVehicle(int id) async {
    await _dbService.deleteVehicle(id);
    await fetchVehicles(); 
  }
}
