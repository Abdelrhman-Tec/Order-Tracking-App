class UserModel {
  final String uid;
  final String email;
  final String username;
  final String? createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}
