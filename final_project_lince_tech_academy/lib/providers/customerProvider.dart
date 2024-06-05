import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/databaseServices.dart';

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];

  List<Customer> get customers => _customers;

  Future<void> fetchCustomers() async {
    final dataList = await DatabaseService.instance.getAllCustomers();
    _customers = dataList.map((item) => Customer.fromMap(item as Map<String, dynamic>)).toList();
    notifyListeners();
  }

  void addCustomer(Customer customer) {
    DatabaseService.instance.insertCustomer(customer);
    _customers.add(customer);
    notifyListeners();
  }

  void updateCustomer(Customer customer) {
    DatabaseService.instance.updateCustomer(customer);
    final index = _customers.indexWhere((c) => c.id == customer.id);
    if (index != -1) {
      _customers[index] = customer;
      notifyListeners();
    }
  }
}