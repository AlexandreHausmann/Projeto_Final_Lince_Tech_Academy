class Vehicle {
  final int id;
  final String brand;
  final String model;
  final String plate;
  final int year;
  final double dailyRate;
  final String imagePath;

  Vehicle({
    required this.id,
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

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'],
      brand: map['brand'],
      model: map['model'],
      plate: map['plate'],
      year: map['year'],
      dailyRate: map['dailyRate'],
      imagePath: map['imagePath'],
    );
  }
}