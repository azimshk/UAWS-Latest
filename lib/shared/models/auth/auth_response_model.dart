import 'user_model.dart';

class AuthResponse {
  final bool success;
  final String? message;
  final UserModel? user;
  final String? token;
  final String? refreshToken;

  AuthResponse({
    required this.success,
    this.message,
    this.user,
    this.token,
    this.refreshToken,
  });

  factory AuthResponse.success({
    UserModel? user,
    String? token,
    String? refreshToken,
    String? message,
  }) {
    return AuthResponse(
      success: true,
      user: user,
      token: token,
      refreshToken: refreshToken,
      message: message ?? 'Authentication successful',
    );
  }

  factory AuthResponse.failure(String message) {
    return AuthResponse(
      success: false,
      message: message,
    );
  }

  @override
  String toString() {
    return 'AuthResponse{success: $success, message: $message, user: ${user?.username}}';
  }
}
