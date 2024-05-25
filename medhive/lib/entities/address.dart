class Address {
  String id;
  String name;
  String street;
  String location;
  bool isPrimary;
  String userId;
  double latitude;
  double longitude;

  Address({
    required this.id,
    required this.name,
    required this.street,
    required this.location,
    required this.isPrimary,
    required this.userId,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as String,
      name: json['name'] as String,
      street: json['street'] as String,
      location: json['location'] as String,
      isPrimary: json['isPrimary'] as bool,
      userId: json['userId'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
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
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}