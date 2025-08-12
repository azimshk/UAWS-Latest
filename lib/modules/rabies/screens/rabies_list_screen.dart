import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/rabies_controller.dart';
import '../../../shared/models/models.dart';
import '../../../shared/utils/responsive_utils.dart';

class RabiesListScreen extends GetView<RabiesController> {
  const RabiesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('rabies_surveillance'.tr),
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: ResponsiveUtils.getAppBarHeight(context),
        actions: [
          IconButton(
            onPressed: controller.refreshRabiesCases,
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
                value: 'urgent_only',
                child: Row(
                  children: [
                    const Icon(Icons.warning),
                    const SizedBox(width: 8),
                    Text('urgent_cases_only'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'confirmed_only',
                child: Row(
                  children: [
                    const Icon(Icons.verified),
                    const SizedBox(width: 8),
                    Text('confirmed_cases_only'.tr),
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
              PopupMenuItem(
                value: 'statistics',
                child: Row(
                  children: [
                    const Icon(Icons.analytics),
                    const SizedBox(width: 8),
                    Text('statistics'.tr),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and filters section
          Container(
            padding: ResponsiveUtils.getResponsivePadding(context),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search bar
                TextField(
                  onChanged: controller.search,
                  decoration: InputDecoration(
                    hintText: 'search_rabies_cases'.tr,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: Obx(
                      () => controller.searchQuery.isNotEmpty
                          ? IconButton(
                              onPressed: controller.clearSearch,
                              icon: const Icon(Icons.clear),
                            )
                          : const SizedBox.shrink(),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Filter chips
                Obx(
                  () => Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      // Suspicion level filter
                      if (controller.currentSuspicionFilter != null)
                        FilterChip(
                          label: Text(
                            '${'suspicion_level'.tr}: ${controller.currentSuspicionFilter!.name.tr}',
                          ),
                          onSelected: (bool selected) =>
                              controller.filterBySuspicionLevel(null),
                          onDeleted: () =>
                              controller.filterBySuspicionLevel(null),
                          backgroundColor: controller
                              .getSuspicionLevelColor(
                                controller.currentSuspicionFilter!,
                              )
                              .withValues(alpha: 0.1),
                        ),

                      // Outcome status filter
                      if (controller.currentOutcomeFilter != null)
                        FilterChip(
                          label: Text(
                            '${'outcome_status'.tr}: ${controller.currentOutcomeFilter!.name.tr}',
                          ),
                          onSelected: (bool selected) =>
                              controller.filterByOutcomeStatus(null),
                          onDeleted: () =>
                              controller.filterByOutcomeStatus(null),
                          backgroundColor: controller
                              .getOutcomeStatusColor(
                                controller.currentOutcomeFilter!,
                              )
                              .withValues(alpha: 0.1),
                        ),

                      // Urgent filter
                      if (controller.showOnlyUrgent)
                        FilterChip(
                          label: Text('urgent_cases_only'.tr),
                          onSelected: (bool selected) =>
                              controller.toggleUrgentFilter(),
                          onDeleted: controller.toggleUrgentFilter,
                          backgroundColor: Colors.red.withValues(alpha: 0.1),
                        ),

                      // Confirmed filter
                      if (controller.showOnlyConfirmed)
                        FilterChip(
                          label: Text('confirmed_cases_only'.tr),
                          onSelected: (bool selected) =>
                              controller.toggleConfirmedFilter(),
                          onDeleted: controller.toggleConfirmedFilter,
                          backgroundColor: Colors.orange.withValues(alpha: 0.1),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Statistics bar
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'total'.tr,
                    controller.statistics['total'] ?? 0,
                    Colors.blue,
                  ),
                  _buildStatItem(
                    'urgent'.tr,
                    controller.statistics['urgent'] ?? 0,
                    Colors.red,
                  ),
                  _buildStatItem(
                    'confirmed'.tr,
                    controller.statistics['confirmed'] ?? 0,
                    Colors.orange,
                  ),
                  _buildStatItem(
                    'pending_lab'.tr,
                    controller.statistics['pending'] ?? 0,
                    Colors.purple,
                  ),
                ],
              ),
            ),
          ),

          // Cases list
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredRabiesCases.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: controller.refreshRabiesCases,
                child: ListView.builder(
                  padding: ResponsiveUtils.getResponsivePadding(context),
                  itemCount: controller.filteredRabiesCases.length,
                  itemBuilder: (context, index) {
                    final rabiesCase = controller.filteredRabiesCases[index];
                    return _buildRabiesCaseCard(context, rabiesCase);
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.navigateToAddRabiesCase,
        backgroundColor: const Color(0xFFD32F2F),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatItem(String label, int value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.8)),
        ),
      ],
    );
  }

  Widget _buildRabiesCaseCard(
    BuildContext context,
    RabiesCaseModel rabiesCase,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => controller.navigateToRabiesCaseDetail(rabiesCase.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with ID and urgency indicator
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${'case_id'.tr}: ${rabiesCase.id}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (rabiesCase.needsUrgentAttention)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'urgent'.tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // Animal info
              Row(
                children: [
                  Icon(
                    rabiesCase.animalInfo.species == AnimalSpecies.dog
                        ? Icons.pets
                        : rabiesCase.animalInfo.species == AnimalSpecies.cat
                        ? Icons.favorite
                        : Icons.question_mark,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${rabiesCase.animalInfo.species.name.tr} • ${rabiesCase.animalInfo.sex.name.tr} • ${rabiesCase.animalInfo.age.name.tr}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Location
              Row(
                children: [
                  Icon(Icons.location_on, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      rabiesCase.location.address ?? 'no_address'.tr,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Status chips row
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  // Suspicion level chip
                  _buildStatusChip(
                    rabiesCase.suspicionLevel.name.tr,
                    controller.getSuspicionLevelColor(
                      rabiesCase.suspicionLevel,
                    ),
                  ),

                  // Outcome status chip
                  _buildStatusChip(
                    rabiesCase.outcome.status.name.tr,
                    controller.getOutcomeStatusColor(rabiesCase.outcome.status),
                  ),

                  // Confirmed positive indicator
                  if (rabiesCase.isConfirmedPositive)
                    _buildStatusChip('confirmed_positive'.tr, Colors.red),
                ],
              ),

              const SizedBox(height: 8),

              // Report date and reported by
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${'reported'.tr}: ${_formatDate(rabiesCase.reportDate)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  if (rabiesCase.reportedBy != null)
                    Text(
                      '${'by'.tr}: ${rabiesCase.reportedBy}',
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

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.biotech, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'no_rabies_cases_found'.tr,
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
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.clearFilters,
            icon: const Icon(Icons.clear),
            label: Text('clear_all_filters'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              foregroundColor: Colors.white,
            ),
          ),
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
      case 'urgent_only':
        controller.toggleUrgentFilter();
        break;
      case 'confirmed_only':
        controller.toggleConfirmedFilter();
        break;
      case 'clear_filters':
        controller.clearFilters();
        break;
      case 'statistics':
        _showStatisticsDialog();
        break;
    }
  }

  void _showFilterDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('filter_rabies_cases'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Suspicion level filter
            ListTile(
              title: Text('suspicion_level'.tr),
              subtitle: Obx(
                () => DropdownButton<RabiesSuspicionLevel?>(
                  value: controller.currentSuspicionFilter,
                  isExpanded: true,
                  onChanged: controller.filterBySuspicionLevel,
                  items: [
                    DropdownMenuItem<RabiesSuspicionLevel?>(
                      value: null,
                      child: Text('all'.tr),
                    ),
                    ...RabiesSuspicionLevel.values.map(
                      (level) => DropdownMenuItem<RabiesSuspicionLevel?>(
                        value: level,
                        child: Text(level.name.tr),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Outcome status filter
            ListTile(
              title: Text('outcome_status'.tr),
              subtitle: Obx(
                () => DropdownButton<RabiesOutcomeStatus?>(
                  value: controller.currentOutcomeFilter,
                  isExpanded: true,
                  onChanged: controller.filterByOutcomeStatus,
                  items: [
                    DropdownMenuItem<RabiesOutcomeStatus?>(
                      value: null,
                      child: Text('all'.tr),
                    ),
                    ...RabiesOutcomeStatus.values.map(
                      (status) => DropdownMenuItem<RabiesOutcomeStatus?>(
                        value: status,
                        child: Text(status.name.tr),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('close'.tr)),
          TextButton(
            onPressed: () {
              controller.clearFilters();
              Get.back();
            },
            child: Text('clear_all'.tr),
          ),
        ],
      ),
    );
  }

  void _showStatisticsDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('rabies_cases_statistics'.tr),
        content: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatRow(
                'total_cases'.tr,
                controller.statistics['total'] ?? 0,
              ),
              _buildStatRow(
                'high_suspicion'.tr,
                controller.statistics['highSuspicion'] ?? 0,
              ),
              _buildStatRow(
                'medium_suspicion'.tr,
                controller.statistics['mediumSuspicion'] ?? 0,
              ),
              _buildStatRow(
                'low_suspicion'.tr,
                controller.statistics['lowSuspicion'] ?? 0,
              ),
              const Divider(),
              _buildStatRow(
                'under_observation'.tr,
                controller.statistics['underObservation'] ?? 0,
              ),
              _buildStatRow(
                'deceased'.tr,
                controller.statistics['deceased'] ?? 0,
              ),
              _buildStatRow(
                'released'.tr,
                controller.statistics['released'] ?? 0,
              ),
              const Divider(),
              _buildStatRow(
                'confirmed_positive'.tr,
                controller.statistics['confirmed'] ?? 0,
              ),
              _buildStatRow(
                'pending_lab_results'.tr,
                controller.statistics['pending'] ?? 0,
              ),
              _buildStatRow(
                'urgent_attention'.tr,
                controller.statistics['urgent'] ?? 0,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('close'.tr)),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
