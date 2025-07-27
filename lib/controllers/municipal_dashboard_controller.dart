import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class MunicipalDashboardController extends GetxController {
  UserModel? get currentUser => AuthService.to.currentUser;

  // Reactive variables for dashboard state
  var isLoading = false.obs;
  var selectedLanguage = 'English'.obs;
  var isGeneratingReport = false.obs;

  // Mock statistics data (replace with real data later)
  var sterilizationStats = {
    'total': 1250,
    'thisMonth': 145,
    'pending': 23,
    'completed': 1227,
  }.obs;

  var biteStats = {
    'total': 89,
    'thisMonth': 12,
    'resolved': 76,
    'active': 13,
  }.obs;

  var rabiesStats = {
    'total': 8,
    'thisMonth': 2,
    'vaccinated': 156,
    'surveillance': 45,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    _checkUserPermissions();
    _loadStatistics();
  }

  void _checkUserPermissions() {
    final user = currentUser;
    if (user == null || (!user.isMunicipalOfficial && !user.isAdmin)) {
      Get.snackbar(
        'error'.tr,
        'Access denied. Municipal official permissions required.',
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      Get.offAllNamed('/login');
    }
  }

  void _loadStatistics() {
    // Simulate loading statistics
    // In real implementation, this would fetch from Firebase/API
    print('Loading municipal statistics...');
  }

  // Stats Overview function
  void viewStatsOverview() {
    Get.snackbar(
      'stats_overview'.tr,
      'Displaying comprehensive statistics overview...',
      backgroundColor: const Color(0xFF2E7D32),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );

    // Navigate to detailed stats screen (implement when ready)
    // Get.toNamed('/municipal-stats-overview');
  }

  // City Report PDF Download
  Future<void> downloadCityReport() async {
    final user = currentUser;

    try {
      isGeneratingReport.value = true;

      Get.snackbar(
        'generating_report'.tr,
        'Preparing city report PDF for ${user?.assignedCity}...',
        backgroundColor: const Color(0xFF2E7D32),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // Simulate report generation delay
      await Future.delayed(const Duration(seconds: 3));

      Get.snackbar(
        'report_ready'.tr,
        'City report PDF generated successfully!',
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // In real implementation, this would:
      // 1. Generate PDF with statistics
      // 2. Download or share the file
      // await _generateAndDownloadPDF();

    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to generate report. Please try again.',
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isGeneratingReport.value = false;
    }
  }

  // Photo Logs function
  void viewPhotoLogs() {
    Get.snackbar(
      'photo_logs'.tr,
      'Opening photo logs gallery...',
      backgroundColor: const Color(0xFF2E7D32),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );

    // Navigate to photo logs screen (implement when ready)
    // Get.toNamed('/municipal-photo-logs');
  }

  // Refresh statistics
  Future<void> refreshStats() async {
    isLoading.value = true;

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    // Update stats with new mock data
    sterilizationStats.value = {
      'total': sterilizationStats['total']! + 5,
      'thisMonth': sterilizationStats['thisMonth']! + 3,
      'pending': sterilizationStats['pending']! - 1,
      'completed': sterilizationStats['completed']! + 4,
    };

    isLoading.value = false;

    Get.snackbar(
      'success'.tr,
      'Statistics updated successfully',
      backgroundColor: const Color(0xFF4CAF50),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Logout function
// Enhanced Logout with confirmation dialog for Municipal Official
  Future<void> logout() async {
    bool? confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(
              Icons.logout,
              color: const Color(0xFF2E7D32),
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'confirm_logout'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
              'logout_warning_municipal'.tr,
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
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
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
            child: Text(
              'logout'.tr,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (confirm == true) {
      // Show logout process
      Get.snackbar(
        'logging_out'.tr,
        'municipal_session_ending'.tr,
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
