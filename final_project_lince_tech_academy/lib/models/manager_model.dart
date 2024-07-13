/// Modelo de dados para um gerente.
class ManagerModels {
  /// Identificador único do gerente.
  final String? id;
  /// Nome do gerente.
  final String name;
  /// CPF do gerente.
  final String cpf;
  /// Estado do gerente.
  final String state;
  /// Número de telefone do gerente.
  final String phone;
  /// Percentual de comissão do gerente.
  final double commissionPercentage;

  /// Construtor da classe `ManagerModels`.
  ManagerModels({
    this.id,
    required this.name,
    required this.cpf,
    required this.state,
    required this.phone,
    required this.commissionPercentage,
  });

  /// Converte a instância de `ManagerModels` para uma representação de mapa.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cpf': cpf,
      'state': state,
      'phone': phone,
      'commissionPercentage': commissionPercentage,
    };
  }

  /// Cria uma instância de `ManagerModels` a partir de um mapa.
  factory ManagerModels.fromMap(Map<String, dynamic> map) {
    return ManagerModels(
      id: map['id'],
      name: map['name'],
      cpf: map['cpf'],
      state: map['state'],
      phone: map['phone'],
      commissionPercentage: map['commissionPercentage'],
    );
  }
}
