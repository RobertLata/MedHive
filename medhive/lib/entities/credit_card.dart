class CreditCard {
  String id;
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool isPrimary;
  String userId;

  CreditCard({
    required this.id,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    required this.isPrimary,
    required this.userId,
  });

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    return CreditCard(
      id: json['id'] as String,
      cardNumber: json['cardNumber'] as String,
      expiryDate: json['expiryDate'] as String,
      cardHolderName: json['cardHolderName'] as String,
      cvvCode: json['cvvCode'] as String,
      isPrimary: json['isPrimary'] as bool,
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cardHolderName': cardHolderName,
      'cvvCode': cvvCode,
      'isPrimary': isPrimary,
      'userId': userId,
    };
  }
}
