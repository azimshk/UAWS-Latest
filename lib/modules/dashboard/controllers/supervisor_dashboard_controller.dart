import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/models/models.dart';
import '../../auth/services/auth_service.dart';

class SupervisorDashboardController extends GetxController {
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
    if (user == null || (!user.isSupervisor && !user.isAdmin)) {
      Get.snackbar(
        'error'.tr,
        'Access denied. NGO Supervisor permissions required.',
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      Get.offAllNamed('/login');
    }
  }

  // Sterilization Tracker (Full)
  void openSterilizationTracker() {
    final user = currentUser;
    if (user != null && user.hasPermission('sterilization', 'read')) {
      Get.snackbar(
        'sterilization_tracker'.tr,
        'Opening full sterilization tracking dashboard...',
        backgroundColor: const Color(0xFF2E7D32),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // Navigate to sterilization tracker screen
      Get.toNamed('/sterilization');
    } else {
      _showPermissionError('sterilization tracking');
    }
  }

  // Bite Case Tracker (Full)
  void openBiteCaseTracker() {
    final user = currentUser;
    if (user != null && user.hasPermission('biteCases', 'read')) {
      Get.snackbar(
        'bite_case_tracker'.tr,
        'Opening bite case management system...',
        backgroundColor: const Color(0xFF2E7D32),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // Navigate to bite case tracker screen (implement when ready)
      // Get.toNamed('/bite-case-tracker');
    } else {
      _showPermissionError('bite case tracking');
    }
  }

  // Rabies Surveillance
  void openRabiesSurveillance() {
    final user = currentUser;
    if (user != null && user.hasPermission('rabies', 'read')) {
      Get.snackbar(
        'rabies_surveillance'.tr,
        'Opening rabies surveillance dashboard...',
        backgroundColor: const Color(0xFF2E7D32),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // Navigate to rabies surveillance screen (implement when ready)
      // Get.toNamed('/rabies-surveillance');
    } else {
      _showPermissionError('rabies surveillance');
    }
  }

  // Quarantine Tracker
  void openQuarantineTracker() {
    final user = currentUser;
    if (user != null && user.hasPermission('quarantine', 'read')) {
      Get.snackbar(
        'quarantine_tracker'.tr,
        'Opening quarantine management system...',
        backgroundColor: const Color(0xFF2E7D32),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // Navigate to quarantine tracker screen (implement when ready)
      // Get.toNamed('/quarantine-tracker');
    } else {
      _showPermissionError('quarantine tracking');
    }
  }

  // Education Tracker
  void openEducationTracker() {
    final user = currentUser;
    if (user != null && user.hasPermission('education', 'read')) {
      Get.snackbar(
        'education_tracker'.tr,
        'Opening education program tracker...',
        backgroundColor: const Color(0xFF2E7D32),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // Navigate to education tracker screen (implement when ready)
      // Get.toNamed('/education-tracker');
    } else {
      _showPermissionError('education tracking');
    }
  }

  // Monitor Field Staff Entries
  void openFieldStaffMonitor() {
    Get.snackbar(
      'field_staff_monitor'.tr,
      'Opening field staff monitoring dashboard...',
      backgroundColor: const Color(0xFF2E7D32),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );

    // Navigate to field staff monitor screen (implement when ready)
    // Get.toNamed('/field-staff-monitor');
  }

  // City/District Dashboard
  void openCityDashboard() {
    final user = currentUser;
    Get.snackbar(
      'city_dashboard'.tr,
      'Opening city/district overview for ${user?.assignedCity}...',
      backgroundColor: const Color(0xFF2E7D32),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );

    // Navigate to city dashboard screen (implement when ready)
    // Get.toNamed('/city-dashboard');
  }

  void _showPermissionError(String feature) {
    Get.snackbar(
      'error'.tr,
      'You do not have permission to access $feature',
      backgroundColor: const Color(0xFFD32F2F),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  // Logout with confirmation dialog
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
              'logout_warning_supervisor'.tr,
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
        'supervisor_session_ending'.tr,
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
