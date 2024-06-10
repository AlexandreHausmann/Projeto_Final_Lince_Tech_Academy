class Rent {
  final int id;
  final int clientId; // ID do cliente
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfDays;
  final double totalAmount;

  Rent({
    required this.id,
    required this.clientId,
    required this.startDate,
    required this.endDate,
    required this.numberOfDays,
    required this.totalAmount,
  });

  // Método para mapear os dados do aluguel para um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'clientId': clientId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'numberOfDays': numberOfDays,
      'totalAmount': totalAmount,
    };
  }

  // Método para criar um objeto de aluguel a partir de um mapa
  factory Rent.fromMap(Map<String, dynamic> map) {
    return Rent(
      id: map['id'],
      clientId: map['clientId'],
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      numberOfDays: map['numberOfDays'],
      totalAmount: map['totalAmount'],
    );
  }
}
