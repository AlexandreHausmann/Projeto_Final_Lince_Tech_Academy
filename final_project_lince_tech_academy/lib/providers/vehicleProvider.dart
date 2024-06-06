import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/databaseServices.dart';

class VehicleProvider with ChangeNotifier {
  List<Vehicle> _vehicles = [];

  List<Vehicle> get vehicles => _vehicles;

  Future<void> fetchVehicles() async {
    if (_vehicles.isEmpty) {
      final dataList = await DatabaseService.instance.getAllVehicles();
      _vehicles = dataList.map((item) => Vehicle.fromMap(item)).toList();
      notifyListeners();
    }
  }

  void addVehicle(Vehicle vehicle) async {
    await DatabaseService.instance.insertVehicle(vehicle);
    _vehicles.add(vehicle);
    notifyListeners();
  }

  void updateVehicle(Vehicle vehicle) async {
    await DatabaseService.instance.updateVehicle(vehicle);
    final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index != -1) {
      _vehicles[index] = vehicle;
      notifyListeners();
    }
  }
}