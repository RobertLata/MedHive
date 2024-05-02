class Medicine {
  final String id;
  final String name;
  final String dosage;
  final String type;
  final String manufacturer;
  final String expiryDate;
  final String image;
  final bool isSpecialOffer;
  final double price;
  final double priceBeforeDiscount;
  final int quantity;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.type,
    required this.manufacturer,
    required this.expiryDate,
    required this.image,
    required this.isSpecialOffer,
    required this.price,
    required this.quantity,
    required this.priceBeforeDiscount,
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
      'isSpecialOffer': isSpecialOffer,
      'price': price,
      'quantity': quantity,
      'priceBeforeDiscount': priceBeforeDiscount,
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
      isSpecialOffer: json['isSpecialOffer'],
      price: json['price'],
      quantity: json['quantity'],
      priceBeforeDiscount: json['priceBeforeDiscount'],
    );
  }
}
