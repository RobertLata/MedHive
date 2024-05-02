import 'medicine.dart';

class Pharmacy {
  final String id;
  final String name;
  final String logo;
  final String address;
  final double deliveryCost;
  final double rating;
  final int reviewCount;
  final List<Medicine> medicines;

  Pharmacy({
    required this.id,
    required this.name,
    required this.logo,
    required this.address,
    required this.deliveryCost,
    required this.rating,
    required this.reviewCount,
    required this.medicines,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'address': address,
      'deliveryCont': deliveryCost,
      'rating': rating,
      'reviewCount': reviewCount,
      'medicines': medicines.map((medicine) => medicine.toJson()).toList(),
    };
  }

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id'],
      name: json['name'],
      logo: json['logo'],
      address: json['address'],
      deliveryCost: json['deliveryCost'],
      rating: json['rating'],
      reviewCount: json['reviewCount'],
      medicines: (json['medicines'] as List<dynamic>)
          .map((medicineJson) => Medicine.fromJson(medicineJson))
          .toList(),
    );
  }
}