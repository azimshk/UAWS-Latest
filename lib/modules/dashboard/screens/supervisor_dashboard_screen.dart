import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/supervisor_dashboard_controller.dart';
import '../../../shared/utils/responsive_utils.dart';

class SupervisorDashboardScreen extends GetView<SupervisorDashboardController> {
  const SupervisorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('supervisor_dashboard'.tr),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: controller.logout,
            icon: const Icon(Icons.logout),
            tooltip: 'logout'.tr,
          ),
        ],
      ),
      body: Column(
        children: [
          // Welcome Header
          _buildWelcomeHeader(),

          // Dashboard Items
          Expanded(
            child: ListView(
              padding: context.responsivePadding,
              children: [
                // Sterilization Tracker (Full)
                _buildDashboardTile(
                  icon: Icons.pets,
                  title: 'sterilization_tracker_full'.tr,
                  subtitle: 'sterilization_tracker_desc'.tr,
                  onTap: controller.openSterilizationTracker,
                  color: const Color(0xFF2E7D32),
                ),

                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 12),
                ),

                // Bite Case Tracker (Full)
                _buildDashboardTile(
                  icon: Icons.healing,
                  title: 'bite_case_tracker_full'.tr,
                  subtitle: 'bite_case_tracker_desc'.tr,
                  onTap: controller.openBiteCaseTracker,
                  color: const Color(0xFF4CAF50),
                ),

                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 12),
                ),

                // Rabies Surveillance
                _buildDashboardTile(
                  icon: Icons.monitor_heart,
                  title: 'rabies_surveillance'.tr,
                  subtitle: 'rabies_surveillance_desc'.tr,
                  onTap: controller.openRabiesSurveillance,
                  color: const Color(0xFF66BB6A),
                ),

                const SizedBox(height: 12),

                // Quarantine Tracker
                _buildDashboardTile(
                  icon: Icons.home_work,
                  title: 'quarantine_tracker'.tr,
                  subtitle: 'quarantine_tracker_desc'.tr,
                  onTap: controller.openQuarantineTracker,
                  color: const Color(0xFF81C784),
                ),

                const SizedBox(height: 12),

                // Education Tracker
                _buildDashboardTile(
                  icon: Icons.school,
                  title: 'education_tracker'.tr,
                  subtitle: 'education_tracker_desc'.tr,
                  onTap: controller.openEducationTracker,
                  color: const Color(0xFF9CCC65),
                ),

                const SizedBox(height: 12),

                // Monitor Field Staff Entries
                _buildDashboardTile(
                  icon: Icons.people,
                  title: 'monitor_field_staff'.tr,
                  subtitle: 'monitor_field_staff_desc'.tr,
                  onTap: controller.openFieldStaffMonitor,
                  color: const Color(0xFFAED581),
                ),

                const SizedBox(height: 12),

                // City/District Dashboard
                _buildDashboardTile(
                  icon: Icons.location_city,
                  title: 'city_district_dashboard'.tr,
                  subtitle: 'city_dashboard_desc'.tr,
                  onTap: controller.openCityDashboard,
                  color: const Color(0xFFC5E1A5),
                ),

                const SizedBox(height: 24),

                // Supervisor Stats Card
                _buildSupervisorStatsCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    final user = controller.currentUser;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF2E7D32), const Color(0xFF4CAF50)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.supervisor_account,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${'welcome'.tr}, ${user?.displayName ?? 'Supervisor'}!',
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
            '${'layer'.tr}: ${user?.layer} | ${'assigned_area'.tr}: ${user?.assignedCity}',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            '${'supervising_wards'.tr}: ${user?.assignedWard.join(', ')}',
            style: const TextStyle(fontSize: 14, color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      child: ListTile(
        contentPadding: ResponsiveUtils.getResponsivePadding(Get.context!),
        leading: CircleAvatar(
          backgroundColor: color,
          radius: ResponsiveUtils.getIconSize(Get.context!, 30),
          child: Icon(
            icon,
            color: Colors.white,
            size: ResponsiveUtils.getIconSize(Get.context!, 28),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveUtils.getResponsiveFontSize(Get.context!, 16),
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(
            top: ResponsiveUtils.getResponsiveSpacing(Get.context!, 8),
          ),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: ResponsiveUtils.getResponsiveFontSize(Get.context!, 14),
            ),
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.all(
            ResponsiveUtils.getResponsiveSpacing(Get.context!, 8),
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            color: color,
            size: ResponsiveUtils.getIconSize(Get.context!, 16),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSupervisorStatsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, color: Color(0xFF2E7D32), size: 24),
                const SizedBox(width: 12),
                Text(
                  'supervisor_overview'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 2.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildStatCard(
                  label: 'active_cases'.tr,
                  value: '0',
                  color: const Color(0xFF2E7D32),
                  icon: Icons.pets,
                ),
                _buildStatCard(
                  label: 'field_staff'.tr,
                  value: '0',
                  color: const Color(0xFF4CAF50),
                  icon: Icons.people,
                ),
                _buildStatCard(
                  label: 'pending_reviews'.tr,
                  value: '0',
                  color: const Color(0xFF66BB6A),
                  icon: Icons.pending_actions,
                ),
                _buildStatCard(
                  label: 'completed_today'.tr,
                  value: '0',
                  color: const Color(0xFF81C784),
                  icon: Icons.check_circle,
                ),
              ],
            ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFA000).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFA000), width: 1),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.construction,
                    color: Color(0xFFFFA000),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'real_time_stats_coming_soon'.tr,
                      style: const TextStyle(
                        color: Color(0xFFFFA000),
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

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: color.withValues(alpha: 0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
