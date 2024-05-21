import 'medicine.dart';

class Pharmacy {
  final String id;
  final String name;
  final String logo;
  final String address;
  final double deliveryCost;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final List<Medicine> medicines;
  final List<dynamic>? comments;

  Pharmacy({
    required this.id,
    required this.name,
    required this.logo,
    required this.address,
    required this.deliveryCost,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.medicines,
    this.comments,
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
      'deliveryTime': deliveryTime,
      'medicines': medicines.map((medicine) => medicine.toJson()).toList(),
      'comments': comments,
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
      deliveryTime: json['deliveryTime'],
      medicines: (json['medicines'] as List<dynamic>)
          .map((medicineJson) => Medicine.fromJson(medicineJson))
          .toList(),
      comments: json['comments'],
    );
  }
}