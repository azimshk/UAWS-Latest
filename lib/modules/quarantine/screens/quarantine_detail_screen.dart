import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/models/quarantine/quarantine_record_model.dart';
import '../../../shared/utils/responsive_utils.dart';
import '../controllers/quarantine_controller.dart';

class QuarantineDetailScreen extends StatelessWidget {
  const QuarantineDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuarantineController>();
    final QuarantineRecordModel record = Get.arguments as QuarantineRecordModel;

    return Scaffold(
      appBar: AppBar(
        title: Text('quarantine_detail'.tr),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => controller.navigateToEditQuarantine(record),
            icon: const Icon(Icons.edit),
          ),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'delete') {
                final confirm = await Get.dialog<bool>(
                  AlertDialog(
                    title: Text('confirm_delete'.tr),
                    content: Text('delete_quarantine_record_confirm'.tr),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: Text('cancel'.tr),
                      ),
                      TextButton(
                        onPressed: () => Get.back(result: true),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: Text('delete'.tr),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await controller.deleteQuarantineRecord(record.id);
                  Get.back(); // Return to list
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.red),
                    const SizedBox(width: 8),
                    Text('delete'.tr),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status header
            _buildStatusHeader(record, controller),
            const SizedBox(height: 16),

            // Basic information
            _buildBasicInfoCard(record),
            const SizedBox(height: 16),

            // Animal information
            _buildAnimalInfoCard(record),
            const SizedBox(height: 16),

            // Quarantine location
            _buildLocationCard(record),
            const SizedBox(height: 16),

            // Owner details
            if (record.ownerDetails != null) ...[
              _buildOwnerDetailsCard(record),
              const SizedBox(height: 16),
            ],

            // Observation progress
            _buildObservationProgressCard(record, controller),
            const SizedBox(height: 16),

            // Daily observations
            _buildDailyObservationsCard(record, controller),
            const SizedBox(height: 16),

            // Final outcome
            if (record.finalOutcome != null)
              _buildFinalOutcomeCard(record, controller),
          ],
        ),
      ),
      floatingActionButton: record.isObservationComplete
          ? null
          : FloatingActionButton.extended(
              onPressed: () =>
                  _showAddObservationDialog(context, record, controller),
              backgroundColor: const Color(0xFF2E7D32),
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                'add_observation'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
    );
  }

  Widget _buildStatusHeader(
    QuarantineRecordModel record,
    QuarantineController controller,
  ) {
    final isOverdue = controller.isObservationOverdue(record);
    final daysRemaining = controller.getDaysRemaining(record);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2E7D32),
            const Color(0xFF2E7D32).withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${'record_id'.tr}: ${record.id}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
                    color: Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.4),
                    ),
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
          Text(
            record.observationStatusDisplayName,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          if (!record.isObservationComplete) ...[
            const SizedBox(height: 8),
            Text(
              isOverdue
                  ? 'observation_overdue'.tr
                  : '$daysRemaining ${'days_remaining'.tr}',
              style: TextStyle(
                fontSize: 14,
                color: isOverdue ? Colors.red[100] : Colors.white70,
                fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBasicInfoCard(QuarantineRecordModel record) {
    return _buildInfoCard(
      'basic_information'.tr,
      Icons.info,
      const Color(0xFF2E7D32),
      [
        _buildInfoRow('record_id'.tr, record.id),
        if (record.biteCaseId != null)
          _buildInfoRow('bite_case_id'.tr, record.biteCaseId!),
        _buildInfoRow('start_date'.tr, _formatDate(record.startDate)),
        _buildInfoRow('end_date'.tr, _formatDate(record.endDate)),
        _buildInfoRow('created_by'.tr, record.createdBy),
        _buildInfoRow('created_at'.tr, _formatDateTime(record.createdAt)),
        _buildInfoRow('last_updated'.tr, _formatDateTime(record.lastUpdated)),
        if (record.notes != null && record.notes!.isNotEmpty)
          _buildInfoRow('notes'.tr, record.notes!),
      ],
    );
  }

  Widget _buildAnimalInfoCard(QuarantineRecordModel record) {
    return _buildInfoCard('animal_information'.tr, Icons.pets, Colors.orange, [
      _buildInfoRow('species'.tr, record.animalInfo.species.name),
      _buildInfoRow('sex'.tr, record.animalInfo.sex.name),
      _buildInfoRow('age'.tr, record.animalInfo.age.name),
      _buildInfoRow('color'.tr, record.animalInfo.color),
      _buildInfoRow('size'.tr, record.animalInfo.size.name),
      if (record.animalInfo.tagNumber != null)
        _buildInfoRow('tag_number'.tr, record.animalInfo.tagNumber!),
      if (record.animalInfo.identificationMarks != null)
        _buildInfoRow(
          'identification_marks'.tr,
          record.animalInfo.identificationMarks!,
        ),
    ]);
  }

  Widget _buildLocationCard(QuarantineRecordModel record) {
    return _buildInfoCard(
      'quarantine_location'.tr,
      Icons.location_on,
      Colors.blue,
      [
        _buildInfoRow(
          'location_type'.tr,
          record.quarantineLocation.typeDisplayName,
        ),
        _buildInfoRow('address'.tr, record.quarantineLocation.address),
        if (record.quarantineLocation.gps != null) ...[
          _buildInfoRow(
            'latitude'.tr,
            record.quarantineLocation.gps!.lat.toString(),
          ),
          _buildInfoRow(
            'longitude'.tr,
            record.quarantineLocation.gps!.lng.toString(),
          ),
        ],
      ],
    );
  }

  Widget _buildOwnerDetailsCard(QuarantineRecordModel record) {
    final owner = record.ownerDetails!;
    return _buildInfoCard('owner_details'.tr, Icons.person, Colors.purple, [
      if (owner.name != null) _buildInfoRow('name'.tr, owner.name!),
      if (owner.contact != null) _buildInfoRow('contact'.tr, owner.contact!),
      if (owner.address != null) _buildInfoRow('address'.tr, owner.address!),
      if (owner.cooperationLevel != null)
        _buildInfoRow('cooperation_level'.tr, owner.cooperationLevel!),
    ]);
  }

  Widget _buildObservationProgressCard(
    QuarantineRecordModel record,
    QuarantineController controller,
  ) {
    final progress = controller.getObservationProgress(record);
    final currentDay = record.currentObservationDay;
    final totalDays = record.endDate.difference(record.startDate).inDays;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timeline, color: const Color(0xFF2E7D32)),
                const SizedBox(width: 8),
                Text(
                  'observation_progress'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      record.isObservationComplete
                          ? const Color(0xFF2E7D32)
                          : controller.isObservationOverdue(record)
                          ? Colors.red
                          : const Color(0xFF2E7D32),
                    ),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$currentDay/$totalDays ${'days'.tr}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (record.isObservationComplete)
              Text(
                'observation_complete'.tr,
                style: const TextStyle(
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.bold,
                ),
              )
            else if (controller.isObservationOverdue(record))
              Text(
                'observation_overdue'.tr,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              Text(
                '${controller.getDaysRemaining(record)} ${'days_remaining'.tr}',
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyObservationsCard(
    QuarantineRecordModel record,
    QuarantineController controller,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: const Color(0xFF2E7D32)),
                const SizedBox(width: 8),
                Text(
                  'daily_observations'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${record.dailyObservations.length} ${'observations'.tr}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (record.dailyObservations.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'no_observations_yet'.tr,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: record.dailyObservations.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final observation = record.dailyObservations[index];
                  return _buildObservationItem(observation, controller);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildObservationItem(
    DailyObservation observation,
    QuarantineController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: controller
                      .getObservationStatusColor(observation.status)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: controller
                        .getObservationStatusColor(observation.status)
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  observation.statusDisplayName,
                  style: TextStyle(
                    fontSize: 12,
                    color: controller.getObservationStatusColor(
                      observation.status,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(observation.date),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (observation.temperature != null)
            Row(
              children: [
                Icon(Icons.thermostat, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${'temperature'.tr}: ${observation.temperature}°F',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),

          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.restaurant, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${'appetite'.tr}: ${observation.appetiteDisplayName}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Icon(Icons.psychology, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${'behavior'.tr}: ${observation.behaviorDisplayName}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),

          if (observation.symptoms != null &&
              observation.symptoms!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.medical_services, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${'symptoms'.tr}: ${observation.symptoms}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ],

          if (observation.notes != null && observation.notes!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.note, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${'notes'.tr}: ${observation.notes}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.person, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${'observed_by'.tr}: ${observation.observedBy}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),

          if (observation.photos.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.photo, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${observation.photos.length} ${'photos'.tr}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFinalOutcomeCard(
    QuarantineRecordModel record,
    QuarantineController controller,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flag,
                  color: controller.getFinalOutcomeColor(record.finalOutcome!),
                ),
                const SizedBox(width: 8),
                Text(
                  'final_outcome'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: controller
                    .getFinalOutcomeColor(record.finalOutcome!)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: controller
                      .getFinalOutcomeColor(record.finalOutcome!)
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                record.finalOutcomeDisplayName!,
                style: TextStyle(
                  fontSize: 14,
                  color: controller.getFinalOutcomeColor(record.finalOutcome!),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            if (record.finalOutcomeDate != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.date_range, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${'outcome_date'.tr}: ${_formatDate(record.finalOutcomeDate!)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],

            if (record.finalOutcomeNotes != null &&
                record.finalOutcomeNotes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.note, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${'notes'.tr}: ${record.finalOutcomeNotes}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    IconData icon,
    Color color,
    List<Widget> children,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withValues(alpha: 0.1),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showAddObservationDialog(
    BuildContext context,
    QuarantineRecordModel record,
    QuarantineController controller,
  ) {
    // This would open a dialog or navigate to a screen for adding observations
    // For now, we'll just show a placeholder
    Get.snackbar(
      'Feature Coming Soon',
      'Add observation functionality will be implemented',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
