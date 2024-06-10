import 'package:flutter/material.dart';
import '../models/vehicle.dart';
import '../services/vehicleDatabaseService.dart'; // Importar o novo serviço de veículos

class VehicleProvider with ChangeNotifier {
  List<Vehicle> _vehicles = [];

  List<Vehicle> get vehicles => _vehicles;

  Future<void> fetchVehicles() async {
    if (_vehicles.isEmpty) {
      final dataList = await VehicleDatabaseService.instance.getAllVehicles(); // Usar o novo serviço de veículos
      _vehicles = dataList.map((item) => Vehicle.fromMap(item)).toList();
      notifyListeners();
    }
  }

  void addVehicle(Vehicle vehicle) async {
    await VehicleDatabaseService.instance.insertVehicle(vehicle); // Usar o novo serviço de veículos
    _vehicles.add(vehicle);
    notifyListeners();
  }

  void updateVehicle(Vehicle vehicle) async {
    await VehicleDatabaseService.instance.updateVehicle(vehicle); // Usar o novo serviço de veículos
    final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index != -1) {
      _vehicles[index] = vehicle;
      notifyListeners();
    }
  }
}