class UserModel {
  final String id;
  final String username;
  final String emailOrMobile;
  final String passwordHash;

  UserModel({
    required this.id,
    required this.username,
    required this.emailOrMobile,
    required this.passwordHash,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String? ?? 'user_${json['id']}',
      emailOrMobile: json['emailOrMobile'] as String,
      passwordHash: json['passwordHash'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'emailOrMobile': emailOrMobile,
      'passwordHash': passwordHash,
    };
  }
}
