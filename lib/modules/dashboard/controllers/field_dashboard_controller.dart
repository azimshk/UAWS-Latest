import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/models/models.dart';
import '../../auth/services/auth_service.dart';

class FieldDashboardController extends GetxController {
  UserModel? get currentUser => AuthService.to.currentUser;

  // Reactive variables for dashboard state
  var isLoading = false.obs;
  var selectedLanguage = 'English'.obs;

  @override
  void onInit() {
    super.onInit();
    _checkUserPermissions();
  }

  void _checkUserPermissions() {
    final user = currentUser;
    if (user == null || !user.isFieldStaff) {
      Get.snackbar(
        'error'.tr,
        'Access denied. Field staff permissions required.',
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      Get.offAllNamed('/login');
    }
  }

  // Start Pickup (Sterilization) function
  void startPickup() {
    final user = currentUser;
    if (user != null && user.hasPermission('sterilization', 'create')) {
      Get.snackbar(
        'sterilization_pickup'.tr,
        'Opening sterilization tracker...',
        backgroundColor: const Color(0xFF2E7D32),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // Navigate to sterilization tracker screen
      Get.toNamed('/sterilization');
    } else {
      Get.snackbar(
        'error'.tr,
        'You do not have permission to start sterilization pickup',
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // Add Vaccination Entry function
  void addVaccinationEntry() {
    final user = currentUser;
    if (user != null && user.hasPermission('vaccination', 'create')) {
      Get.snackbar(
        'vaccination_entry'.tr,
        'Adding new vaccination entry...',
        backgroundColor: const Color(0xFF2E7D32),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // Navigate to vaccination entry screen (implement when ready)
      // Get.toNamed('/vaccination-entry');
    } else {
      Get.snackbar(
        'error'.tr,
        'You do not have permission to add vaccination entries',
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  // View My Submissions function
  void viewMySubmissions() {
    Get.snackbar(
      'my_submissions'.tr,
      'Loading your submissions...',
      backgroundColor: const Color(0xFF2E7D32),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );

    // Navigate to submissions screen (implement when ready)
    // Get.toNamed('/my-submissions');
  }

  // Logout function
  // Enhanced Logout with confirmation dialog for Field Staff
  Future<void> logout() async {
    bool? confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.logout, color: const Color(0xFF2E7D32), size: 28),
            const SizedBox(width: 12),
            Text(
              'confirm_logout'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'are_you_sure_logout'.tr,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              'logout_warning_field_staff'.tr,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              'cancel'.tr,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('logout'.tr, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (confirm == true) {
      // Show logout process
      Get.snackbar(
        'logging_out'.tr,
        'field_staff_session_ending'.tr,
        backgroundColor: const Color(0xFF2E7D32),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      await AuthService.to.logout();
      Get.offAllNamed('/login');
    }
  }
}
