class UserModel {
  final String id;
  final String emailOrMobile;
  final String passwordHash;

  UserModel({
    required this.id,
    required this.emailOrMobile,
    required this.passwordHash,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      emailOrMobile: json['emailOrMobile'] as String,
      passwordHash: json['passwordHash'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emailOrMobile': emailOrMobile,
      'passwordHash': passwordHash,
    };
  }
}
