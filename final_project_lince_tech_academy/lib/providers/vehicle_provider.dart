import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../repositories/vehicle_repository.dart';
import '../services/vehicle_database_service.dart';

/// Provider responsável por gerenciar os veículos e marcas de veículos da aplicação.
class VehicleProvider with ChangeNotifier {
 /// Repositório para acesso aos dados dos veículos
  final VehicleRepository vehicleRepository;
  /// Serviço de banco de dados para operações de veículos
  final VehicleDatabaseService vehicleDatabaseService = VehicleDatabaseService.instance;

  List<VehicleModels> _vehicles = [];
  List<String> _brands = [];

  /// Construtor que inicializa o provider e realiza a busca inicial dos veículos.
  VehicleProvider({required this.vehicleRepository}) {
    _fetchVehicles();
  }

  /// Retorna a lista de veículos disponíveis.
  List<VehicleModels> get vehicles => _vehicles;

  /// Retorna a lista de marcas de veículos disponíveis.
  List<String> get brands => _brands;

  /// Busca os veículos armazenados no banco de dados local e atualiza a lista interna.
  Future<void> _fetchVehicles() async {
    final vehicleMaps = await vehicleDatabaseService.getAllVehicles();
    _vehicles = vehicleMaps.map(VehicleModels.fromMap).toList();
    notifyListeners();
  }

  /// Atualiza a lista de veículos buscando do banco de dados local.
  Future<void> fetchVehicles() async {
    final vehicleMaps = await vehicleDatabaseService.getAllVehicles();
    _vehicles = vehicleMaps.map(VehicleModels.fromMap).toList();
    notifyListeners();
  }

  /// Busca as marcas de veículos disponíveis através do repositório.
  Future<void> fetchVehicleBrands() async {
    try {
      _brands = await vehicleRepository.getVehicleBrands();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  /// Adiciona um novo veículo ao banco de dados local e atualiza a lista de veículos.
  Future<void> addVehicle(VehicleModels vehicle) async {
    final id = await vehicleDatabaseService.insertVehicle(vehicle);
    _vehicles.add(vehicle.copyWith(id: id));
    notifyListeners();
  }

  /// Atualiza um veículo existente no banco de dados local e na lista de veículos.
  Future<void> updateVehicle(VehicleModels vehicle) async {
    await vehicleDatabaseService.updateVehicle(vehicle);
    final index = _vehicles.indexWhere((v) => v.id == vehicle.id);
    if (index >= 0) {
      _vehicles[index] = vehicle;
      notifyListeners();
    }
  }

  /// Deleta um veículo do banco de dados local e remove da lista de veículos.
  Future<void> deleteVehicle(int id) async {
    await vehicleDatabaseService.deleteVehicle(id);
    _vehicles.removeWhere((v) => v.id == id);
    notifyListeners();
  }

  /// Atualiza a lista de veículos invocando novamente a busca no banco de dados local.
  Future<void> refreshVehicles() async {
    await _fetchVehicles();
  }
}
