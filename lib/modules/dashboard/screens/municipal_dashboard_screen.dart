import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/municipal_dashboard_controller.dart';
import '../../../shared/utils/responsive_utils.dart';

class MunicipalDashboardScreen extends GetView<MunicipalDashboardController> {
  const MunicipalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('municipal_dashboard'.tr),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: ResponsiveUtils.getAppBarHeight(context),
        actions: [
          Obx(
            () => IconButton(
              onPressed: controller.isLoading.value
                  ? null
                  : controller.refreshStats,
              icon: controller.isLoading.value
                  ? SizedBox(
                      width: ResponsiveUtils.getIconSize(context, 20),
                      height: ResponsiveUtils.getIconSize(context, 20),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.refresh),
              tooltip: 'refresh_stats'.tr,
            ),
          ),
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
              // Welcome Header
              _buildWelcomeHeader(),

              // Main Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Statistics Overview Cards
                    _buildStatisticsOverview(),

                    const SizedBox(height: 20),

                    // Action Buttons
                    _buildActionButtons(),

                    const SizedBox(height: 20),

                    // Quick Access Cards
                    _buildQuickAccessCards(),
                  ],
                ),
              ),
            ],
          ),
        ),
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
              const Icon(Icons.account_balance, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${'welcome'.tr}, ${user?.displayName ?? 'Municipal Official'}!',
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
            '${'monitoring_city'.tr}: ${user?.assignedCity}',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'view_only_access'.tr,
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

  Widget _buildStatisticsOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'stats_overview'.tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Sterilization Stats
        _buildStatCard(
          title: 'sterilization_stats'.tr,
          icon: Icons.pets,
          color: const Color(0xFF2E7D32),
          stats: controller.sterilizationStats,
          onTap: controller.viewStatsOverview,
        ),

        const SizedBox(height: 12),

        // Bite Case Stats
        _buildStatCard(
          title: 'bite_case_stats'.tr,
          icon: Icons.healing,
          color: const Color(0xFF4CAF50),
          stats: controller.biteStats,
          onTap: controller.viewStatsOverview,
        ),

        const SizedBox(height: 12),

        // Rabies Stats
        _buildStatCard(
          title: 'rabies_stats'.tr,
          icon: Icons.monitor_heart,
          color: const Color(0xFF66BB6A),
          stats: controller.rabiesStats,
          onTap: controller.viewStatsOverview,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required IconData icon,
    required Color color,
    required RxMap<String, int> stats,
    required VoidCallback onTap,
  }) {
    return Obx(
      () => Card(
        elevation: 4,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: color,
                      radius: 20,
                      child: Icon(icon, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(Icons.visibility, color: Colors.grey, size: 20),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 8,
                  children: stats.entries.map((entry) {
                    return _buildStatItem(
                      label: entry.key.tr,
                      value: entry.value.toString(),
                      color: color,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
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
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.8)),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'quick_actions'.tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Obx(
                () => ElevatedButton.icon(
                  onPressed: controller.isGeneratingReport.value
                      ? null
                      : controller.downloadCityReport,
                  icon: controller.isGeneratingReport.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Icon(Icons.download),
                  label: Text('download_report'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: controller.viewPhotoLogs,
                icon: const Icon(Icons.photo_library),
                label: Text('photo_logs'.tr),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2E7D32),
                  side: const BorderSide(color: Color(0xFF2E7D32)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAccessCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'quick_access'.tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildQuickAccessCard(
              title: 'monthly_report'.tr,
              subtitle: 'current_month_summary'.tr,
              icon: Icons.calendar_month,
              color: const Color(0xFF2E7D32),
              onTap: () => controller.downloadCityReport(),
            ),
            _buildQuickAccessCard(
              title: 'photo_gallery'.tr,
              subtitle: 'field_photos_logs'.tr,
              icon: Icons.photo_camera,
              color: const Color(0xFF4CAF50),
              onTap: controller.viewPhotoLogs,
            ),
            _buildQuickAccessCard(
              title: 'vaccination_data'.tr,
              subtitle: 'vaccination_statistics'.tr,
              icon: Icons.vaccines,
              color: const Color(0xFF66BB6A),
              onTap: controller.viewStatsOverview,
            ),
            _buildQuickAccessCard(
              title: 'ward_overview'.tr,
              subtitle: 'ward_wise_statistics'.tr,
              icon: Icons.location_on,
              color: const Color(0xFF81C784),
              onTap: controller.viewStatsOverview,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAccessCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.2),
                radius: 24,
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
