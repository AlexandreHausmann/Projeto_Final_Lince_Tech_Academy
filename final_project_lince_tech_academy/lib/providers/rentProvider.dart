import 'package:flutter/material.dart';
import '../models/rent.dart';
import '../services/databaseServices.dart';

class RentProvider with ChangeNotifier {
  List<Rent> _rents = [];

  List<Rent> get rents => _rents;

  Future<void> fetchRents() async {
    if (_rents.isEmpty) {
      final dataList = await DatabaseService.instance.getAllRents();
      _rents = dataList.map((item) => Rent.fromMap(item)).toList();
      notifyListeners();
    }
  }

  void addRent(Rent rent) async {
    await DatabaseService.instance.insertRent(rent);
    _rents.add(rent);
    notifyListeners();
  }

  void updateRent(Rent rent) async {
    await DatabaseService.instance.updateRent(rent);
    final index = _rents.indexWhere((r) => r.id == rent.id);
    if (index != -1) {
      _rents[index] = rent;
      notifyListeners();
    }
  }

  void deleteRent(int id) async {
    await DatabaseService.instance.deleteRent(id);
    _rents.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}