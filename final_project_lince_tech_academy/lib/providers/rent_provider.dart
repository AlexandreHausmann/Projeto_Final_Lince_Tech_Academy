import 'package:flutter/material.dart';
import '../models/rent.dart';
import '../services/rent_database_service.dart';

class RentProvider extends ChangeNotifier {
  final RentDatabaseService _dbService = RentDatabaseService.instance;
  List<Rent> _rents = [];

  List<Rent> get rents => _rents;

  Future<void> fetchRents() async {
    final fetchedRents = await _dbService.getAllRents();
    _rents = fetchedRents.map((e) => Rent.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> addRent(Rent rent) async {
    await _dbService.insertRent(rent);
    await fetchRents();
  }

  Future<void> updateRent(Rent rent) async {
    await _dbService.updateRent(rent);
    await fetchRents();
  }

  Future<void> cancelRent(int id) async {
    await _dbService.deleteRent(id);
    await fetchRents();
  }
}
