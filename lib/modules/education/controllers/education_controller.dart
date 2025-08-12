import 'package:get/get.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/models/models.dart';
import '../services/education_service.dart';

class EducationController extends GetxController {
  // Observable data
  final campaigns = <EducationCampaignModel>[].obs;
  final filteredCampaigns = <EducationCampaignModel>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Search and filter state
  final searchQuery = ''.obs;
  final selectedCampaignType = Rx<CampaignType?>(null);
  final selectedWard = ''.obs;
  final showRecentOnly = false.obs;
  final showHighImpactOnly = false.obs;

  // Statistics
  final stats = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadCampaigns();

    // Set up reactive filtering
    ever(searchQuery, (_) => _applyFilters());
    ever(selectedCampaignType, (_) => _applyFilters());
    ever(selectedWard, (_) => _applyFilters());
    ever(showRecentOnly, (_) => _applyFilters());
    ever(showHighImpactOnly, (_) => _applyFilters());
  }

  // Load all education campaigns
  Future<void> loadCampaigns() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      AppLogger.i('🎓 Loading education campaigns...');

      final campaignData = await EducationService.getAllCampaigns();
      campaigns.assignAll(campaignData);
      _applyFilters();

      // Load statistics
      await loadStatistics();

      AppLogger.i('✅ Loaded ${campaigns.length} education campaigns');
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load education campaigns: $e';
      AppLogger.e('❌ Error loading education campaigns', e);
    } finally {
      isLoading.value = false;
    }
  }

  // Load campaign statistics
  Future<void> loadStatistics() async {
    try {
      final campaignStats = await EducationService.getCampaignStats();
      stats.assignAll(campaignStats);
    } catch (e) {
      AppLogger.e('❌ Error loading education campaign statistics', e);
    }
  }

  // Search campaigns
  void searchCampaigns(String query) {
    searchQuery.value = query.trim();
  }

  // Filter by campaign type
  void filterByCampaignType(CampaignType? type) {
    selectedCampaignType.value = type;
  }

  // Filter by ward
  void filterByWard(String ward) {
    selectedWard.value = ward;
  }

  // Toggle recent campaigns filter
  void toggleRecentFilter() {
    showRecentOnly.value = !showRecentOnly.value;
  }

  // Toggle high impact filter
  void toggleHighImpactFilter() {
    showHighImpactOnly.value = !showHighImpactOnly.value;
  }

  // Clear all filters
  void clearFilters() {
    searchQuery.value = '';
    selectedCampaignType.value = null;
    selectedWard.value = '';
    showRecentOnly.value = false;
    showHighImpactOnly.value = false;
  }

  // Apply filters and search
  void _applyFilters() {
    var filtered = campaigns.toList();

    // Apply search query
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((campaign) {
        return campaign.id.toLowerCase().contains(query) ||
            campaign.campaignTypeDisplayName.toLowerCase().contains(query) ||
            campaign.location.ward?.toLowerCase().contains(query) == true ||
            campaign.location.address?.toLowerCase().contains(query) == true ||
            campaign.conductedBy.ngoName.toLowerCase().contains(query) ||
            campaign.description?.toLowerCase().contains(query) == true ||
            campaign.targetAudience?.toLowerCase().contains(query) == true ||
            campaign.keyTopics?.any(
                  (topic) => topic.toLowerCase().contains(query),
                ) ==
                true;
      }).toList();
    }

    // Filter by campaign type
    if (selectedCampaignType.value != null) {
      filtered = filtered
          .where(
            (campaign) => campaign.campaignType == selectedCampaignType.value,
          )
          .toList();
    }

    // Filter by ward
    if (selectedWard.value.isNotEmpty) {
      filtered = filtered
          .where(
            (campaign) =>
                campaign.location.ward?.toLowerCase() ==
                selectedWard.value.toLowerCase(),
          )
          .toList();
    }

    // Filter recent campaigns
    if (showRecentOnly.value) {
      filtered = filtered.where((campaign) => campaign.isRecent).toList();
    }

    // Filter high impact campaigns
    if (showHighImpactOnly.value) {
      filtered = filtered
          .where((campaign) => campaign.effectivenessScore >= 80)
          .toList();
    }

    // Sort by event date (most recent first)
    filtered.sort((a, b) => b.eventDate.compareTo(a.eventDate));

    filteredCampaigns.assignAll(filtered);
  }

  // Get campaigns by type
  List<EducationCampaignModel> getCampaignsByType(CampaignType type) {
    return campaigns
        .where((campaign) => campaign.campaignType == type)
        .toList();
  }

  // Get high impact campaigns
  List<EducationCampaignModel> getHighImpactCampaigns() {
    return campaigns
        .where((campaign) => campaign.effectivenessScore >= 80)
        .toList();
  }

  // Get recent campaigns
  List<EducationCampaignModel> getRecentCampaigns() {
    return campaigns.where((campaign) => campaign.isRecent).toList();
  }

  // Get campaigns by ward
  List<EducationCampaignModel> getCampaignsByWard(String ward) {
    return campaigns
        .where(
          (campaign) =>
              campaign.location.ward?.toLowerCase() == ward.toLowerCase(),
        )
        .toList();
  }

  // Get unique wards
  List<String> getUniqueWards() {
    final wards = campaigns
        .map((campaign) => campaign.location.ward)
        .where((ward) => ward != null && ward.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
    wards.sort();
    return wards;
  }

  // Get campaign by ID
  EducationCampaignModel? getCampaignById(String id) {
    try {
      return campaigns.firstWhere((campaign) => campaign.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add new campaign
  Future<bool> addCampaign(EducationCampaignModel campaign) async {
    try {
      final success = await EducationService.addCampaign(campaign);
      if (success) {
        campaigns.add(campaign);
        _applyFilters();
        await loadStatistics();
        AppLogger.i('✅ Added new education campaign: ${campaign.id}');
        Get.snackbar(
          'Success',
          'Education campaign added successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return success;
    } catch (e) {
      AppLogger.e('❌ Error adding education campaign', e);
      Get.snackbar(
        'Error',
        'Failed to add education campaign: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  // Update campaign
  Future<bool> updateCampaign(EducationCampaignModel updatedCampaign) async {
    try {
      final success = await EducationService.updateCampaign(updatedCampaign);
      if (success) {
        final index = campaigns.indexWhere((c) => c.id == updatedCampaign.id);
        if (index != -1) {
          campaigns[index] = updatedCampaign;
          _applyFilters();
          await loadStatistics();
          AppLogger.i('✅ Updated education campaign: ${updatedCampaign.id}');
          Get.snackbar(
            'Success',
            'Education campaign updated successfully',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
      return success;
    } catch (e) {
      AppLogger.e('❌ Error updating education campaign', e);
      Get.snackbar(
        'Error',
        'Failed to update education campaign: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  // Delete campaign
  Future<bool> deleteCampaign(String id) async {
    try {
      final success = await EducationService.deleteCampaign(id);
      if (success) {
        campaigns.removeWhere((c) => c.id == id);
        _applyFilters();
        await loadStatistics();
        AppLogger.i('✅ Deleted education campaign: $id');
        Get.snackbar(
          'Success',
          'Education campaign deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return success;
    } catch (e) {
      AppLogger.e('❌ Error deleting education campaign', e);
      Get.snackbar(
        'Error',
        'Failed to delete education campaign: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadCampaigns();
  }

  // Navigation methods
  void goToCampaignDetail(String campaignId) {
    Get.toNamed('/education/detail', arguments: campaignId);
  }

  void goToAddCampaign() {
    Get.toNamed('/education/add');
  }

  void goToEditCampaign(String campaignId) {
    Get.toNamed('/education/edit', arguments: campaignId);
  }

  // Get campaigns requiring attention (low documentation, etc.)
  List<EducationCampaignModel> getCampaignsRequiringAttention() {
    return campaigns.where((campaign) {
      // Campaigns without complete documentation
      if (!campaign.isDocumentationComplete) return true;

      // Campaigns with low effectiveness score
      if (campaign.effectivenessScore < 40) return true;

      // Campaigns without feedback
      if (campaign.feedback == null || campaign.feedback!.isEmpty) return true;

      // Recent campaigns without outcome
      if (campaign.isRecent &&
          (campaign.outcome == null || campaign.outcome!.isEmpty)) {
        return true;
      }

      return false;
    }).toList();
  }

  // Get total participants reached this month
  int getTotalParticipantsThisMonth() {
    final thisMonth = DateTime.now();
    return campaigns
        .where(
          (campaign) =>
              campaign.eventDate.month == thisMonth.month &&
              campaign.eventDate.year == thisMonth.year,
        )
        .fold<int>(0, (sum, campaign) => sum + campaign.participantsReached);
  }

  // Get average effectiveness score
  double getAverageEffectivenessScore() {
    if (campaigns.isEmpty) return 0.0;
    final total = campaigns.fold<int>(
      0,
      (sum, campaign) => sum + campaign.effectivenessScore,
    );
    return total / campaigns.length;
  }

  // Get campaigns by effectiveness level
  Map<String, List<EducationCampaignModel>> getCampaignsByEffectiveness() {
    return {
      'High Impact': campaigns
          .where((c) => c.effectivenessScore >= 80)
          .toList(),
      'Medium Impact': campaigns
          .where((c) => c.effectivenessScore >= 60 && c.effectivenessScore < 80)
          .toList(),
      'Low Impact': campaigns
          .where((c) => c.effectivenessScore >= 40 && c.effectivenessScore < 60)
          .toList(),
      'Minimal Impact': campaigns
          .where((c) => c.effectivenessScore < 40)
          .toList(),
    };
  }

  // Get monthly campaign counts for the year
  Map<String, int> getMonthlyCampaignCounts() {
    final months = <String, int>{};
    final currentYear = DateTime.now().year;

    for (int month = 1; month <= 12; month++) {
      final monthName = _getMonthName(month);
      final count = campaigns
          .where(
            (campaign) =>
                campaign.eventDate.month == month &&
                campaign.eventDate.year == currentYear,
          )
          .length;
      months[monthName] = count;
    }

    return months;
  }

  String _getMonthName(int month) {
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
    return months[month - 1];
  }
}
