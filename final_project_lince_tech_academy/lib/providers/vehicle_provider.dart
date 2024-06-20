import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/vehicle.dart';
import '../services/vehicle_database_service.dart';

class VehicleProvider with ChangeNotifier {
  final VehicleDatabaseService _dbService = VehicleDatabaseService.instance;
  List<Vehicle> _vehicles = [];
  List<String> _brands = [];

  List<Vehicle> get vehicles => _vehicles;

  Future<void> fetchVehicles() async {
    final fetchedVehicles = await _dbService.getAllVehicles();
    _vehicles = fetchedVehicles.map((e) => Vehicle.fromMap(e)).toList();
    notifyListeners();
  }

  void addVehicle(Vehicle vehicle) {
    _dbService.insertVehicle(vehicle);
    _vehicles.add(vehicle);
    notifyListeners();
  }

  void updateVehicle(Vehicle vehicle) {
    _dbService.updateVehicle(vehicle);
    int index = _vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index != -1) {
      _vehicles[index] = vehicle;
      notifyListeners();
    }
  }

  void deleteVehicle(int id) {
    _dbService.deleteVehicle(id);
    _vehicles.removeWhere((v) => v.id == id);
    notifyListeners();
  }

  Future<List<String>> fetchVehicleBrands() async {
    const url = 'https://fipe.parallelum.com.br/api/v2/references';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        _brands = data.map((item) => item['name'] as String).toList();
        return _brands;
      } else {
        throw Exception('Failed to load brands');
      }
    } catch (error) {
      print('Error fetching vehicle brands: $error');
      rethrow;
    }
  }
}
