class Address {
  String id;
  String name;
  String street;
  String location;
  bool isPrimary;
  String userId;

  Address({
    required this.id,
    required this.name,
    required this.street,
    required this.location,
    required this.isPrimary,
    required this.userId,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as String,
      name: json['name'] as String,
      street: json['street'] as String,
      location: json['location'] as String,
      isPrimary: json['isPrimary'] as bool,
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'street': street,
      'location': location,
      'isPrimary': isPrimary,
      'userId': userId,
    };
  }
}