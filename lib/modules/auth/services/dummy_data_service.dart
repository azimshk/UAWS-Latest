import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/models/models.dart';

class DummyDataService {
  static List<UserModel>? _users;
  static Map<String, dynamic>?
  _rawJsonData; // Store raw JSON for password checking

  // Load dummy users from JSON
  static Future<void> loadDummyData() async {
    if (_users != null) return; // Already loaded

    try {
      AppLogger.i('📁 Loading dummy data from assets/data/dummy_users.json...');

      final String jsonString = await rootBundle.loadString(
        'assets/data/dummy_users.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // Store raw JSON data for password verification
      _rawJsonData = jsonData;

      final List<dynamic> usersJson = jsonData['users'];

      _users = usersJson
          .map((userJson) => UserModel.fromJson(userJson))
          .toList();

      AppLogger.i('✅ Loaded ${_users!.length} dummy users');

      // Debug: Print loaded usernames
      AppLogger.d('📋 Available users:');
      for (var user in _users!) {
        AppLogger.d(
          '   - Username: ${user.username}, Email: ${user.email}, Role: ${user.role}',
        );
      }
    } catch (e) {
      AppLogger.e('❌ Error loading dummy data', e);
      _users = [];
      _rawJsonData = null;
    }
  }

  // Authenticate user with dummy data
  static Future<AuthResponse> authenticateUser({
    required String username,
    required String password,
  }) async {
    await loadDummyData();

    AppLogger.d('🔍 Attempting authentication for: $username');

    // Check if data is loaded
    if (_users == null || _users!.isEmpty) {
      AppLogger.w('❌ No users loaded from JSON');
      return AuthResponse.failure('Authentication service unavailable');
    }

    if (_rawJsonData == null) {
      AppLogger.w('❌ Raw JSON data not available');
      return AuthResponse.failure('Authentication service unavailable');
    }

    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    try {
      // Find user by username or email
      final user = _users!.firstWhere(
        (user) =>
            user.username.toLowerCase() == username.toLowerCase() ||
            user.email.toLowerCase() == username.toLowerCase(),
        orElse: () => throw Exception('User not found'),
      );

      AppLogger.d('👤 Found user: ${user.username} (${user.email})');

      // Check password from raw JSON data
      final List<dynamic> usersJson = _rawJsonData!['users'];

      final matchingUser = usersJson.firstWhere(
        (userJson) =>
            (userJson['username'].toString().toLowerCase() ==
                    username.toLowerCase() ||
                userJson['email'].toString().toLowerCase() ==
                    username.toLowerCase()) &&
            userJson['password'].toString() == password,
        orElse: () => null,
      );

      if (matchingUser != null) {
        AppLogger.i('✅ Password verification successful');

        final authenticatedUser = user.copyWith(lastLogin: DateTime.now());

        return AuthResponse.success(
          user: authenticatedUser,
          token: _generateDummyToken(user.id!),
          message: 'Login successful',
        );
      } else {
        AppLogger.w('❌ Password verification failed');
        AppLogger.d(
          '   Expected password from JSON: ${_getPasswordFromJson(username)}',
        );
        AppLogger.d('   Provided password: $password');
        return AuthResponse.failure('Invalid username or password');
      }
    } catch (e) {
      AppLogger.e('❌ Authentication error', e);
      if (e.toString().contains('User not found')) {
        return AuthResponse.failure('User not found');
      }
      return AuthResponse.failure('Invalid username or password');
    }
  }

  // Helper method to get password from JSON for debugging
  static String? _getPasswordFromJson(String username) {
    if (_rawJsonData == null) return null;

    try {
      final List<dynamic> usersJson = _rawJsonData!['users'];
      final userJson = usersJson.firstWhere(
        (userJson) =>
            userJson['username'].toString().toLowerCase() ==
                username.toLowerCase() ||
            userJson['email'].toString().toLowerCase() ==
                username.toLowerCase(),
        orElse: () => null,
      );

      return userJson?['password']?.toString();
    } catch (e) {
      return null;
    }
  }

  // Create new user (for signup)
  static Future<AuthResponse> createUser({
    required String username,
    required String email,
    required String password,
    String? displayName,
    String role = 'field_staff',
    String layer = 'Layer1',
    String assignedCity = 'Pune',
    List<String>? assignedWard,
  }) async {
    await loadDummyData();

    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    try {
      // Check if user already exists
      final existingUser = _users
          ?.where(
            (user) =>
                user.username.toLowerCase() == username.toLowerCase() ||
                user.email.toLowerCase() == email.toLowerCase(),
          )
          .toList();

      if (existingUser != null && existingUser.isNotEmpty) {
        return AuthResponse.failure(
          'User already exists with this username or email',
        );
      }

      // Create new user
      final newUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        username: username,
        email: email,
        displayName: displayName ?? username,
        role: role,
        layer: layer,
        assignedCity: assignedCity,
        assignedWard: assignedWard ?? ['Ward 1'],
        permissions: _getDefaultPermissions(role),
        lastLogin: DateTime.now(),
        isActive: true,
      );

      // In a real app, this would be saved to Firebase
      // For now, we'll just return the created user
      _users?.add(newUser);

      return AuthResponse.success(
        user: newUser,
        token: _generateDummyToken(newUser.id!),
        message: 'Account created successfully',
      );
    } catch (e) {
      return AuthResponse.failure('Failed to create account: ${e.toString()}');
    }
  }

  // Get default permissions based on role
  static Map<String, dynamic> _getDefaultPermissions(String role) {
    switch (role) {
      case 'admin':
        return {
          'sterilization': {
            'create': true,
            'read': true,
            'update': true,
            'delete': true,
          },
          'vaccination': {
            'create': true,
            'read': true,
            'update': true,
            'delete': true,
          },
          'biteCases': {
            'create': true,
            'read': true,
            'update': true,
            'delete': true,
          },
          'quarantine': {
            'create': true,
            'read': true,
            'update': true,
            'delete': true,
          },
          'rabies': {
            'create': true,
            'read': true,
            'update': true,
            'delete': true,
          },
          'education': {
            'create': true,
            'read': true,
            'update': true,
            'delete': true,
          },
        };
      case 'ngo_supervisor':
        return {
          'sterilization': {
            'create': false,
            'read': true,
            'update': true,
            'delete': false,
          },
          'vaccination': {
            'create': true,
            'read': true,
            'update': true,
            'delete': false,
          },
          'biteCases': {
            'create': true,
            'read': true,
            'update': true,
            'delete': false,
          },
          'quarantine': {
            'create': true,
            'read': true,
            'update': true,
            'delete': false,
          },
          'rabies': {
            'create': true,
            'read': true,
            'update': true,
            'delete': false,
          },
          'education': {
            'create': true,
            'read': true,
            'update': true,
            'delete': false,
          },
        };
      case 'field_staff':
        return {
          'sterilization': {
            'create': true,
            'read': true,
            'update': false,
            'delete': false,
          },
          'vaccination': {
            'create': true,
            'read': true,
            'update': true,
            'delete': false,
          },
          'biteCases': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          },
          'quarantine': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          },
          'rabies': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          },
          'education': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          },
        };
      default:
        return {
          'sterilization': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          },
          'vaccination': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          },
          'biteCases': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          },
          'quarantine': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          },
          'rabies': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          },
          'education': {
            'create': false,
            'read': true,
            'update': false,
            'delete': false,
          },
        };
    }
  }

  // Generate dummy token for testing
  static String _generateDummyToken(String userId) {
    return 'dummy_token_${userId}_${DateTime.now().millisecondsSinceEpoch}';
  }

  // Get all users (for testing purposes)
  static Future<List<UserModel>> getAllUsers() async {
    await loadDummyData();
    return _users ?? [];
  }

  // Debug method to check if specific user exists
  static Future<bool> userExists(String username) async {
    await loadDummyData();
    return _users?.any(
          (user) =>
              user.username.toLowerCase() == username.toLowerCase() ||
              user.email.toLowerCase() == username.toLowerCase(),
        ) ??
        false;
  }

  // Debug method to list all usernames
  static Future<List<String>> getAllUsernames() async {
    await loadDummyData();
    return _users?.map((user) => user.username).toList() ?? [];
  }
}
