class Medicine {
  final String id;
  final String name;
  final String dosage;
  final String type;
  final String manufacturer;
  final String expiryDate;
  final String image;
  final double price;
  final double priceBeforeDiscount;
  final int quantity;
  final bool needsPrescription;
  final String? sideEffects;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.type,
    required this.manufacturer,
    required this.expiryDate,
    required this.image,
    required this.price,
    required this.quantity,
    required this.priceBeforeDiscount,
    required this.needsPrescription,
    this.sideEffects,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'type': type,
      'manufacturer': manufacturer,
      'expiryDate': expiryDate,
      'image': image,
      'price': price,
      'quantity': quantity,
      'priceBeforeDiscount': priceBeforeDiscount,
      'needsPrescription': needsPrescription,
      'sideEffects': sideEffects,
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      dosage: json['dosage'],
      type: json['type'],
      manufacturer: json['manufacturer'],
      expiryDate: json['expiryDate'],
      image: json['image'],
      price: json['price'],
      quantity: json['quantity'],
      priceBeforeDiscount: json['priceBeforeDiscount'],
      needsPrescription: json['needsPrescription'],
      sideEffects: json['sideEffects'],
    );
  }
}
