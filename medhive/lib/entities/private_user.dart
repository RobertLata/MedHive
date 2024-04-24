class PrivateUser {
  String? id;
  String? name;
  String? username;
  String? email;
  String? profileImage;
  String? selectedAddress;

  PrivateUser({
    required this.id,
    this.name,
    this.username,
    this.email,
    this.profileImage,
    this.selectedAddress,
  });

  factory PrivateUser.fromJson(Map<String, dynamic> json) {
    return PrivateUser(
      id: json['id'] as String,
      name: json['name'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      profileImage: json['profileImage'] as String?,
      selectedAddress: json['selectedAddress'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'profileImage': profileImage,
      'selectedAddress': selectedAddress,
    };
  }
}