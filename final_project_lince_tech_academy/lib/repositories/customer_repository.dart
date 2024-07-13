import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/customer_model.dart';
import '../services/customer_database_service.dart';

/// Repositório responsável por gerenciar operações relacionadas aos clientes.
class CustomerRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  /// Retorna todos os clientes armazenados no banco de dados local.
  Future<List<CustomerModels>> getAllCustomers() async {
    final customers = await _dbService.getAllCustomers();
    return customers.map(CustomerModels.fromMap).toList();
  }

  /// Adiciona um novo cliente ao banco de dados local.
  Future<void> addCustomer(CustomerModels customer) async {
    await _dbService.insertCustomer(customer);
  }

  /// Atualiza um cliente existente no banco de dados local.
  Future<void> updateCustomer(CustomerModels customer) async {
    await _dbService.updateCustomer(customer);
  }

  /// Deleta um cliente do banco de dados local.
  Future<void> deleteCustomer(int id) async {
    await _dbService.deleteCustomer(id);
  }

  /// Busca dados de um cliente utilizando o CNPJ através da API BrasilAPI.
  ///
  /// Lança exceções em caso de erros durante a requisição.
  Future<CustomerModels?> fetchCustomerData(String cnpj) async {
    final url = 'https://brasilapi.com.br/api/cnpj/v1/$cnpj';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
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
