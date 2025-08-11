import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_dashboard_controller.dart';
import '../../../shared/utils/responsive_utils.dart';

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
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(
                      Icons.refresh,
                      size: ResponsiveUtils.getIconSize(context, 24),
                    ),
              tooltip: 'refresh_stats'.tr,
            ),
          ),
          IconButton(
            onPressed: controller.logout,
            icon: Icon(
              Icons.logout,
              size: ResponsiveUtils.getIconSize(context, 24),
            ),
            tooltip: 'logout'.tr,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshStats,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: ResponsiveUtils.getResponsivePadding(context),
              child: Column(
                children: [
                  // Admin Header
                  _buildAdminHeader(context),

                  SizedBox(
                    height: ResponsiveUtils.getResponsiveSpacing(context, 20),
                  ),

                  // Admin Stats Overview
                  _buildAdminStats(context),

                  SizedBox(
                    height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                  ),

                  // Main Dashboard Features
                  _buildDashboardFeatures(context),

                  SizedBox(
                    height: ResponsiveUtils.getResponsiveSpacing(context, 24),
                  ),

                  // System Overview Card
                  _buildSystemOverviewCard(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAdminHeader(BuildContext context) {
    final user = controller.currentUser;

    return Container(
      width: double.infinity,
      padding: ResponsiveUtils.getResponsivePadding(context),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: ResponsiveUtils.getIconSize(context, 25),
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: ResponsiveUtils.getIconSize(context, 30),
                ),
              ),
              SizedBox(
                width: ResponsiveUtils.getResponsiveSpacing(context, 16),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'welcome_admin'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          14,
                        ),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      user?.displayName ?? 'Admin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          20,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          Text(
            'total_system_overview'.tr,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdminStats(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingStats(context);
      }

      return ResponsiveUtils.isMobile(context)
          ? _buildMobileStats(context)
          : _buildGridStats(context);
    });
  }

  Widget _buildLoadingStats(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: ResponsiveUtils.getGridColumns(context),
      crossAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16),
      mainAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16),
      childAspectRatio: ResponsiveUtils.isMobile(context) ? 1.5 : 1.2,
      children: List.generate(4, (index) => _buildLoadingCard(context)),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildMobileStats(BuildContext context) {
    return Column(
      children: [
        _buildStatCard(
          context,
          icon: Icons.people,
          title: 'total_users'.tr,
          value: controller.totalUsers.value.toString(),
          color: const Color(0xFF1976D2),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
        _buildStatCard(
          context,
          icon: Icons.location_city,
          title: 'total_cities'.tr,
          value: controller.totalCities.value.toString(),
          color: const Color(0xFF388E3C),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
        _buildStatCard(
          context,
          icon: Icons.report,
          title: 'active_reports'.tr,
          value: controller.activeReports.value.toString(),
          color: const Color(0xFFF57C00),
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
        _buildStatCard(
          context,
          icon: Icons.pending_actions,
          title: 'pending_approvals'.tr,
          value: controller.pendingApprovals.value.toString(),
          color: const Color(0xFF7B1FA2),
        ),
      ],
    );
  }

  Widget _buildGridStats(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: ResponsiveUtils.getGridColumns(context),
      crossAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16),
      mainAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16),
      childAspectRatio: ResponsiveUtils.isTablet(context) ? 1.3 : 1.2,
      children: [
        _buildStatCard(
          context,
          icon: Icons.people,
          title: 'total_users'.tr,
          value: controller.totalUsers.value.toString(),
          color: const Color(0xFF1976D2),
        ),
        _buildStatCard(
          context,
          icon: Icons.location_city,
          title: 'total_cities'.tr,
          value: controller.totalCities.value.toString(),
          color: const Color(0xFF388E3C),
        ),
        _buildStatCard(
          context,
          icon: Icons.report,
          title: 'active_reports'.tr,
          value: controller.activeReports.value.toString(),
          color: const Color(0xFFF57C00),
        ),
        _buildStatCard(
          context,
          icon: Icons.pending_actions,
          title: 'pending_approvals'.tr,
          value: controller.pendingApprovals.value.toString(),
          color: const Color(0xFF7B1FA2),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: ResponsiveUtils.getResponsivePadding(context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: ResponsiveUtils.getIconSize(context, 32),
              color: color,
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
            Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 24),
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 4)),
            Text(
              title,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardFeatures(BuildContext context) {
    return Column(
      children: [
        _buildDashboardTile(
          context,
          icon: Icons.location_city,
          title: 'city_center_dashboard'.tr,
          subtitle: 'view_dashboards_per_city_center'.tr,
          color: const Color(0xFF2E7D32),
          onTap: controller.openCityCenterDashboard,
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
        _buildDashboardTile(
          context,
          icon: Icons.people,
          title: 'user_management'.tr,
          subtitle: 'manage_users_permissions'.tr,
          color: const Color(0xFFF57C00),
          onTap: controller.openUserManagement,
        ),
        SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
        _buildDashboardTile(
          context,
          icon: Icons.track_changes,
          title: 'full_tracker_access'.tr,
          subtitle: 'access_all_tracking_modules'.tr,
          color: const Color(0xFF7B1FA2),
          onTap: controller.openFullTrackerAccess,
        ),
      ],
    );
  }

  Widget _buildDashboardTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: ResponsiveUtils.getResponsivePadding(context),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(
                  ResponsiveUtils.getResponsiveSpacing(context, 12),
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: ResponsiveUtils.getIconSize(context, 24),
                ),
              ),
              SizedBox(
                width: ResponsiveUtils.getResponsiveSpacing(context, 16),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          16,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: ResponsiveUtils.getResponsiveSpacing(context, 4),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          14,
                        ),
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).textTheme.bodySmall?.color,
                size: ResponsiveUtils.getIconSize(context, 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSystemOverviewCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'system_overview'.tr,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
            _buildOverviewItem(
              context,
              icon: Icons.people,
              title: 'total_users'.tr,
              value: controller.totalUsers.value.toString(),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
            _buildOverviewItem(
              context,
              icon: Icons.location_city,
              title: 'total_cities'.tr,
              value: controller.totalCities.value.toString(),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
            _buildOverviewItem(
              context,
              icon: Icons.report,
              title: 'active_reports'.tr,
              value: controller.activeReports.value.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: ResponsiveUtils.getIconSize(context, 20),
          color: const Color(0xFF2E7D32),
        ),
        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2E7D32),
          ),
        ),
      ],
    );
  }
}
