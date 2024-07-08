import 'package:flutter/material.dart';
import '../models/customer_model.dart';
import '../repositories/customer_repository.dart';

class CustomerProvider extends ChangeNotifier {
  final CustomerRepository customerRepository;

  CustomerProvider({required this.customerRepository}) {
    fetchCustomers();
  }

  List<CustomerModels> _customers = [];

  List<CustomerModels> get customers => _customers;

  Future<void> fetchCustomers() async {
    _customers = await customerRepository.getAllCustomers();
    notifyListeners();
  }

  Future<void> addCustomer(CustomerModels customer) async {
    await customerRepository.addCustomer(customer);
    await fetchCustomers(); 
  }

  Future<void> updateCustomer(CustomerModels customer) async {
    await customerRepository.updateCustomer(customer);
    await fetchCustomers(); 
  }

  Future<void> deleteCustomer(int id) async {
    await customerRepository.deleteCustomer(id);
    await fetchCustomers(); 
  }

  Future<CustomerModels?> fetchCustomerData(String cnpj) async {
    return await customerRepository.fetchCustomerData(cnpj);
  }

  bool isCnpjDuplicate(String cnpj) {
    return _customers.any((customer) => customer.cnpj == cnpj);
  }
}
