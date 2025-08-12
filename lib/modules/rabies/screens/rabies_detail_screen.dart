import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/rabies_controller.dart';
import '../../../shared/models/models.dart';
import '../../../shared/utils/responsive_utils.dart';

class RabiesCaseDetailScreen extends GetView<RabiesController> {
  const RabiesCaseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String rabiesCaseId = Get.arguments as String;
    final RabiesCaseModel? rabiesCase = controller.getRabiesCaseById(
      rabiesCaseId,
    );

    if (rabiesCase == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('rabies_case_details'.tr),
          backgroundColor: const Color(0xFFD32F2F),
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'rabies_case_not_found'.tr,
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('rabies_case_details'.tr),
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: ResponsiveUtils.getAppBarHeight(context),
        actions: [
          PopupMenuButton<String>(
            onSelected: (action) => _handleAction(context, action, rabiesCase),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(Icons.edit),
                    const SizedBox(width: 8),
                    Text('edit'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'update_status',
                child: Row(
                  children: [
                    const Icon(Icons.update),
                    const SizedBox(width: 8),
                    Text('update_status'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    const Icon(Icons.share),
                    const SizedBox(width: 8),
                    Text('share'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(Icons.delete, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      'delete'.tr,
                      style: const TextStyle(color: Colors.red),
                    ),
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
            // Case header with urgent indicator
            _buildCaseHeader(context, rabiesCase),
            const SizedBox(height: 16),

            // Quick stats cards
            _buildQuickStatsRow(context, rabiesCase),
            const SizedBox(height: 16),

            // Basic information
            _buildBasicInfoCard(context, rabiesCase),
            const SizedBox(height: 16),

            // Animal information
            _buildAnimalInfoCard(context, rabiesCase),
            const SizedBox(height: 16),

            // Location information
            _buildLocationInfoCard(context, rabiesCase),
            const SizedBox(height: 16),

            // Clinical signs
            _buildClinicalSignsCard(context, rabiesCase),
            const SizedBox(height: 16),

            // Lab samples and results
            if (rabiesCase.labSamples.isNotEmpty)
              _buildLabSamplesCard(context, rabiesCase),
            if (rabiesCase.labSamples.isNotEmpty) const SizedBox(height: 16),

            // Outcome information
            _buildOutcomeCard(context, rabiesCase),
            const SizedBox(height: 16),

            // Case management
            _buildCaseManagementCard(context, rabiesCase),
            const SizedBox(height: 16),

            // Photos
            if (rabiesCase.photos.isNotEmpty)
              _buildPhotosCard(context, rabiesCase),

            const SizedBox(height: 100), // Bottom padding for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildCaseHeader(BuildContext context, RabiesCaseModel rabiesCase) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              const Color(0xFFD32F2F),
              const Color(0xFFD32F2F).withValues(alpha: 0.8),
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
                    '${'case_id'.tr}: ${rabiesCase.id}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (rabiesCase.needsUrgentAttention)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.warning,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'urgent'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              rabiesCase.statusSummary,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsRow(BuildContext context, RabiesCaseModel rabiesCase) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickStatCard(
            'suspicion_level'.tr,
            rabiesCase.suspicionLevel.name.tr,
            controller.getSuspicionLevelColor(rabiesCase.suspicionLevel),
            Icons.priority_high,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickStatCard(
            'outcome_status'.tr,
            rabiesCase.outcome.status.name.tr,
            controller.getOutcomeStatusColor(rabiesCase.outcome.status),
            Icons.medical_services,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatCard(
    String title,
    String value,
    Color color,
    IconData icon,
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
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard(BuildContext context, RabiesCaseModel rabiesCase) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.blue[600]),
                const SizedBox(width: 8),
                Text(
                  'basic_information'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('report_date'.tr, _formatDate(rabiesCase.reportDate)),
            _buildInfoRow(
              'reported_by'.tr,
              rabiesCase.reportedBy ?? 'unknown'.tr,
            ),
            if (rabiesCase.verifiedBy != null)
              _buildInfoRow('verified_by'.tr, rabiesCase.verifiedBy!),
            if (rabiesCase.isConfirmedPositive)
              _buildInfoRow(
                'confirmation_status'.tr,
                'confirmed_positive'.tr,
                valueColor: Colors.red,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimalInfoCard(
    BuildContext context,
    RabiesCaseModel rabiesCase,
  ) {
    final animal = rabiesCase.animalInfo;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  animal.species == AnimalSpecies.dog
                      ? Icons.pets
                      : animal.species == AnimalSpecies.cat
                      ? Icons.favorite
                      : Icons.question_mark,
                  color: Colors.green[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'animal_information'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('species'.tr, animal.species.name.tr),
            _buildInfoRow('sex'.tr, animal.sex.name.tr),
            _buildInfoRow('age_category'.tr, animal.age.name.tr),
            _buildInfoRow('color'.tr, animal.color),
            _buildInfoRow('size'.tr, animal.size.name.tr),
            if (animal.tagNumber != null)
              _buildInfoRow('tag_number'.tr, animal.tagNumber!),
            if (animal.breed != null) _buildInfoRow('breed'.tr, animal.breed!),
            if (animal.identificationMarks != null)
              _buildInfoRow(
                'identification_marks'.tr,
                animal.identificationMarks!,
              ),
            if (animal.healthCondition != null)
              _buildInfoRow('health_condition'.tr, animal.healthCondition!),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfoCard(
    BuildContext context,
    RabiesCaseModel rabiesCase,
  ) {
    final location = rabiesCase.location;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.orange[600]),
                const SizedBox(width: 8),
                Text(
                  'location_information'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (location.address != null)
              _buildInfoRow('address'.tr, location.address!),
            if (location.ward != null) _buildInfoRow('ward'.tr, location.ward!),
            if (location.zone != null) _buildInfoRow('zone'.tr, location.zone!),
            _buildInfoRow(
              'coordinates'.tr,
              '${location.lat.toStringAsFixed(6)}, ${location.lng.toStringAsFixed(6)}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClinicalSignsCard(
    BuildContext context,
    RabiesCaseModel rabiesCase,
  ) {
    final signs = rabiesCase.clinicalSigns;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_information, color: Colors.purple[600]),
                const SizedBox(width: 8),
                Text(
                  'clinical_signs'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (signs.hasConcerningSigns)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'concerning'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            if (signs.behavioral.isNotEmpty) ...[
              _buildSignsSection(
                'behavioral_signs'.tr,
                signs.behavioral,
                Colors.blue,
              ),
              const SizedBox(height: 12),
            ],

            if (signs.neurological.isNotEmpty) ...[
              _buildSignsSection(
                'neurological_signs'.tr,
                signs.neurological,
                Colors.red,
              ),
              const SizedBox(height: 12),
            ],

            if (signs.physical.isNotEmpty) ...[
              _buildSignsSection(
                'physical_signs'.tr,
                signs.physical,
                Colors.green,
              ),
              const SizedBox(height: 12),
            ],

            if (signs.onset != null) _buildInfoRow('onset'.tr, signs.onset!),
            if (signs.progression != null)
              _buildInfoRow('progression'.tr, signs.progression!),
          ],
        ),
      ),
    );
  }

  Widget _buildSignsSection(String title, List<String> signs, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: signs
              .map(
                (sign) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    sign,
                    style: TextStyle(
                      fontSize: 12,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildLabSamplesCard(
    BuildContext context,
    RabiesCaseModel rabiesCase,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science, color: Colors.teal[600]),
                const SizedBox(width: 8),
                Text(
                  'laboratory_samples'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...rabiesCase.labSamples.map(
              (sample) => _buildLabSampleItem(sample),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabSampleItem(LabSample sample) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${'sample_type'.tr}: ${sample.sampleType}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: controller
                      .getTestResultColor(sample.result)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: controller
                        .getTestResultColor(sample.result)
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  sample.result.name.tr,
                  style: TextStyle(
                    color: controller.getTestResultColor(sample.result),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow(
            'collection_date'.tr,
            _formatDate(sample.collectionDate),
          ),
          _buildInfoRow('test_method'.tr, sample.testMethod.name.tr),
          _buildInfoRow('laboratory'.tr, sample.labName),
          if (sample.resultDate != null)
            _buildInfoRow('result_date'.tr, _formatDate(sample.resultDate!)),
          if (sample.notes != null) _buildInfoRow('notes'.tr, sample.notes!),
        ],
      ),
    );
  }

  Widget _buildOutcomeCard(BuildContext context, RabiesCaseModel rabiesCase) {
    final outcome = rabiesCase.outcome;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assignment_turned_in, color: Colors.indigo[600]),
                const SizedBox(width: 8),
                Text(
                  'outcome_information'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'status'.tr,
              outcome.status.name.tr,
              valueColor: controller.getOutcomeStatusColor(outcome.status),
            ),
            _buildInfoRow('outcome_date'.tr, _formatDate(outcome.date)),
            if (outcome.cause != null)
              _buildInfoRow('cause'.tr, outcome.cause!),
            if (outcome.postMortemDone)
              _buildInfoRow('post_mortem_done'.tr, 'yes'.tr),
            if (outcome.postMortemDetails != null)
              _buildInfoRow(
                'post_mortem_details'.tr,
                outcome.postMortemDetails!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseManagementCard(
    BuildContext context,
    RabiesCaseModel rabiesCase,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.manage_accounts, color: Colors.brown[600]),
                const SizedBox(width: 8),
                Text(
                  'case_management'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              'documentation_complete'.tr,
              rabiesCase.isDocumentationComplete ? 'yes'.tr : 'no'.tr,
              valueColor: rabiesCase.isDocumentationComplete
                  ? Colors.green
                  : Colors.orange,
            ),
            _buildInfoRow(
              'needs_urgent_attention'.tr,
              rabiesCase.needsUrgentAttention ? 'yes'.tr : 'no'.tr,
              valueColor: rabiesCase.needsUrgentAttention
                  ? Colors.red
                  : Colors.green,
            ),
            if (rabiesCase.notes != null)
              _buildInfoRow('notes'.tr, rabiesCase.notes!),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosCard(BuildContext context, RabiesCaseModel rabiesCase) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.photo_library, color: Colors.cyan[600]),
                const SizedBox(width: 8),
                Text(
                  'photos'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${rabiesCase.photos.length} ${'photos'.tr}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: rabiesCase.photos.length,
              itemBuilder: (context, index) {
                final photo = rabiesCase.photos[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo, size: 32, color: Colors.grey[600]),
                      const SizedBox(height: 4),
                      Text(
                        photo.category ?? 'photo'.tr,
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: valueColor ?? Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _handleAction(
    BuildContext context,
    String action,
    RabiesCaseModel rabiesCase,
  ) {
    switch (action) {
      case 'edit':
        controller.navigateToEditRabiesCase(rabiesCase.id);
        break;
      case 'update_status':
        _showUpdateStatusDialog(context, rabiesCase);
        break;
      case 'share':
        _shareCase(rabiesCase);
        break;
      case 'delete':
        _showDeleteConfirmation(context, rabiesCase);
        break;
    }
  }

  void _showUpdateStatusDialog(
    BuildContext context,
    RabiesCaseModel rabiesCase,
  ) {
    Get.dialog(
      AlertDialog(
        title: Text('update_case_status'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('update_status_message'.tr),
            const SizedBox(height: 16),
            // Add status update form here
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          ElevatedButton(
            onPressed: () {
              // Implement status update
              Get.back();
            },
            child: Text('update'.tr),
          ),
        ],
      ),
    );
  }

  void _shareCase(RabiesCaseModel rabiesCase) {
    // Implement sharing functionality
    Get.snackbar(
      'info'.tr,
      'sharing_feature_coming_soon'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    RabiesCaseModel rabiesCase,
  ) {
    Get.dialog(
      AlertDialog(
        title: Text('confirm_deletion'.tr),
        content: Text('delete_rabies_case_confirmation'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final success = await controller.deleteRabiesCase(rabiesCase.id);
              if (success) {
                Get.back(); // Go back to list screen
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }
}
