import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/models/models.dart';
import '../services/auth_service.dart';
import '../../../services/storage_service.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var selectedLanguage = 'English'.obs;
  var rememberMe = false.obs;

  // Add reactive locale state
  var currentLocale = const Locale('en', 'US').obs;

  final languages = ['English', 'मराठी'];

  @override
  void onInit() {
    super.onInit();
    _loadSavedPreferences();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _loadSavedPreferences() {
    selectedLanguage.value = StorageService.to.getLanguage();
    rememberMe.value = StorageService.to.getRememberMe();

    // Set current locale based on saved preference
    _updateAppLocale(selectedLanguage.value);
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void changeLanguage(String language) async {
    selectedLanguage.value = language;
    await StorageService.to.saveLanguage(language);
    _updateAppLocale(language);
  }

  void _updateAppLocale(String language) {
    if (language == 'मराठी') {
      currentLocale.value = const Locale('mr', 'IN');
      Get.updateLocale(const Locale('mr', 'IN'));
    } else {
      currentLocale.value = const Locale('en', 'US');
      Get.updateLocale(const Locale('en', 'US'));
    }

    // Force update the form key to rebuild form fields
    update(['form_fields']);
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
    StorageService.to.saveRememberMe(rememberMe.value);
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'username_email_required'.tr;
    }
    if (value.length < 3) {
      return 'username_min_length'.tr;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'password_required'.tr;
    }
    if (value.length < 6) {
      return 'password_min_length'.tr;
    }
    return null;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      final response = await AuthService.to.login(
        username: usernameController.text.trim(),
        password: passwordController.text,
        rememberMe: rememberMe.value,
      );

      if (response.success) {
        Get.snackbar(
          'success'.tr,
          '${'login_successful'.tr} - ${'role_label'.tr} ${_translateRole(response.user?.role)}',
          backgroundColor: const Color(0xFF2E7D32),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );

        _navigateBasedOnRole(response.user!);
      } else {
        Get.snackbar(
          'error'.tr,
          response.message ?? 'login_failed'.tr,
          backgroundColor: const Color(0xFFD32F2F),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'something_wrong'.tr,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _translateRole(String? role) {
    switch (role) {
      case 'admin':
        return 'admin'.tr;
      case 'ngo_supervisor':
        return 'ngo_supervisor'.tr;
      case 'field_staff':
        return 'field_staff'.tr;
      case 'municipal_readonly':
        return 'municipal_readonly'.tr;
      default:
        return role ?? '';
    }
  }

  void _navigateBasedOnRole(UserModel user) {
    Get.snackbar(
      '${'welcome'.tr} ${user.displayName}',
      '${'role_label'.tr} ${_translateRole(user.role)}\n${'layer'.tr} ${user.layer}\n${'city'.tr} ${user.assignedCity}',
      backgroundColor: const Color(0xFF2E7D32),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );

    // Navigate based on role
    switch (user.role) {
      case 'admin':
        Get.offAllNamed('/admin-dashboard');
        break;
      case 'field_staff':
        Get.offAllNamed('/field-dashboard');
        break;
      case 'ngo_supervisor':
        Get.offAllNamed('/supervisor-dashboard');
        break;
      case 'municipal_readonly':
        Get.offAllNamed('/municipal-dashboard');
        break;
      default:
        Get.offAllNamed('/dashboard');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final response = await AuthService.to.signInWithGoogle();

      if (response.success) {
        Get.snackbar(
          'success'.tr,
          'google_signin_successful'.tr,
          backgroundColor: const Color(0xFF2E7D32),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        if (response.user != null) {
          _navigateBasedOnRole(response.user!);
        }
      } else {
        Get.snackbar(
          'info'.tr,
          response.message ?? 'google_signin_not_available'.tr,
          backgroundColor: const Color(0xFFFFA000),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void forgotPassword() {
    Get.defaultDialog(
      title: 'reset_password'.tr,
      content: Column(
        children: [
          Text('enter_email_reset'.tr),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'email'.tr,
              border: const OutlineInputBorder(),
            ),
            onFieldSubmitted: (email) async {
              if (email.isNotEmpty) {
                final response = await AuthService.to.resetPassword(email);
                Get.back();

                Get.snackbar(
                  response.success ? 'success'.tr : 'info'.tr,
                  response.message ?? '',
                  backgroundColor: response.success
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFFFA000),
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                );
              }
            },
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        child: Text('cancel'.tr),
      ),
    );
  }

  void navigateToSignup() {
    Get.toNamed('/signup');
  }

  void showDummyCredentials() {
    Get.defaultDialog(
      title: 'demo_credentials'.tr,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'try_demo_accounts'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildCredentialItem('admin'.tr, 'admin / password'),
          _buildCredentialItem('supervisor'.tr, 'supervisor1 / supervisor123'),
          _buildCredentialItem('field_staff'.tr, 'fieldstaff1 / field123'),
          _buildCredentialItem('municipal'.tr, 'municipal1 / municipal123'),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () => Get.back(),
        child: Text('close'.tr),
      ),
    );
  }

  Widget _buildCredentialItem(String role, String credentials) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text('$role: $credentials')),
          IconButton(
            onPressed: () {
              final parts = credentials.split(' / ');
              if (parts.length == 2) {
                usernameController.text = parts[0];
                passwordController.text = parts[1];
                Get.back();
              }
            },
            icon: const Icon(Icons.copy),
            iconSize: 16,
          ),
        ],
      ),
    );
  }
}
