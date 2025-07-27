import 'package:get/get.dart';
import '../models/user_model.dart';
import '../models/auth_response_model.dart';
import 'storage_service.dart';
import 'dummy_data_service.dart';
// import 'firebase_service.dart'; // Uncomment when ready for Firebase

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  UserModel? get currentUser => _currentUser.value;
  bool get isLoggedIn => _currentUser.value != null;

  @override
  void onInit() {
    super.onInit();
    _loadSavedUser();
  }

  // Load saved user from storage
  void _loadSavedUser() {
    final user = StorageService.to.getUser();
    if (user != null && StorageService.to.getRememberMe()) {
      _currentUser.value = user;
    }
  }

  // Login method that uses dummy data for now, Firebase-ready for future
  Future<AuthResponse> login({
    required String username,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      // For now, use dummy data authentication
      // In the future, uncomment the Firebase line and comment out the dummy line

      // Firebase authentication (for future use)
      // final response = await FirebaseService.signInWithEmailPassword(
      //   email: username,
      //   password: password,
      // );

      // Dummy data authentication (current implementation)
      final response = await DummyDataService.authenticateUser(
        username: username,
        password: password,
      );

      if (response.success && response.user != null) {
        _currentUser.value = response.user;

        // Save user data if remember me is enabled
        if (rememberMe) {
          await StorageService.to.saveUser(response.user!);
          await StorageService.to.saveRememberMe(true);
        }

        // Save token if available
        if (response.token != null) {
          await StorageService.to.saveToken(response.token!);
        }
      }

      return response;
    } catch (e) {
      return AuthResponse.failure('Login failed: ${e.toString()}');
    }
  }

  // Signup method
  Future<AuthResponse> signup({
    required String username,
    required String email,
    required String password,
    String? displayName,
    String role = 'field_staff',
  }) async {
    try {
      // For now, use dummy data
      // In the future, use Firebase

      // Firebase authentication (for future use)
      // final response = await FirebaseService.signUpWithEmailPassword(
      //   email: email,
      //   password: password,
      //   username: username,
      //   displayName: displayName,
      // );

      // Dummy data authentication (current implementation)
      final response = await DummyDataService.createUser(
        username: username,
        email: email,
        password: password,
        displayName: displayName,
        role: role,
      );

      if (response.success && response.user != null) {
        _currentUser.value = response.user;

        // Save user data
        await StorageService.to.saveUser(response.user!);

        // Save token if available
        if (response.token != null) {
          await StorageService.to.saveToken(response.token!);
        }
      }

      return response;
    } catch (e) {
      return AuthResponse.failure('Signup failed: ${e.toString()}');
    }
  }

  // Google Sign In (Firebase only - will be enabled later)
  Future<AuthResponse> signInWithGoogle() async {
    try {
      // This will be enabled when Firebase is integrated
      // final response = await FirebaseService.signInWithGoogle();

      // For now, return not implemented
      return AuthResponse.failure('Google Sign-In will be available with Firebase integration');

    } catch (e) {
      return AuthResponse.failure('Google sign-in failed: ${e.toString()}');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      // await FirebaseService.signOut(); // For future Firebase integration
    } catch (e) {
      // Handle Firebase logout error
    }

    _currentUser.value = null;
    await StorageService.to.clearAll();
  }

  // Reset password (Firebase only - will be enabled later)
  Future<AuthResponse> resetPassword(String email) async {
    // For now, simulate password reset
    await Future.delayed(const Duration(seconds: 1));
    return AuthResponse.success(message: 'Password reset instructions sent to $email');

    // For future Firebase integration:
    // return await FirebaseService.resetPassword(email);
  }
}
