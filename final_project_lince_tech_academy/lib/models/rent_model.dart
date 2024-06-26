class RentModels {
  final int? id;
  final String clientName;
  final String vehicleModel;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final double totalAmount;

  RentModels({
    this.id,
    required this.clientName,
    required this.vehicleModel,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.totalAmount,
  });

  get customerName => null;

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
