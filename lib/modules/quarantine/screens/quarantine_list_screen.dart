import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/models/quarantine/quarantine_record_model.dart';
import '../../../shared/utils/responsive_utils.dart';
import '../controllers/quarantine_controller.dart';

class QuarantineListScreen extends StatelessWidget {
  const QuarantineListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuarantineController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('quarantine_management'.tr),
        backgroundColor: const Color(0xFF2E7D32), // Green theme for quarantine
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: controller.refreshData,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: controller.clearAllFilters,
            icon: const Icon(Icons.clear_all),
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
                  decoration: InputDecoration(
                    hintText: 'search_quarantine_records'.tr,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  onChanged: controller.searchQuarantineRecords,
                ),
                const SizedBox(height: 12),

                // Filter chips
                Obx(
                  () => Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      // Observation status filter
                      if (controller.currentObservationStatusFilter != null)
                        FilterChip(
                          label: Text(
                            '${'observation_status'.tr}: ${controller.currentObservationStatusFilter!.name.tr}',
                          ),
                          onSelected: (bool selected) =>
                              controller.filterByObservationStatus(null),
                          onDeleted: () =>
                              controller.filterByObservationStatus(null),
                          backgroundColor: controller
                              .getObservationStatusColor(
                                controller.currentObservationStatusFilter!,
                              )
                              .withValues(alpha: 0.1),
                        ),

                      // Location type filter
                      if (controller.currentLocationTypeFilter != null)
                        FilterChip(
                          label: Text(
                            '${'location_type'.tr}: ${controller.currentLocationTypeFilter!.name.tr}',
                          ),
                          onSelected: (bool selected) =>
                              controller.filterByLocationType(null),
                          onDeleted: () =>
                              controller.filterByLocationType(null),
                          backgroundColor: controller
                              .getLocationTypeColor(
                                controller.currentLocationTypeFilter!,
                              )
                              .withValues(alpha: 0.1),
                        ),

                      // Final outcome filter
                      if (controller.currentFinalOutcomeFilter != null)
                        FilterChip(
                          label: Text(
                            '${'final_outcome'.tr}: ${controller.currentFinalOutcomeFilter!.name.tr}',
                          ),
                          onSelected: (bool selected) =>
                              controller.filterByFinalOutcome(null),
                          onDeleted: () =>
                              controller.filterByFinalOutcome(null),
                          backgroundColor: controller
                              .getFinalOutcomeColor(
                                controller.currentFinalOutcomeFilter!,
                              )
                              .withValues(alpha: 0.1),
                        ),

                      // Active filter
                      if (controller.showOnlyActive)
                        FilterChip(
                          label: Text('active_only'.tr),
                          onSelected: (bool selected) =>
                              controller.toggleActiveFilter(),
                          onDeleted: controller.toggleActiveFilter,
                          backgroundColor: Colors.blue.withValues(alpha: 0.1),
                        ),

                      // Completed filter
                      if (controller.showOnlyCompleted)
                        FilterChip(
                          label: Text('completed_only'.tr),
                          onSelected: (bool selected) =>
                              controller.toggleCompletedFilter(),
                          onDeleted: controller.toggleCompletedFilter,
                          backgroundColor: Colors.green.withValues(alpha: 0.1),
                        ),

                      // Urgent filter
                      if (controller.showOnlyUrgent)
                        FilterChip(
                          label: Text('urgent_only'.tr),
                          onSelected: (bool selected) =>
                              controller.toggleUrgentFilter(),
                          onDeleted: controller.toggleUrgentFilter,
                          backgroundColor: Colors.red.withValues(alpha: 0.1),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Statistics section
          Obx(
            () => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'total'.tr,
                    controller.statistics['total'] ?? 0,
                    Colors.blue,
                  ),
                  _buildStatItem(
                    'active'.tr,
                    controller.statistics['active'] ?? 0,
                    Colors.orange,
                  ),
                  _buildStatItem(
                    'completed'.tr,
                    controller.statistics['completed'] ?? 0,
                    Colors.green,
                  ),
                  _buildStatItem(
                    'urgent'.tr,
                    controller.statistics['urgent'] ?? 0,
                    Colors.red,
                  ),
                ],
              ),
            ),
          ),

          // Records list
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredRecords.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.security, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'no_quarantine_records_found'.tr,
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'try_adjusting_filters'.tr,
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: ResponsiveUtils.getResponsivePadding(context),
                itemCount: controller.filteredRecords.length,
                itemBuilder: (context, index) {
                  final record = controller.filteredRecords[index];
                  return _buildQuarantineRecordCard(
                    record,
                    controller,
                    context,
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.navigateToAddQuarantine,
        backgroundColor: const Color(0xFF2E7D32),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatItem(String label, int value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.security, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 16,
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

  Widget _buildQuarantineRecordCard(
    QuarantineRecordModel record,
    QuarantineController controller,
    BuildContext context,
  ) {
    final daysRemaining = controller.getDaysRemaining(record);
    final progress = controller.getObservationProgress(record);
    final isOverdue = controller.isObservationOverdue(record);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => controller.navigateToQuarantineDetail(record),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with ID and urgent indicator
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${'record_id'.tr}: ${record.id}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (record.needsUrgentAttention)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        'urgent'.tr,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  if (isOverdue)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        'overdue'.tr,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Animal info
              Row(
                children: [
                  Icon(Icons.pets, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${record.animalInfo.species.name} - ${record.animalInfo.color}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  if (record.animalInfo.tagNumber != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      '(${record.animalInfo.tagNumber})',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),

              // Observation period
              Row(
                children: [
                  Icon(Icons.date_range, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${'period'.tr}: ${_formatDate(record.startDate)} - ${_formatDate(record.endDate)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Progress bar for active quarantines
              if (!record.isObservationComplete) ...[
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isOverdue ? Colors.red : const Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      daysRemaining > 0
                          ? '$daysRemaining ${'days_left'.tr}'
                          : 'complete'.tr,
                      style: TextStyle(
                        fontSize: 12,
                        color: isOverdue ? Colors.red : Colors.grey[600],
                        fontWeight: isOverdue
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              // Status chips row
              Row(
                children: [
                  _buildStatusChip(
                    record.observationStatusDisplayName,
                    controller.getObservationStatusColor(
                      record.observationStatus,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildStatusChip(
                    record.quarantineLocation.typeDisplayName,
                    controller.getLocationTypeColor(
                      record.quarantineLocation.type,
                    ),
                  ),
                  if (record.finalOutcome != null) ...[
                    const SizedBox(width: 8),
                    _buildStatusChip(
                      record.finalOutcomeDisplayName!,
                      controller.getFinalOutcomeColor(record.finalOutcome!),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),

              // Location info
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      record.quarantineLocation.address,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Bite case connection
              if (record.biteCaseId != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.link, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${'linked_bite_case'.tr}: ${record.biteCaseId}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],

              // Owner info
              if (record.ownerDetails != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${'owner'.tr}: ${record.ownerDetails!.name ?? 'unknown'.tr}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
