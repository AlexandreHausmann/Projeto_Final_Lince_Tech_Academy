/// Modelo de dados para um veículo.
class VehicleModels {
  /// Identificador único do veículo.
  final int? id;
  /// Marca do veículo.
  final String brand;
  /// Modelo do veículo.
  final String model;
  /// Placa do veículo.
  final String plate;
  /// Ano de fabricação do veículo.
  final int year;
  /// Taxa diária de aluguel do veículo.
  final double dailyRate;
  /// Caminho da imagem do veículo.
  final String imagePath;

  /// Construtor da classe `VehicleModels`.
  VehicleModels({
    this.id,
    required this.brand,
    required this.model,
    required this.plate,
    required this.year,
    required this.dailyRate,
    required this.imagePath,
  });

  /// Converte a instância de `VehicleModels` para uma representação de mapa.
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

  /// Cria uma instância de `VehicleModels` a partir de um mapa.
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

  /// Cria uma cópia da instância de `VehicleModels` com novos valores opcionais.
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
