class Medicine {
  final String? atc;
  final String medicineName;
  final String? glnCode;
  final String? gmn;
  final String gtinCode;
  final String? typ;
  final String? authorizationHolder;
  final String? registrationNumber;

  Medicine({
    this.atc,
    required this.medicineName,
    this.glnCode,
    this.gmn,
    required this.gtinCode,
    this.typ,
    this.authorizationHolder,
    this.registrationNumber,
  });

  static Medicine fromJson(Map<String, dynamic>? json) => Medicine(
    atc: json?['atc'].toString() ?? "",
    medicineName: json?['medicine-name'].toString() ?? "",
    glnCode: json?['gln-code'].toString() ?? "",
    gmn: json?['gmn'].toString() ?? "",
    gtinCode: json?['gtin-code'].toString() ?? "",
    typ: json?['typ'].toString() ?? "",
    authorizationHolder: json?['authorization-holder'].toString() ?? "",
    registrationNumber: json?['authorization-number'].toString() ?? "",
  );
}