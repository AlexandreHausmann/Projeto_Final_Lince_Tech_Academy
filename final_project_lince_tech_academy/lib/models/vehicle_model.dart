class VehicleModels {
  final int? id;
  final String brand;
  final String model;
  final String plate;
  final int year;
  final double dailyRate;
  final String imagePath;

  VehicleModels({
    this.id,
    required this.brand,
    required this.model,
    required this.plate,
    required this.year,
    required this.dailyRate,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'plate': plate,
      'year': year,
      'dailyRate': dailyRate,
      'imagePath': imagePath,
    };
  }

  factory VehicleModels.fromMap(Map<String, dynamic> map) {
    return VehicleModels(
      id: map['id'],
      brand: map['brand'],
      model: map['model'],
      plate: map['plate'],
      year: map['year'],
      dailyRate: map['dailyRate'],
      imagePath: map['imagePath'],
    );
  }

  VehicleModels copyWith({
    int? id,
    String? brand,
    String? model,
    String? plate,
    int? year,
    double? dailyRate,
    String? imagePath,
  }) {
    return VehicleModels(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      plate: plate ?? this.plate,
      year: year ?? this.year,
      dailyRate: dailyRate ?? this.dailyRate,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
