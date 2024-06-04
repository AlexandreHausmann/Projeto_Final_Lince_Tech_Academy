class Manager {
  final int id;
  final String name;
  final String cpf;
  final String state;
  final String phone;
  final double commissionPercentage;

  Manager({
    required this.id,
    required this.name,
    required this.cpf,
    required this.state,
    required this.phone,
    required this.commissionPercentage,
  });

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

  factory Manager.fromMap(Map<String, dynamic> map) {
    return Manager(
      id: map['id'],
      name: map['name'],
      cpf: map['cpf'],
      state: map['state'],
      phone: map['phone'],
      commissionPercentage: map['commissionPercentage'],
    );
  }
}