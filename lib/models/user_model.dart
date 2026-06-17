class UserModel {
  final String id;
  final String mobileNumber;
  final String passwordHash;

  UserModel({
    required this.id,
    required this.mobileNumber,
    required this.passwordHash,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      mobileNumber: json['mobileNumber'] as String,
      passwordHash: json['passwordHash'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobileNumber': mobileNumber,
      'passwordHash': passwordHash,
    };
  }
}
