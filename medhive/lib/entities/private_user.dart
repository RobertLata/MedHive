class PrivateUser {
  String? id;
  String? name;
  String? username;
  String? email;
  String? profileImage;

  PrivateUser({
    required this.id,
    this.name,
    this.username,
    this.email,
    this.profileImage,
  });

  factory PrivateUser.fromJson(Map<String, dynamic> json) {
    return PrivateUser(
      id: json['id'] as String,
      name: json['name'] as String?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      profileImage: json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'profileImage': profileImage,
    };
  }
}