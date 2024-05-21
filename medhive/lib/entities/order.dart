class UserOrder {
  String id;
  String pharmacyName;
  String pharmacyLogo;
  String deliveryDate;
  String location;
  List<dynamic> products;
  List<dynamic> productQuantity;
  double totalPrice;
  String userId;
  bool? isPrescriptionValid;
  String? orderState;
  String? deliveryRiderId;

  UserOrder({
    required this.id,
    required this.pharmacyName,
    required this.pharmacyLogo,
    required this.deliveryDate,
    required this.location,
    required this.products,
    required this.productQuantity,
    required this.totalPrice,
    required this.userId,
    this.isPrescriptionValid,
    this.orderState,
    this.deliveryRiderId,
  });

  factory UserOrder.fromJson(Map<String, dynamic> json) {
    return UserOrder(
      id: json['id'] as String,
      pharmacyName: json['pharmacyName'] as String,
      pharmacyLogo: json['pharmacyLogo'] as String,
      deliveryDate: json['deliveryDate'] as String,
      location: json['location'] as String,
      products: json['products'] as List<dynamic>,
      productQuantity: json['productQuantity'] as List<dynamic>,
      totalPrice: json['totalPrice'] as double,
      userId: json['userId'] as String,
      isPrescriptionValid: json['isPrescriptionValid'] as bool?,
      orderState: json['orderState'] as String?,
      deliveryRiderId: json['deliveryRiderId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pharmacyName': pharmacyName,
      'pharmacyLogo': pharmacyLogo,
      'deliveryDate': deliveryDate,
      'location': location,
      'products': products,
      'productQuantity': productQuantity,
      'totalPrice': totalPrice,
      'userId': userId,
      'isPrescriptionValid': isPrescriptionValid,
      'orderState': orderState,
      'deliveryRiderId': deliveryRiderId,
    };
  }
}