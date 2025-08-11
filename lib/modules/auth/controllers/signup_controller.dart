import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../../../services/storage_service.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final displayNameController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var selectedRole = 'field_staff'.obs;
  var selectedLanguage = 'English'.obs;

  final roles = [
    {'value': 'field_staff', 'label': 'field_staff'},
    {'value': 'ngo_supervisor', 'label': 'ngo_supervisor'},
    {'value': 'municipal_readonly', 'label': 'municipal_readonly'},
  ];

  final languages = ['English', 'मराठी'];

  @override
  void onInit() {
    super.onInit();
    _loadSavedPreferences();
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    displayNameController.dispose();
    super.onClose();
  }

  void _loadSavedPreferences() {
    selectedLanguage.value = StorageService.to.getLanguage();
    _updateAppLocale(selectedLanguage.value);
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void changeRole(String? role) {
    if (role != null) {
      selectedRole.value = role;
    }
  }

  void changeLanguage(String language) {
    selectedLanguage.value = language;
    StorageService.to.saveLanguage(language);
    _updateAppLocale(language);
  }

  void _updateAppLocale(String language) {
    if (language == 'मराठी') {
      Get.updateLocale(const Locale('mr', 'IN'));
    } else {
      Get.updateLocale(const Locale('en', 'US'));
    }
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'username_required'.tr;
    }
    if (value.length < 3) {
      return 'username_min_length'.tr;
    }
    if (value.contains(' ')) {
      return 'username_no_spaces'.tr;
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'email_required'.tr;
    }
    if (!GetUtils.isEmail(value)) {
      return 'invalid_email'.tr;
    }
    return null;
  }

  String? validateDisplayName(String? value) {
    if (value == null || value.isEmpty) {
      return 'display_name_required'.tr;
    }
    if (value.length < 2) {
      return 'display_name_min_length'.tr;
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'confirm_password_required'.tr;
    }
    if (value != passwordController.text) {
      return 'passwords_not_match'.tr;
    }
    return null;
  }

  Future<void> signup() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      final response = await AuthService.to.signup(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        displayName: displayNameController.text.trim(),
        role: selectedRole.value,
      );

      if (response.success) {
        Get.snackbar(
          'success'.tr,
          '${'account_created'.tr}\n${'role_label'.tr} ${_translateRole(response.user?.role)}',
          backgroundColor: const Color(0xFF2E7D32),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );

        // Navigate to login
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'error'.tr,
          response.message ?? 'signup_failed'.tr,
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

  void navigateToLogin() {
    Get.offNamed('/login');
  }
}
