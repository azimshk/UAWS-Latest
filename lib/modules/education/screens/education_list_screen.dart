import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/models/models.dart';
import '../controllers/education_controller.dart';

class EducationListScreen extends StatelessWidget {
  const EducationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EducationController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Education Campaigns',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2E7D32), // Green theme for education
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => controller.refreshData(),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => controller.goToAddCampaign(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with Statistics
          Container(
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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Statistics Row
                  Obx(() => _buildStatisticsRow(controller)),
                  const SizedBox(height: 8),

                  // Search Bar
                  _buildSearchBar(controller),
                  const SizedBox(height: 8),

                  // Filter Chips
                  _buildFilterChips(controller),
                ],
              ),
            ),
          ),

          // Campaign List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF2E7D32),
                    ),
                  ),
                );
              }

              if (controller.hasError.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error Loading Campaigns',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.red[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.errorMessage.value,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => controller.refreshData(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (controller.filteredCampaigns.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.campaign_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.searchQuery.value.isNotEmpty
                            ? 'No campaigns found'
                            : 'No education campaigns yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.searchQuery.value.isNotEmpty
                            ? 'Try adjusting your search or filters'
                            : 'Start by adding your first education campaign',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                      if (controller.searchQuery.value.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => controller.clearFilters(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Clear Filters'),
                        ),
                      ],
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.refreshData(),
                color: const Color(0xFF2E7D32),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.filteredCampaigns.length,
                  itemBuilder: (context, index) {
                    final campaign = controller.filteredCampaigns[index];
                    return _buildCampaignCard(campaign, controller);
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.goToAddCampaign(),
        backgroundColor: const Color(0xFF2E7D32),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatisticsRow(EducationController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Campaigns',
            '${controller.stats['total'] ?? 0}',
            Icons.campaign,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'High Impact',
            '${controller.stats['highImpact'] ?? 0}',
            Icons.trending_up,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'This Month',
            '${controller.stats['thisMonth'] ?? 0}',
            Icons.calendar_today,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Participants',
            '${controller.stats['totalParticipants'] ?? 0}',
            Icons.people,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
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
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(EducationController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: controller.searchCampaigns,
        decoration: InputDecoration(
          hintText: 'Search campaigns, types, locations...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
          suffixIcon: Obx(
            () => controller.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[400], size: 20),
                    onPressed: () => controller.searchCampaigns(''),
                  )
                : const SizedBox(),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(EducationController controller) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Campaign Type Filter
          Obx(
            () => FilterChip(
              label: Text(
                controller.selectedCampaignType.value?.name.toUpperCase() ??
                    'ALL TYPES',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              selected: controller.selectedCampaignType.value != null,
              onSelected: (_) => _showCampaignTypeFilter(controller),
              selectedColor: Colors.white.withValues(alpha: 0.3),
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              labelStyle: const TextStyle(color: Colors.white),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
            ),
          ),
          const SizedBox(width: 8),

          // Recent Filter
          Obx(
            () => FilterChip(
              label: const Text(
                'RECENT',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              selected: controller.showRecentOnly.value,
              onSelected: (_) => controller.toggleRecentFilter(),
              selectedColor: Colors.white.withValues(alpha: 0.3),
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              labelStyle: const TextStyle(color: Colors.white),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
            ),
          ),
          const SizedBox(width: 8),

          // High Impact Filter
          Obx(
            () => FilterChip(
              label: const Text(
                'HIGH IMPACT',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              selected: controller.showHighImpactOnly.value,
              onSelected: (_) => controller.toggleHighImpactFilter(),
              selectedColor: Colors.white.withValues(alpha: 0.3),
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              labelStyle: const TextStyle(color: Colors.white),
              side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
            ),
          ),
          const SizedBox(width: 8),

          // Clear Filters
          Obx(() {
            final hasFilters =
                controller.selectedCampaignType.value != null ||
                controller.selectedWard.value.isNotEmpty ||
                controller.showRecentOnly.value ||
                controller.showHighImpactOnly.value ||
                controller.searchQuery.value.isNotEmpty;

            if (!hasFilters) return const SizedBox();

            return FilterChip(
              label: const Text(
                'CLEAR',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              selected: false,
              onSelected: (_) => controller.clearFilters(),
              backgroundColor: Colors.red.withValues(alpha: 0.2),
              labelStyle: const TextStyle(color: Colors.white),
              side: BorderSide(color: Colors.red.withValues(alpha: 0.5)),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCampaignCard(
    EducationCampaignModel campaign,
    EducationController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => controller.goToCampaignDetail(campaign.id),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    // Campaign Type Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _getCampaignTypeColor(
                          campaign.campaignType,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getCampaignTypeIcon(campaign.campaignType),
                        color: _getCampaignTypeColor(campaign.campaignType),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Campaign Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            campaign.campaignTypeDisplayName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            'ID: ${campaign.id}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Impact Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getImpactColor(campaign.effectivenessScore),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        campaign.impactLevel.replaceAll(' Impact', ''),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Location & Date
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${campaign.location.ward ?? 'Unknown Ward'} • ${campaign.location.address ?? 'No address'}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(campaign.eventDate),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.people, size: 16, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      '${campaign.participantsReached} participants',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),

                if (campaign.description != null &&
                    campaign.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    campaign.description!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],

                const SizedBox(height: 12),

                // Bottom Row
                Row(
                  children: [
                    // Conducted By
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.business,
                            size: 14,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              campaign.conductedBy.ngoName,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Effectiveness Score
                    Row(
                      children: [
                        Icon(
                          Icons.analytics,
                          size: 14,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${campaign.effectivenessScore}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _getImpactColor(campaign.effectivenessScore),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCampaignTypeFilter(EducationController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter by Campaign Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('All Types'),
                  selected: controller.selectedCampaignType.value == null,
                  onSelected: (_) {
                    controller.filterByCampaignType(null);
                    Get.back();
                  },
                ),
                ...CampaignType.values.map(
                  (type) => FilterChip(
                    label: Text(type.name),
                    selected: controller.selectedCampaignType.value == type,
                    onSelected: (_) {
                      controller.filterByCampaignType(type);
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
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

  Color _getCampaignTypeColor(CampaignType type) {
    switch (type) {
      case CampaignType.schoolVisit:
        return Colors.blue;
      case CampaignType.workshop:
        return Colors.green;
      case CampaignType.streetPlay:
        return Colors.orange;
      case CampaignType.hoarding:
        return Colors.purple;
      case CampaignType.onlinePoster:
        return Colors.indigo;
      case CampaignType.radioAd:
        return Colors.teal;
      case CampaignType.others:
        return Colors.grey;
    }
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
