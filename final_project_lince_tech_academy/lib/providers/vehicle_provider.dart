import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/vehicle_database_service.dart';

class VehicleProvider with ChangeNotifier {
  List<Vehicle> _vehicles = [];

  List<Vehicle> get vehicles => _vehicles;

  Future<void> fetchVehicles() async {
    final vehicleDBService = VehicleDatabaseService.instance;
    final dataList = await vehicleDBService.getAllVehicles();
    _vehicles = dataList.map((item) => Vehicle.fromMap(item)).toList();
    notifyListeners();
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    final vehicleDBService = VehicleDatabaseService.instance;
    await vehicleDBService.insertVehicle(vehicle);
    await fetchVehicles();
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    final vehicleDBService = VehicleDatabaseService.instance;
    await vehicleDBService.updateVehicle(vehicle);
    await fetchVehicles();
  }

  Future<void> deleteVehicle(int id) async {
    final vehicleDBService = VehicleDatabaseService.instance;
    await vehicleDBService.deleteVehicle(id);
    await fetchVehicles();
  }

}
