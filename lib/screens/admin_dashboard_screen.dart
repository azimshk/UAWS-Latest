import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardScreen extends GetView<AdminDashboardController> {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('admin_dashboard'.tr),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Obx(() => IconButton(
            onPressed: controller.isLoading.value ? null : controller.refreshStats,
            icon: controller.isLoading.value
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : const Icon(Icons.refresh),
            tooltip: 'refresh_stats'.tr,
          )),
          IconButton(
            onPressed: controller.logout,
            icon: const Icon(Icons.logout),
            tooltip: 'logout'.tr,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshStats,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Admin Header
              _buildAdminHeader(),

              // Admin Stats Overview
              _buildAdminStats(),

              // Main Dashboard Features
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Full City/Center Dashboards
                    _buildDashboardTile(
                      icon: Icons.location_city,
                      title: 'city_center_dashboard'.tr,
                      subtitle: 'view_dashboards_per_city_center'.tr,
                      color: const Color(0xFF2E7D32),
                      onTap: controller.openCityCenterDashboard,
                    ),

                    const SizedBox(height: 12),

                    // Auto-report generation (1st–5th)
                    Obx(() => _buildReportGenerationTile()),

                    const SizedBox(height: 12),

                    // User Management
                    _buildDashboardTile(
                      icon: Icons.people_alt,
                      title: 'user_management'.tr,
                      subtitle: 'manage_users_roles_permissions'.tr,
                      color: const Color(0xFF4CAF50),
                      onTap: controller.openUserManagement,
                    ),

                    const SizedBox(height: 12),

                    // Full Tracker Access
                    _buildDashboardTile(
                      icon: Icons.track_changes,
                      title: 'full_tracker_access'.tr,
                      subtitle: 'access_all_trackers_and_data'.tr,
                      color: const Color(0xFF66BB6A),
                      onTap: controller.openFullTrackerAccess,
                    ),

                    const SizedBox(height: 24),

                    // System Overview Card
                    _buildSystemOverviewCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminHeader() {
    final user = controller.currentUser;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2E7D32),
            const Color(0xFF4CAF50),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.admin_panel_settings,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${'welcome'.tr}, ${user?.displayName ?? 'Administrator'}!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${'central_admin_access'.tr} | ${'layer'.tr}: ${user?.layer}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'full_system_access'.tr,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminStats() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          Obx(() => _buildStatCard(
            icon: Icons.location_city,
            label: 'total_cities'.tr,
            value: controller.totalCities.value.toString(),
            color: const Color(0xFF2E7D32),
          )),
          Obx(() => _buildStatCard(
            icon: Icons.people,
            label: 'total_users'.tr,
            value: controller.totalUsers.value.toString(),
            color: const Color(0xFF4CAF50),
          )),
          Obx(() => _buildStatCard(
            icon: Icons.assessment,
            label: 'active_reports'.tr,
            value: controller.activeReports.value.toString(),
            color: const Color(0xFF66BB6A),
          )),
          Obx(() => _buildStatCard(
            icon: Icons.pending_actions,
            label: 'pending_approvals'.tr,
            value: controller.pendingApprovals.value.toString(),
            color: const Color(0xFF81C784),
          )),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color,
          radius: 30,
          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            color: color,
            size: 16,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildReportGenerationTile() {
    return Card(
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: controller.reportGenerating.value
              ? Colors.orange
              : const Color(0xFF4CAF50),
          radius: 30,
          child: controller.reportGenerating.value
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : const Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: 28,
          ),
        ),
        title: Text(
          'auto_report_generation'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            controller.reportGenerating.value
                ? 'generating_reports'.tr
                : 'generate_reports_1st_5th'.tr,
            style: TextStyle(
              color: controller.reportGenerating.value
                  ? Colors.orange
                  : Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            controller.reportGenerating.value
                ? Icons.hourglass_top
                : Icons.play_circle_fill,
            color: const Color(0xFF4CAF50),
            size: 16,
          ),
        ),
        onTap: controller.reportGenerating.value ? null : controller.generateAutoReports,
      ),
    );
  }

  Widget _buildSystemOverviewCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.dashboard,
                  color: Color(0xFF2E7D32),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'system_overview'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              'admin_capabilities'.tr,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 8),

            _buildCapabilityItem('manage_all_cities_centers'.tr),
            _buildCapabilityItem('automated_report_generation'.tr),
            _buildCapabilityItem('complete_user_management'.tr),
            _buildCapabilityItem('full_data_access_control'.tr),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF2E7D32),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.security,
                    color: Color(0xFF2E7D32),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'layer_3_admin_access'.tr,
                      style: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapabilityItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF4CAF50),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
