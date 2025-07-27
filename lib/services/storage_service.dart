import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();

  late SharedPreferences _prefs;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // User data storage
  Future<void> saveUser(UserModel user) async {
    await _prefs.setString('user_data', jsonEncode(user.toJson()));
  }

  UserModel? getUser() {
    final userData = _prefs.getString('user_data');
    if (userData != null) {
      return UserModel.fromJson(jsonDecode(userData));
    }
    return null;
  }

  Future<void> clearUser() async {
    await _prefs.remove('user_data');
  }

  // Token storage
  Future<void> saveToken(String token) async {
    await _prefs.setString('auth_token', token);
  }

  String? getToken() {
    return _prefs.getString('auth_token');
  }

  Future<void> clearToken() async {
    await _prefs.remove('auth_token');
  }

  // Remember me functionality
  Future<void> saveRememberMe(bool remember) async {
    await _prefs.setBool('remember_me', remember);
  }

  bool getRememberMe() {
    return _prefs.getBool('remember_me') ?? false;
  }

  // Language preference
  Future<void> saveLanguage(String language) async {
    await _prefs.setString('selected_language', language);
  }

  String getLanguage() {
    return _prefs.getString('selected_language') ?? 'English';
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  // Add this method to your StorageService class
  String getLanguageSync() {
    try {
      return _prefs.getString('selected_language') ?? 'English';
    } catch (e) {
      return 'English';
    }
  }

}
