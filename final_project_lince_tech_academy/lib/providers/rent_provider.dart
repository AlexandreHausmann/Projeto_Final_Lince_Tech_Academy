import 'package:flutter/material.dart';
import '../models/rent.dart';
import '../services/rent_database_service.dart';

class RentProvider with ChangeNotifier {
  List<Rent> _rents = [];

  List<Rent> get rents => _rents;

  Future<void> fetchRents() async {
    final dataList = await RentDatabaseService.instance.getAllRents();
    _rents = dataList.map((item) => Rent.fromMap(item)).toList();
    notifyListeners();
  }

  void addRent(Rent rent) async {
    await RentDatabaseService.instance.insertRent(rent);
    _rents.add(rent);
    notifyListeners();
  }

  void updateRent(Rent rent) async {
    await RentDatabaseService.instance.updateRent(rent);
    final index = _rents.indexWhere((r) => r.id == rent.id);
    if (index != -1) {
      _rents[index] = rent;
      notifyListeners();
    }
  }

  void cancelRent(int i) {}
}
