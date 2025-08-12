import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/field_dashboard_controller.dart';
import '../../../shared/utils/responsive_utils.dart';
import '../../../shared/widgets/premium_ui.dart';

class FieldDashboardScreen extends GetView<FieldDashboardController> {
  const FieldDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('field_dashboard'.tr),
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
            child: SingleChildScrollView(
              padding: context.responsivePadding,
              child: PremiumAnimations.staggeredList(
                children: [
                  // Start Pickup (Sterilization)
                  _buildDashboardTile(
                    icon: Icons.pets,
                    title: 'start_pickup_sterilization'.tr,
                    subtitle: 'pickup_sterilization_desc'.tr,
                    onTap: controller.startPickup,
                    color: const Color(0xFF2E7D32),
                  ),

                  SizedBox(
                    height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                  ),

                  // Add Vaccination Entry
                  _buildDashboardTile(
                    icon: Icons.medical_services,
                    title: 'add_vaccination_entry'.tr,
                    subtitle: 'vaccination_entry_desc'.tr,
                    onTap: controller.addVaccinationEntry,
                    color: const Color(0xFF4CAF50),
                  ),

                  const SizedBox(height: 16),

                  // View My Submissions
                  _buildDashboardTile(
                    icon: Icons.list_alt,
                    title: 'view_my_submissions'.tr,
                    subtitle: 'submissions_desc'.tr,
                    onTap: controller.viewMySubmissions,
                    color: const Color(0xFF66BB6A),
                  ),

                  const SizedBox(height: 24),

                  // Quick Stats Card
                  _buildQuickStatsCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    final user = controller.currentUser;

    return PremiumAnimations.fadeInScale(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF2E7D32),
              const Color(0xFF2E7D32).withValues(alpha: 0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PremiumAnimations.slideIn(
              direction: SlideDirection.left,
              child: Text(
                '${'welcome'.tr}, ${user?.displayName ?? 'Field Staff'}!',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            PremiumAnimations.slideIn(
              direction: SlideDirection.left,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${'assigned_area'.tr}: ${user?.assignedCity} - ${user?.assignedWard.join(', ')}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
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
    required VoidCallback onTap,
    required Color color,
  }) {
    return PremiumAnimations.bounceTouch(
      onTap: onTap,
      child: PremiumCard(
        padding: EdgeInsets.zero,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.1),
                color.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withValues(alpha: 0.8)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.arrow_forward_ios, color: color, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatsCard() {
    return PremiumAnimations.revealCard(
      child: PremiumCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF2E7D32),
                        const Color(0xFF2E7D32).withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.analytics,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'quick_stats'.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    label: 'today_pickups'.tr,
                    value: '0',
                    color: const Color(0xFF2E7D32),
                    icon: Icons.pets,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    label: 'vaccinations'.tr,
                    value: '0',
                    color: const Color(0xFF4CAF50),
                    icon: Icons.medical_services,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFFA000).withValues(alpha: 0.1),
                    const Color(0xFFFFA000).withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFFA000).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFA000).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      color: Color(0xFFFFA000),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'stats_coming_soon'.tr,
                      style: const TextStyle(
                        color: Color(0xFFFFA000),
                        fontWeight: FontWeight.w600,
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

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          if (icon != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
          if (icon != null) const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
