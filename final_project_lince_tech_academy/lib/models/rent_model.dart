/// Modelo de dados para um contrato de aluguel.
class RentModels {
  /// Identificador único do contrato de aluguel.
  final int? id;
  /// Nome do cliente que está alugando o veículo.
  final String clientName;
  /// Modelo do veículo sendo alugado.
  final String vehicleModel;
  /// Data de início do aluguel.
  final DateTime startDate;
  /// Data de término do aluguel.
  final DateTime endDate;
  /// Total de dias de duração do aluguel.
  final int totalDays;
  /// Valor total do aluguel.
  final double totalAmount;

  /// Construtor da classe `RentModels`.
  RentModels({
    this.id,
    required this.clientName,
    required this.vehicleModel,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.totalAmount,
  });

  /// Converte a instância de `RentModels` para uma representação de mapa.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientName': clientName,
      'vehicleModel': vehicleModel,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'totalDays': totalDays,
      'totalAmount': totalAmount,
    };
  }

  /// Cria uma instância de `RentModels` a partir de um mapa.
  factory RentModels.fromMap(Map<String, dynamic> map) {
    return RentModels(
      id: map['id'],
      clientName: map['clientName'],
      vehicleModel: map['vehicleModel'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      totalDays: map['totalDays'],
      totalAmount: map['totalAmount'],
    );
  }
}
