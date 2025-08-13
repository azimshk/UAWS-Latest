import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/sterilization_controller.dart';
import '../../../shared/models/models.dart';
import '../../../shared/utils/responsive_utils.dart';
import '../../../shared/widgets/premium_ui.dart';

class SterilizationListScreen extends GetView<SterilizationController> {
  const SterilizationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('sterilization_tracker'.tr),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: ResponsiveUtils.getAppBarHeight(context),
        actions: [
          IconButton(
            onPressed: controller.refreshSterilizations,
            icon: const Icon(Icons.refresh),
            tooltip: 'refresh'.tr,
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'filter',
                child: Row(
                  children: [
                    const Icon(Icons.filter_list),
                    const SizedBox(width: 8),
                    Text('filter'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'my_assignments',
                child: Row(
                  children: [
                    const Icon(Icons.assignment_ind),
                    const SizedBox(width: 8),
                    Text('my_assignments'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear_filters',
                child: Row(
                  children: [
                    const Icon(Icons.clear),
                    const SizedBox(width: 8),
                    Text('clear_filters'.tr),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Header
          _buildStatsHeader(),

          // Search Bar
          _buildSearchBar(),

          // Stage Filter Chips
          _buildStageFilterChips(),

          // Sterilization List
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(
                  child: PremiumLoading(
                    type: LoadingType.spinner,
                    size: 48,
                    color: Color(0xFF2E7D32),
                  ),
                );
              }

              final sterilizations = controller.filteredSterilizations;

              if (sterilizations.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: controller.refreshSterilizations,
                color: const Color(0xFF2E7D32),
                child: SingleChildScrollView(
                  padding: ResponsiveUtils.getResponsivePadding(context),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ResponsiveUtils.getMaxContentWidth(context),
                    ),
                    child: Center(
                      child: ResponsiveUtils.isDesktop(context)
                          ? _buildDesktopGrid(sterilizations)
                          : ResponsiveUtils.isTablet(context)
                          ? _buildTabletGrid(sterilizations)
                          : _buildMobileList(sterilizations),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: controller.canCreatePickup()
          ? PremiumAnimations.floating(
              child: PremiumButton(
                onPressed: controller.navigateToPickupForm,
                text: 'new_pickup'.tr,
                icon: Icons.add,
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
              ),
            )
          : null,
    );
  }

  Widget _buildStatsHeader() {
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
        child: Obx(() {
          final stats = controller.statistics;
          return Column(
            children: [
              PremiumAnimations.slideIn(
                direction: SlideDirection.top,
                child: Text(
                  'sterilization_overview'.tr,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              PremiumAnimations.staggeredList(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(
                        'total'.tr,
                        stats['total'] ?? 0,
                        Icons.pets,
                      ),
                      _buildStatItem(
                        'pending'.tr,
                        (stats['pending_pickup'] ?? 0) +
                            (stats['pending_operation'] ?? 0) +
                            (stats['pending_release'] ?? 0),
                        Icons.pending,
                      ),
                      _buildStatItem(
                        'completed'.tr,
                        stats['completed'] ?? 0,
                        Icons.check_circle,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStatItem(String label, int value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Builder(
      builder: (context) => Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ResponsiveUtils.getMaxContentWidth(context),
          ),
          child: Center(
            child: PremiumAnimations.slideIn(
              direction: SlideDirection.right,
              child: PremiumSearchField(
                hintText: 'search_sterilizations'.tr,
                onChanged: controller.searchSterilizations,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStageFilterChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Obx(
            () => _buildFilterChip(
              'all'.tr,
              controller.currentStageFilter == null,
              () => controller.filterByStage(null),
            ),
          ),
          const SizedBox(width: 8),
          Obx(
            () => _buildFilterChip(
              'pickup'.tr,
              controller.currentStageFilter == SterilizationStage.pickup,
              () => controller.filterByStage(SterilizationStage.pickup),
            ),
          ),
          const SizedBox(width: 8),
          Obx(
            () => _buildFilterChip(
              'operation'.tr,
              controller.currentStageFilter == SterilizationStage.operation,
              () => controller.filterByStage(SterilizationStage.operation),
            ),
          ),
          const SizedBox(width: 8),
          Obx(
            () => _buildFilterChip(
              'release'.tr,
              controller.currentStageFilter == SterilizationStage.release,
              () => controller.filterByStage(SterilizationStage.release),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: const Color(0xFF2E7D32).withValues(alpha: 0.2),
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[400]!,
      ),
    );
  }

  Widget _buildSterilizationCard(SterilizationModel sterilization) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => controller.navigateToDetails(sterilization.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with tag and stage
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: controller
                          .getStageColor(sterilization.currentStage)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: controller.getStageColor(
                          sterilization.currentStage,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          controller.getStageIcon(sterilization.currentStage),
                          size: 16,
                          color: controller.getStageColor(
                            sterilization.currentStage,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          controller.getStageDisplayName(
                            sterilization.currentStage,
                          ),
                          style: TextStyle(
                            color: controller.getStageColor(
                              sterilization.currentStage,
                            ),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (sterilization.animalInfo.tagNumber != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        sterilization.animalInfo.tagNumber!,
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Animal info
              Row(
                children: [
                  Icon(Icons.pets, color: Colors.grey[600], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${sterilization.animalInfo.species.name.capitalizeFirst} • ${sterilization.animalInfo.sex.name.capitalizeFirst} • ${sterilization.animalInfo.color}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Progress indicator
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: sterilization.completionPercentage,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        controller.getStageColor(sterilization.currentStage),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${(sterilization.completionPercentage * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Status and date
              Row(
                children: [
                  Text(
                    sterilization.statusDescription,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(sterilization.createdAt),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Responsive layout methods
  Widget _buildMobileList(List<SterilizationModel> sterilizations) {
    return Column(
      children: sterilizations
          .map(
            (sterilization) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildSterilizationCard(sterilization),
            ),
          )
          .toList(),
    );
  }

  Widget _buildTabletGrid(List<SterilizationModel> sterilizations) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: sterilizations.length,
      itemBuilder: (context, index) =>
          _buildSterilizationCard(sterilizations[index]),
    );
  }

  Widget _buildDesktopGrid(List<SterilizationModel> sterilizations) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 1.1,
      ),
      itemCount: sterilizations.length,
      itemBuilder: (context, index) =>
          _buildSterilizationCard(sterilizations[index]),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'no_sterilizations_found'.tr,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'try_adjusting_filters'.tr,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          if (controller.canCreatePickup()) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.navigateToPickupForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.add),
              label: Text('create_new_pickup'.tr),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'filter':
        _showFilterDialog();
        break;
      case 'my_assignments':
        controller.toggleMyAssignments();
        break;
      case 'clear_filters':
        controller.clearFilters();
        break;
    }
  }

  void _showFilterDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('filter_options'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => CheckboxListTile(
                title: Text('show_only_my_assignments'.tr),
                value: controller.showOnlyMyAssignments,
                onChanged: (value) => controller.toggleMyAssignments(),
                activeColor: const Color(0xFF2E7D32),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('close'.tr)),
        ],
      ),
    );
  }
}
