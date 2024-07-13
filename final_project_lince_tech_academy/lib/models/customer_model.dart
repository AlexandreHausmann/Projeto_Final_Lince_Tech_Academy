/// Modelo de dados para um cliente.
class CustomerModels {
  /// Identificador único do cliente.
  final int? id;
  /// Nome do cliente.
  final String name;
  /// Número de telefone do cliente.
  final String phone;
  /// CNPJ do cliente.
  final String cnpj;
  /// Cidade do cliente.
  final String city;
  /// Estado do cliente.
  final String state;

  /// Construtor da classe `CustomerModels`.
  CustomerModels({
    this.id,
    required this.name,
    required this.phone,
    required this.cnpj,
    required this.city,
    required this.state,
  });

  /// Cria uma cópia da instância de `CustomerModels` com novos valores opcionais.
  CustomerModels copyWith({
    int? id,
    String? name,
    String? phone,
    String? cnpj,
    String? city,
    String? state,
  }) {
    return CustomerModels(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      cnpj: cnpj ?? this.cnpj,
      city: city ?? this.city,
      state: state ?? this.state,
    );
  }

  /// Converte a instância de `CustomerModels` para uma representação de mapa.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'cnpj': cnpj,
      'city': city,
      'state': state,
    };
  }

  /// Cria uma instância de `CustomerModels` a partir de um mapa.
  factory CustomerModels.fromMap(Map<String, dynamic> map) {
    return CustomerModels(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      cnpj: map['cnpj'],
      city: map['city'],
      state: map['state'],
    );
  }

  /// Cria uma instância de `CustomerModels` a partir de um objeto JSON.
  factory CustomerModels.fromJson(Map<String, dynamic> json) {
    return CustomerModels(
      name: json['razao_social'],
      phone: json['ddd_telefone_1'],
      city: json['municipio'],
      state: json['uf'],
      cnpj: json['cnpj'],
    );
  }
}
