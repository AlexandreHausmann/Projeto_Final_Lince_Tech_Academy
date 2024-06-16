import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/customer.dart';

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];

  List<Customer> get customers => [..._customers];

  Future<void> fetchCustomers() async {
    try {
      final customers = await DatabaseService.instance.getAllCustomers();
      _customers = customers.map((item) => Customer.fromMap(item)).toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addCustomer(Customer customer) async {
    try {
      await DatabaseService.instance.insertCustomer(customer);
      await fetchCustomers();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      await DatabaseService.instance.updateCustomer(customer);
      await fetchCustomers();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteCustomer(int id) async {
    try {
      await DatabaseService.instance.deleteCustomer(id);
      _customers.removeWhere((customer) => customer.id == id);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
