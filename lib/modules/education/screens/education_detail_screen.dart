import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/models/models.dart';
import '../controllers/education_controller.dart';

class EducationDetailScreen extends StatelessWidget {
  const EducationDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final campaignId = Get.arguments as String;
    final controller = Get.find<EducationController>();
    final campaign = controller.getCampaignById(campaignId);

    if (campaign == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Campaign Not Found'),
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('Campaign not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Campaign Details',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => controller.goToEditCampaign(campaign.id),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: const Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Campaign'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteConfirmation(context, controller, campaign.id);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            _buildHeaderSection(campaign),

            // Content Sections
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildBasicInfoCard(campaign),
                  const SizedBox(height: 16),
                  _buildLocationCard(campaign),
                  const SizedBox(height: 16),
                  _buildMaterialsCard(campaign),
                  const SizedBox(height: 16),
                  _buildParticipantsCard(campaign),
                  const SizedBox(height: 16),
                  _buildConductedByCard(campaign),
                  const SizedBox(height: 16),
                  if (campaign.description != null &&
                      campaign.description!.isNotEmpty)
                    _buildDescriptionCard(campaign),
                  if (campaign.description != null &&
                      campaign.description!.isNotEmpty)
                    const SizedBox(height: 16),
                  if (campaign.outcome != null && campaign.outcome!.isNotEmpty)
                    _buildOutcomeCard(campaign),
                  if (campaign.outcome != null && campaign.outcome!.isNotEmpty)
                    const SizedBox(height: 16),
                  if (campaign.keyTopics != null &&
                      campaign.keyTopics!.isNotEmpty)
                    _buildKeyTopicsCard(campaign),
                  if (campaign.keyTopics != null &&
                      campaign.keyTopics!.isNotEmpty)
                    const SizedBox(height: 16),
                  if (campaign.feedback != null &&
                      campaign.feedback!.isNotEmpty)
                    _buildFeedbackCard(campaign),
                  if (campaign.feedback != null &&
                      campaign.feedback!.isNotEmpty)
                    const SizedBox(height: 16),
                  if (campaign.budget != null) _buildBudgetCard(campaign),
                  if (campaign.budget != null) const SizedBox(height: 16),
                  _buildPhotosCard(campaign),
                  const SizedBox(height: 16),
                  _buildMetadataCard(campaign),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(EducationCampaignModel campaign) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF2E7D32),
            const Color(0xFF2E7D32).withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Campaign Type Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _getCampaignTypeIcon(campaign.campaignType),
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Campaign Type & ID
            Text(
              campaign.campaignTypeDisplayName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'ID: ${campaign.id}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 16),

            // Impact Level
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _getImpactColor(campaign.effectivenessScore),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${campaign.impactLevel} (${campaign.effectivenessScore}%)',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoCard(EducationCampaignModel campaign) {
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
                Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Basic Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Event Date', _formatDate(campaign.eventDate)),
            _buildInfoRow(
              'Participants Reached',
              '${campaign.participantsReached}',
            ),
            if (campaign.targetAudience != null)
              _buildInfoRow('Target Audience', campaign.targetAudience!),
            if (campaign.rating != null)
              _buildRatingRow('Rating', campaign.rating!),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(EducationCampaignModel campaign) {
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
                Icon(Icons.location_on, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Location Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (campaign.location.ward != null)
              _buildInfoRow('Ward', campaign.location.ward!),
            if (campaign.location.address != null)
              _buildInfoRow('Address', campaign.location.address!),
            if (campaign.location.zone != null)
              _buildInfoRow('Zone', campaign.location.zone!),
            _buildInfoRow(
              'GPS Coordinates',
              '${campaign.location.lat.toStringAsFixed(6)}, ${campaign.location.lng.toStringAsFixed(6)}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialsCard(EducationCampaignModel campaign) {
    final materials = campaign.materialsUsed.usedMaterials;

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
                  Icons.inventory_2_outlined,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Materials Used',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (materials.isEmpty)
              const Text(
                'No materials recorded',
                style: TextStyle(color: Colors.grey),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: materials
                    .map(
                      (material) => Chip(
                        label: Text(
                          material,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: const Color(
                          0xFF2E7D32,
                        ).withValues(alpha: 0.1),
                        side: const BorderSide(color: Color(0xFF2E7D32)),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsCard(EducationCampaignModel campaign) {
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
                Icon(Icons.people, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Participants & Impact',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Participants',
                    '${campaign.participantsReached}',
                    Icons.people,
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Effectiveness',
                    '${campaign.effectivenessScore}%',
                    Icons.analytics,
                    _getImpactColor(campaign.effectivenessScore),
                  ),
                ),
                if (campaign.costPerParticipant != null)
                  Expanded(
                    child: _buildStatItem(
                      'Cost/Person',
                      '₹${campaign.costPerParticipant!.toStringAsFixed(0)}',
                      Icons.currency_rupee,
                      Colors.green,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConductedByCard(EducationCampaignModel campaign) {
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
                Icon(Icons.business, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Conducted By',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('NGO/Organization', campaign.conductedBy.ngoName),
            if (campaign.conductedBy.partnerName != null)
              _buildInfoRow('Partner', campaign.conductedBy.partnerName!),
            if (campaign.conductedBy.staffId != null)
              _buildInfoRow('Staff ID', campaign.conductedBy.staffId!),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard(EducationCampaignModel campaign) {
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
                Icon(Icons.description, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              campaign.description!,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutcomeCard(EducationCampaignModel campaign) {
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
                  Icons.check_circle_outline,
                  color: Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Outcome & Results',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              campaign.outcome!,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyTopicsCard(EducationCampaignModel campaign) {
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
                Icon(Icons.topic, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Key Topics Covered',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: campaign.keyTopics!
                  .map(
                    (topic) => Chip(
                      label: Text(topic, style: const TextStyle(fontSize: 12)),
                      backgroundColor: Colors.blue.withValues(alpha: 0.1),
                      side: const BorderSide(color: Colors.blue),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(EducationCampaignModel campaign) {
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
                Icon(Icons.feedback, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Feedback',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              campaign.feedback!,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetCard(EducationCampaignModel campaign) {
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
                Icon(Icons.currency_rupee, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Budget Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Budget',
                    '₹${campaign.budget!.toStringAsFixed(0)}',
                    Icons.account_balance_wallet,
                    Colors.green,
                  ),
                ),
                if (campaign.costPerParticipant != null)
                  Expanded(
                    child: _buildStatItem(
                      'Per Participant',
                      '₹${campaign.costPerParticipant!.toStringAsFixed(0)}',
                      Icons.person,
                      Colors.blue,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosCard(EducationCampaignModel campaign) {
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
                Icon(Icons.photo_library, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Photo Proofs',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (campaign.photosProofs.isEmpty)
              const Text(
                'No photos available',
                style: TextStyle(color: Colors.grey),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${campaign.photosProofs.length} photo(s) available:',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  ...campaign.photosProofs.map(
                    (photo) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.photo, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              photo,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataCard(EducationCampaignModel campaign) {
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
                Icon(Icons.info, color: Colors.grey[600], size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Record Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Created On', _formatDate(campaign.createdAt)),
            _buildInfoRow('Created By', campaign.createdBy),
            _buildInfoRow('Last Updated', _formatDate(campaign.lastUpdated)),
            _buildInfoRow(
              'Documentation Status',
              campaign.isDocumentationComplete ? 'Complete' : 'Incomplete',
            ),
            if (campaign.notes != null && campaign.notes!.isNotEmpty)
              _buildInfoRow('Notes', campaign.notes!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingRow(String label, int rating) {
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
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('$rating/5'),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    EducationController controller,
    String campaignId,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Campaign'),
          content: const Text(
            'Are you sure you want to delete this education campaign? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final success = await controller.deleteCampaign(campaignId);
                if (success) {
                  Get.back(); // Go back to list screen
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  IconData _getCampaignTypeIcon(CampaignType type) {
    switch (type) {
      case CampaignType.schoolVisit:
        return Icons.school;
      case CampaignType.workshop:
        return Icons.build;
      case CampaignType.streetPlay:
        return Icons.theater_comedy;
      case CampaignType.hoarding:
        return Icons.campaign;
      case CampaignType.onlinePoster:
        return Icons.web;
      case CampaignType.radioAd:
        return Icons.radio;
      case CampaignType.others:
        return Icons.more_horiz;
    }
  }

  Color _getImpactColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    if (score >= 40) return Colors.amber;
    return Colors.red;
  }
}
