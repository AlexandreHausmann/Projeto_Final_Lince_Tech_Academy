// customer_provider.dart

import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/customer_database_service.dart';

class CustomerProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService.instance;
  List<Customer> _customers = [];

  List<Customer> get customers => _customers;

  void fetchCustomers() {
    _dbService.getAllCustomers().then((fetchedCustomers) {
      _customers = fetchedCustomers.map((e) => Customer.fromMap(e)).toList();
      notifyListeners();
    }).catchError((error) {
      print('Error fetching customers: $error');
    });
  }

  void addCustomer(Customer customer) {
    _dbService.insertCustomer(customer).then((_) {
      fetchCustomers(); // Atualiza a lista após adicionar
    }).catchError((error) {
      print('Error adding customer: $error');
    });
  }

  void updateCustomer(Customer customer) {
    _dbService.updateCustomer(customer).then((_) {
      fetchCustomers(); // Atualiza a lista após atualizar
    }).catchError((error) {
      print('Error updating customer: $error');
    });
  }

  void deleteCustomer(int id) {
    _dbService.deleteCustomer(id).then((_) {
      fetchCustomers(); // Atualiza a lista após excluir
    }).catchError((error) {
      print('Error deleting customer: $error');
    });
  }
}
