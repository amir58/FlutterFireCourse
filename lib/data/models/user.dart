class MyUser {
  final String username;
  final String email;
  final String phone;
  final String profileImageUrl;
  final String userId;

  MyUser({
    required this.username,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
    required this.userId,
  });

  MyUser.fromJson(Map<String, dynamic>? json)
      : this(
          username: json!['username']! as String,
          email: json['email']! as String,
          phone: json['phone']! as String,
          profileImageUrl: json['profileImageUrl']! as String,
          userId: json['userId']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'username': username,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'userId': userId,
    };
  }
}
