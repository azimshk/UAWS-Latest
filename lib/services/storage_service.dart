import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../shared/models/auth/user_model.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();

  late SharedPreferences _prefs;

  // Initialize the storage service
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Keys for storage
  static const String _keyUser = 'user';
  static const String _keyToken = 'token';
  static const String _keyRememberMe = 'remember_me';
  static const String _keyLanguage = 'language';
  static const String _keyIsFirstTime = 'is_first_time';

  // User management
  Future<void> saveUser(UserModel user) async {
    final userJson = json.encode(user.toJson());
    await _prefs.setString(_keyUser, userJson);
  }

  UserModel? getUser() {
    final userJson = _prefs.getString(_keyUser);
    if (userJson != null) {
      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    }
    return null;
  }

  Future<void> removeUser() async {
    await _prefs.remove(_keyUser);
  }

  // Token management
  Future<void> saveToken(String token) async {
    await _prefs.setString(_keyToken, token);
  }

  String? getToken() {
    return _prefs.getString(_keyToken);
  }

  Future<void> removeToken() async {
    await _prefs.remove(_keyToken);
  }

  // Remember me functionality
  Future<void> saveRememberMe(bool remember) async {
    await _prefs.setBool(_keyRememberMe, remember);
  }

  bool getRememberMe() {
    return _prefs.getBool(_keyRememberMe) ?? false;
  }

  // Language preferences
  Future<void> saveLanguage(String language) async {
    await _prefs.setString(_keyLanguage, language);
  }

  String getLanguage() {
    return _prefs.getString(_keyLanguage) ?? 'English';
  }

  String getLanguageSync() {
    return _prefs.getString(_keyLanguage) ?? 'English';
  }

  // First time app launch
  Future<void> setFirstTime(bool isFirstTime) async {
    await _prefs.setBool(_keyIsFirstTime, isFirstTime);
  }

  bool isFirstTime() {
    return _prefs.getBool(_keyIsFirstTime) ?? true;
  }

  // Clear all data
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  // Clear user session data only (keep preferences)
  Future<void> clearSession() async {
    await removeUser();
    await removeToken();
    await saveRememberMe(false);
  }

  // Check if user is logged in
  bool isLoggedIn() {
    final user = getUser();
    final token = getToken();
    return user != null && token != null;
  }

  // Get stored data for debugging
  Map<String, dynamic> getAllStoredData() {
    final keys = _prefs.getKeys();
    final data = <String, dynamic>{};

    for (final key in keys) {
      final value = _prefs.get(key);
      data[key] = value;
    }

    return data;
  }

  // Storage statistics
  int getStorageSize() {
    return _prefs.getKeys().length;
  }

  // Backup and restore functionality
  Map<String, dynamic> exportData() {
    final data = <String, dynamic>{};
    final keys = _prefs.getKeys();

    for (final key in keys) {
      data[key] = _prefs.get(key);
    }

    return data;
  }

  Future<void> importData(Map<String, dynamic> data) async {
    for (final entry in data.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is String) {
        await _prefs.setString(key, value);
      } else if (value is bool) {
        await _prefs.setBool(key, value);
      } else if (value is int) {
        await _prefs.setInt(key, value);
      } else if (value is double) {
        await _prefs.setDouble(key, value);
      } else if (value is List<String>) {
        await _prefs.setStringList(key, value);
      }
    }
  }

  // Utility methods
  Future<bool> hasKey(String key) async {
    return _prefs.containsKey(key);
  }

  Future<void> removeKey(String key) async {
    await _prefs.remove(key);
  }

  // App settings
  Future<void> saveAppSetting(String key, dynamic value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    }
  }

  T? getAppSetting<T>(String key, [T? defaultValue]) {
    final value = _prefs.get(key);
    if (value is T) {
      return value;
    }
    return defaultValue;
  }

  // Session management
  Future<void> refreshSession() async {
    final user = getUser();
    if (user != null) {
      await saveUser(user);
    }
  }

  // Migration support for app updates
  Future<void> migrate() async {
    // Add migration logic here for future app updates
    // This method can be called during app initialization
    // to handle data structure changes between app versions
  }
}
