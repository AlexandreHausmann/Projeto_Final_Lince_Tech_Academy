import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/customer_model.dart';
import '../services/customer_database_service.dart';

class CustomerProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService.instance;
  List<CustomerModels> _customers = [];

  List<CustomerModels> get customers => _customers;

  void fetchCustomers() {
    _dbService.getAllCustomers().then((fetchedCustomers) {
      _customers = fetchedCustomers.map((e) => CustomerModels.fromMap(e)).toList();
      notifyListeners();
    });
  }

  void addCustomer(CustomerModels customer) {
    _dbService.insertCustomer(customer).then((_) {
      fetchCustomers();
    });
  }

  void updateCustomer(CustomerModels customer) {
    _dbService.updateCustomer(customer).then((_) {
      fetchCustomers();
    });
  }

  void deleteCustomer(int id) {
    _dbService.deleteCustomer(id).then((_) {
      fetchCustomers();
    });
  }

  Future<CustomerModels?> fetchCustomerData(String cnpj) async {
    final url = 'https://brasilapi.com.br/api/cnpj/v1/$cnpj';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final customer = CustomerModels(
          id: _generateUniqueId(),
          cnpj: data['cnpj'],
          name: data['razao_social'],
          phone: data['ddd_telefone_1'],
          city: data['municipio'],
          state: data['uf'],
        );
        return customer;
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        throw Exception('Erro: ${errorData['message']}');
      } else {
        throw Exception('Erro ao buscar dados do cliente');
      }
    } catch (error) {
     'Erro ao buscar dados do cliente: $error';
    }
    return null;
  }

  bool isCnpjDuplicate(String cnpj) {
    return _customers.any((customer) => customer.cnpj == cnpj);
  }

  int _generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}
