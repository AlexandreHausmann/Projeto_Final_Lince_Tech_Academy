import 'dart:convert';

import '../models/customer_model.dart';
import '../services/customer_database_service.dart';
import 'package:http/http.dart' as http;

class CustomerRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  Future<List<CustomerModels>> getAllCustomers() async {
    final customers = await _dbService.getAllCustomers();
    return customers.map((e) => CustomerModels.fromMap(e)).toList();
  }

  Future<void> addCustomer(CustomerModels customer) async {
    await _dbService.insertCustomer(customer);
  }

  Future<void> updateCustomer(CustomerModels customer) async {
    await _dbService.updateCustomer(customer);
  }

  Future<void> deleteCustomer(int id) async {
    await _dbService.deleteCustomer(id);
  }

  Future<CustomerModels?> fetchCustomerData(String cnpj) async {
    final url = 'https://brasilapi.com.br/api/cnpj/v1/$cnpj';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('aqui200');
        final data = json.decode(response.body);
        return CustomerModels.fromJson(data);
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        throw Exception('Erro: ${errorData['message']}');
      } else {
        throw Exception('Erro ao buscar dados do cliente');
      }
    } catch (error) {
      throw Exception('Erro ao buscar dados do cliente: $error');
    }
  }
}
