import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../repositories/vehicle_repository.dart';
import '../services/vehicle_database_service.dart';

class VehicleProvider with ChangeNotifier {
  final VehicleRepository vehicleRepository;
  final VehicleDatabaseService vehicleDatabaseService = VehicleDatabaseService.instance;

  List<VehicleModels> _vehicles = [];
  List<String> _brands = [];

  VehicleProvider({required this.vehicleRepository}) {
    _fetchVehicles();
  }

  List<VehicleModels> get vehicles => _vehicles;
  List<String> get brands => _brands;

  Future<void> _fetchVehicles() async {
    final vehicleMaps = await vehicleDatabaseService.getAllVehicles();
    _vehicles = vehicleMaps.map((vehicleMap) => VehicleModels.fromMap(vehicleMap)).toList();
    notifyListeners();
  }

  Future<void> fetchVehicleBrands() async {
    try {
      _brands = await vehicleRepository.getVehicleBrands();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addVehicle(VehicleModels vehicle) async {
    final id = await vehicleDatabaseService.insertVehicle(vehicle);
    _vehicles.add(vehicle.copyWith(id: id));
    notifyListeners();
  }

  Future<void> updateVehicle(VehicleModels vehicle) async {
    await vehicleDatabaseService.updateVehicle(vehicle);
    final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index >= 0) {
      _vehicles[index] = vehicle;
      notifyListeners();
    }
  }

  Future<void> deleteVehicle(int id) async {
    await vehicleDatabaseService.deleteVehicle(id);
    _vehicles.removeWhere((v) => v.id == id);
    notifyListeners();
  }
}
