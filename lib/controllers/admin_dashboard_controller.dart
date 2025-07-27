import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AdminDashboardController extends GetxController {
  UserModel? get currentUser => AuthService.to.currentUser;

  // Reactive variables for dashboard state
  var isLoading = false.obs;
  var reportGenerating = false.obs;
  var selectedLanguage = 'English'.obs;

  // Admin stats (mock data for now)
  var totalCities = 25.obs;
  var totalUsers = 342.obs;
  var activeReports = 18.obs;
  var pendingApprovals = 7.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAdminAccess();
    _loadAdminStats();
  }

  void _checkAdminAccess() {
    final user = currentUser;
    if (user == null || !user.isAdmin) {
      Get.snackbar(
        'error'.tr,
        'access_denied_admin'.tr,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      Get.offAllNamed('/login');
    }
  }

  void _loadAdminStats() {
    // Simulate loading admin-level statistics
    // In real implementation, this would fetch from Firebase/API
    print('Loading central admin statistics...');
  }

  // Full City/Center Dashboards
  void openCityCenterDashboard() {
    Get.snackbar(
      'city_center_dashboard'.tr,
      'opening_city_center_dashboard'.tr,
      backgroundColor: const Color(0xFF2E7D32),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );

    // Navigate to city/center dashboard screen (implement when ready)
    // Get.toNamed('/city-center-dashboard');
  }

  // Auto-report generation (1st–5th)
  Future<void> generateAutoReports() async {
    if (reportGenerating.value) return; // Prevent multiple calls

    try {
      reportGenerating.value = true;

      Get.snackbar(
        'auto_report_generation'.tr,
        'generating_reports_1st_5th'.tr,
        backgroundColor: const Color(0xFF2E7D32),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // Simulate report generation process
      await Future.delayed(const Duration(seconds: 4));

      Get.snackbar(
        'auto_report_generation'.tr,
        'reports_generated_successfully'.tr,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      // In real implementation, this would:
      // 1. Generate reports for 1st to 5th of current month
      // 2. Create PDF files with statistics
      // 3. Send notifications to relevant stakeholders
      // await _generateMonthlyReports();

    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'report_generation_failed'.tr,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      reportGenerating.value = false;
    }
  }

  // User Management
  void openUserManagement() {
    Get.snackbar(
      'user_management'.tr,
      'opening_user_management'.tr,
      backgroundColor: const Color(0xFF2E7D32),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );

    // Navigate to user management screen (implement when ready)
    // Get.toNamed('/user-management');
  }

  // Full Tracker Access
  void openFullTrackerAccess() {
    Get.snackbar(
      'full_tracker_access'.tr,
      'opening_full_tracker_access'.tr,
      backgroundColor: const Color(0xFF2E7D32),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );

    // Navigate to full tracker access screen (implement when ready)
    // Get.toNamed('/full-tracker-access');
  }

  // Logout with confirmation dialog
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
              'logout_warning_admin'.tr,
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
        'admin_session_ending'.tr,
        backgroundColor: const Color(0xFF2E7D32),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      await AuthService.to.logout();
      Get.offAllNamed('/login');
    }
  }

  // Refresh admin stats
  Future<void> refreshStats() async {
    isLoading.value = true;

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    // Update stats with new mock data
    totalUsers.value += 5;
    activeReports.value += 2;
    pendingApprovals.value -= 1;

    isLoading.value = false;

    Get.snackbar(
      'success'.tr,
      'admin_stats_updated'.tr,
      backgroundColor: const Color(0xFF4CAF50),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
}
