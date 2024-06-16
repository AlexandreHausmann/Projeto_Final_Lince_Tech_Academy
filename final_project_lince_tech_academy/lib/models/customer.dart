class Customer {
  final int? id;
  final String name;
  final String phone;
  final String cnpj;
  final String city;
  final String state;

  Customer({
    this.id,
    required this.name,
    required this.phone,
    required this.cnpj,
    required this.city,
    required this.state,
  });

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

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      cnpj: map['cnpj'],
      city: map['city'],
      state: map['state'],
    );
  }
}
