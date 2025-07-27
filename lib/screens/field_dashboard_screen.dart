import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/field_dashboard_controller.dart';

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
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Start Pickup (Sterilization)
                _buildDashboardTile(
                  icon: Icons.pets,
                  title: 'start_pickup_sterilization'.tr,
                  subtitle: 'pickup_sterilization_desc'.tr,
                  onTap: controller.startPickup,
                  color: const Color(0xFF2E7D32),
                ),

                const SizedBox(height: 12),

                // Add Vaccination Entry
                _buildDashboardTile(
                  icon: Icons.medical_services,
                  title: 'add_vaccination_entry'.tr,
                  subtitle: 'vaccination_entry_desc'.tr,
                  onTap: controller.addVaccinationEntry,
                  color: const Color(0xFF4CAF50),
                ),

                const SizedBox(height: 12),

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
          colors: [
            const Color(0xFF2E7D32),
            const Color(0xFF4CAF50),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${'welcome'.tr}, ${user?.displayName ?? 'Field Staff'}!',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${'assigned_area'.tr}: ${user?.assignedCity} - ${user?.assignedWard?.join(', ')}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
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
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF2E7D32),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildQuickStatsCard() {
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
                  Icons.analytics,
                  color: Color(0xFF2E7D32),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'quick_stats'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    label: 'today_pickups'.tr,
                    value: '0',
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    label: 'vaccinations'.tr,
                    value: '0',
                    color: const Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFA000).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFFFA000),
                  width: 1,
                ),
              ),
              child: Text(
                'stats_coming_soon'.tr,
                style: const TextStyle(
                  color: Color(0xFFFFA000),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
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
  }) {
    return Column(
      children: [
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
        ),
      ],
    );
  }
}
