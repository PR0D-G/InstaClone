import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthRepository {
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<List<UserModel>> _getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users_db');
    if (usersJson == null) return [];
    final List<dynamic> decoded = json.decode(usersJson);
    return decoded.map((e) => UserModel.fromJson(e)).toList();
  }

  Future<void> _saveUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = json.encode(users.map((e) => e.toJson()).toList());
    await prefs.setString('users_db', usersJson);
  }

  Future<UserModel> register(String username, String emailOrMobile, String password) async {
    final users = await _getUsers();
    
    final exists = users.any((u) => u.emailOrMobile == emailOrMobile);
    if (exists) {
      throw Exception('User with this email or mobile number already exists.');
    }

    final hashedPassword = _hashPassword(password);
    final user = UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: username,
      emailOrMobile: emailOrMobile,
      passwordHash: hashedPassword,
    );

    users.add(user);
    await _saveUsers(users);
    await _saveLocalSession(user.id);
    return user;
  }

  Future<UserModel> login(String emailOrMobile, String password) async {
    final users = await _getUsers();
    
    final userIndex = users.indexWhere((u) => u.emailOrMobile == emailOrMobile);
    if (userIndex == -1) {
      throw Exception('Invalid email/mobile number or password.');
    }

    final user = users[userIndex];
    final hashedPassword = _hashPassword(password);

    if (user.passwordHash != hashedPassword) {
      throw Exception('Invalid email/mobile number or password.');
    }

    await _saveLocalSession(user.id);
    return user;
  }

  Future<void> _saveLocalSession(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }
}
