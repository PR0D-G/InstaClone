import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserModel> register(String mobileNumber, String password) async {
    final snapshot = await _firestore
        .collection('users')
        .where('mobileNumber', isEqualTo: mobileNumber)
        .get();

    if (snapshot.docs.isNotEmpty) {
      throw Exception('User with this mobile number already exists.');
    }

    final docRef = _firestore.collection('users').doc();
    final hashedPassword = _hashPassword(password);
    final user = UserModel(
      id: docRef.id,
      mobileNumber: mobileNumber,
      passwordHash: hashedPassword,
    );

    await docRef.set(user.toJson());
    await _saveLocalSession(user.id);
    return user;
  }

  Future<UserModel> login(String mobileNumber, String password) async {
    final snapshot = await _firestore
        .collection('users')
        .where('mobileNumber', isEqualTo: mobileNumber)
        .get();

    if (snapshot.docs.isEmpty) {
      throw Exception('Invalid mobile number or password.');
    }

    final userData = snapshot.docs.first.data();
    final user = UserModel.fromJson(userData);
    final hashedPassword = _hashPassword(password);

    if (user.passwordHash != hashedPassword) {
      throw Exception('Invalid mobile number or password.');
    }

    await _saveLocalSession(user.id);
    return user;
  }

  Future<void> _saveLocalSession(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }

  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
}
