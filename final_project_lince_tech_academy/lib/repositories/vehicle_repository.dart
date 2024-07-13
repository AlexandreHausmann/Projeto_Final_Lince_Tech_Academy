import 'dart:convert';
import 'package:http/http.dart' as http;

/// Repositório responsável por gerenciar operações relacionadas aos veículos.
class VehicleRepository {
  
  /// Retorna uma lista de marcas de veículos obtida da API Fipe.
  ///
  /// Lança uma exceção em caso de falha na requisição.
  Future<List<String>> getVehicleBrands() async {
    final response = await http.get(
      Uri.parse('https://fipe.parallelum.com.br/api/v2/cars/brands'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((item) => item['name'] as String).toList();
    } else {
      throw Exception('Não foi possível encontrar as informações do veículo');
    }
  }
}
