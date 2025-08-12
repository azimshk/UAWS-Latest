import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/models/models.dart';

class EducationService {
  static List<EducationCampaignModel>? _campaigns;

  // Load education campaigns data from JSON
  static Future<void> loadEducationData() async {
    if (_campaigns != null) {
      return; // Already loaded
    }

    try {
      AppLogger.i(
        '📁 Loading education campaigns data from dummyData/educationCampaigns.json...',
      );

      final String jsonString = await rootBundle.loadString(
        'dummyData/educationCampaigns.json',
      );
      final List<dynamic> campaignsJson = json.decode(jsonString);

      _campaigns = campaignsJson
          .map((json) => EducationCampaignModel.fromJson(json))
          .toList();

      AppLogger.i('✅ Loaded ${_campaigns!.length} education campaign records');

      // Debug: Print loaded campaigns
      AppLogger.d('📋 Available education campaigns:');
      for (var campaign in _campaigns!) {
        AppLogger.d(
          '   - ID: ${campaign.id}, Type: ${campaign.campaignTypeDisplayName}, Participants: ${campaign.participantsReached}',
        );
      }
    } catch (e) {
      AppLogger.e('❌ Error loading education campaigns data', e);
      _campaigns = [];
    }
  }

  // Get all education campaigns
  static Future<List<EducationCampaignModel>> getAllCampaigns() async {
    await loadEducationData();
    return List.from(_campaigns ?? []);
  }

  // Get campaigns by type
  static Future<List<EducationCampaignModel>> getCampaignsByType(
    CampaignType campaignType,
  ) async {
    await loadEducationData();
    return _campaigns
            ?.where((campaign) => campaign.campaignType == campaignType)
            .toList() ??
        [];
  }

  // Get high impact campaigns
  static Future<List<EducationCampaignModel>> getHighImpactCampaigns() async {
    await loadEducationData();
    return _campaigns
            ?.where((campaign) => campaign.effectivenessScore >= 80)
            .toList() ??
        [];
  }

  // Get recent campaigns
  static Future<List<EducationCampaignModel>> getRecentCampaigns() async {
    await loadEducationData();
    return _campaigns?.where((campaign) => campaign.isRecent).toList() ?? [];
  }

  // Search education campaigns
  static Future<List<EducationCampaignModel>> searchCampaigns(
    String query,
  ) async {
    if (query.isEmpty) {
      return getAllCampaigns();
    }

    await loadEducationData();
    final searchQuery = query.toLowerCase();

    return _campaigns?.where((campaign) {
          // Search in ID
          if (campaign.id.toLowerCase().contains(searchQuery)) {
            return true;
          }

          // Search in campaign type
          if (campaign.campaignTypeDisplayName.toLowerCase().contains(
            searchQuery,
          )) {
            return true;
          }

          // Search in location
          final location = campaign.location;
          if (location.address?.toLowerCase().contains(searchQuery) == true) {
            return true;
          }
          if (location.ward?.toLowerCase().contains(searchQuery) == true) {
            return true;
          }
          if (location.zone?.toLowerCase().contains(searchQuery) == true) {
            return true;
          }

          // Search in conducted by
          final conductedBy = campaign.conductedBy;
          if (conductedBy.ngoName.toLowerCase().contains(searchQuery)) {
            return true;
          }
          if (conductedBy.partnerName?.toLowerCase().contains(searchQuery) ==
              true) {
            return true;
          }

          // Search in description
          if (campaign.description?.toLowerCase().contains(searchQuery) ==
              true) {
            return true;
          }

          // Search in target audience
          if (campaign.targetAudience?.toLowerCase().contains(searchQuery) ==
              true) {
            return true;
          }

          // Search in key topics
          if (campaign.keyTopics?.any(
                (topic) => topic.toLowerCase().contains(searchQuery),
              ) ==
              true) {
            return true;
          }

          // Search in outcome
          if (campaign.outcome?.toLowerCase().contains(searchQuery) == true) {
            return true;
          }

          // Search in feedback
          if (campaign.feedback?.toLowerCase().contains(searchQuery) == true) {
            return true;
          }

          // Search in notes
          if (campaign.notes?.toLowerCase().contains(searchQuery) == true) {
            return true;
          }

          return false;
        }).toList() ??
        [];
  }

  // Get campaign by ID
  static Future<EducationCampaignModel?> getCampaignById(String id) async {
    await loadEducationData();
    try {
      return _campaigns?.firstWhere((campaign) => campaign.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get campaign statistics
  static Future<Map<String, int>> getCampaignStats() async {
    await loadEducationData();
    final campaigns = _campaigns ?? [];

    return {
      'total': campaigns.length,
      'schoolVisits': campaigns
          .where((c) => c.campaignType == CampaignType.schoolVisit)
          .length,
      'workshops': campaigns
          .where((c) => c.campaignType == CampaignType.workshop)
          .length,
      'streetPlays': campaigns
          .where((c) => c.campaignType == CampaignType.streetPlay)
          .length,
      'hoardings': campaigns
          .where((c) => c.campaignType == CampaignType.hoarding)
          .length,
      'onlinePosters': campaigns
          .where((c) => c.campaignType == CampaignType.onlinePoster)
          .length,
      'radioAds': campaigns
          .where((c) => c.campaignType == CampaignType.radioAd)
          .length,
      'others': campaigns
          .where((c) => c.campaignType == CampaignType.others)
          .length,
      'highImpact': campaigns.where((c) => c.effectivenessScore >= 80).length,
      'mediumImpact': campaigns
          .where((c) => c.effectivenessScore >= 60 && c.effectivenessScore < 80)
          .length,
      'lowImpact': campaigns
          .where((c) => c.effectivenessScore >= 40 && c.effectivenessScore < 60)
          .length,
      'minimalImpact': campaigns.where((c) => c.effectivenessScore < 40).length,
      'recent': campaigns.where((c) => c.isRecent).length,
      'documentsComplete': campaigns
          .where((c) => c.isDocumentationComplete)
          .length,
      'thisMonth': campaigns
          .where(
            (c) =>
                c.eventDate.month == DateTime.now().month &&
                c.eventDate.year == DateTime.now().year,
          )
          .length,
      'thisWeek': campaigns
          .where((c) => DateTime.now().difference(c.eventDate).inDays <= 7)
          .length,
      'totalParticipants': campaigns.fold<int>(
        0,
        (sum, c) => sum + c.participantsReached,
      ),
      'averageParticipants': campaigns.isNotEmpty
          ? (campaigns.fold<int>(0, (sum, c) => sum + c.participantsReached) /
                    campaigns.length)
                .round()
          : 0,
      'withFeedback': campaigns
          .where((c) => c.feedback != null && c.feedback!.isNotEmpty)
          .length,
      'withRating': campaigns.where((c) => c.rating != null).length,
    };
  }

  // Get campaigns requiring attention
  static Future<List<EducationCampaignModel>>
  getCampaignsRequiringAttention() async {
    await loadEducationData();
    return _campaigns?.where((campaign) {
          // Campaigns without complete documentation
          if (!campaign.isDocumentationComplete) {
            return true;
          }

          // Campaigns with low effectiveness score
          if (campaign.effectivenessScore < 40) {
            return true;
          }

          // Campaigns without feedback
          if (campaign.feedback == null || campaign.feedback!.isEmpty) {
            return true;
          }

          // Recent campaigns without outcome
          if (campaign.isRecent &&
              (campaign.outcome == null || campaign.outcome!.isEmpty)) {
            return true;
          }

          // Campaigns without rating
          if (campaign.rating == null) {
            return true;
          }

          return false;
        }).toList() ??
        [];
  }

  // Add new campaign
  static Future<bool> addCampaign(EducationCampaignModel campaign) async {
    try {
      await loadEducationData();
      _campaigns ??= [];

      // Check if ID already exists
      if (_campaigns!.any((existing) => existing.id == campaign.id)) {
        AppLogger.w(
          '⚠️ Education campaign with ID ${campaign.id} already exists',
        );
        return false;
      }

      _campaigns!.add(campaign);
      AppLogger.i('✅ Added new education campaign: ${campaign.id}');
      return true;
    } catch (e) {
      AppLogger.e('❌ Error adding education campaign', e);
      return false;
    }
  }

  // Update campaign
  static Future<bool> updateCampaign(
    EducationCampaignModel updatedCampaign,
  ) async {
    try {
      await loadEducationData();
      _campaigns ??= [];

      final index = _campaigns!.indexWhere(
        (campaign) => campaign.id == updatedCampaign.id,
      );
      if (index == -1) {
        AppLogger.w(
          '⚠️ Education campaign with ID ${updatedCampaign.id} not found',
        );
        return false;
      }

      _campaigns![index] = updatedCampaign;
      AppLogger.i('✅ Updated education campaign: ${updatedCampaign.id}');
      return true;
    } catch (e) {
      AppLogger.e('❌ Error updating education campaign', e);
      return false;
    }
  }

  // Delete campaign
  static Future<bool> deleteCampaign(String id) async {
    try {
      await loadEducationData();
      _campaigns ??= [];

      final index = _campaigns!.indexWhere((campaign) => campaign.id == id);
      if (index == -1) {
        AppLogger.w('⚠️ Education campaign with ID $id not found');
        return false;
      }

      _campaigns!.removeAt(index);
      AppLogger.i('✅ Deleted education campaign: $id');
      return true;
    } catch (e) {
      AppLogger.e('❌ Error deleting education campaign', e);
      return false;
    }
  }

  // Refresh data (simulate network refresh)
  static Future<void> refreshData() async {
    AppLogger.i('🔄 Refreshing education campaigns data...');
    _campaigns = null; // Clear cache
    await loadEducationData(); // Reload data
  }

  // Get campaigns by ward
  static Future<List<EducationCampaignModel>> getCampaignsByWard(
    String ward,
  ) async {
    await loadEducationData();
    return _campaigns
            ?.where(
              (campaign) =>
                  campaign.location.ward?.toLowerCase() == ward.toLowerCase(),
            )
            .toList() ??
        [];
  }

  // Get campaigns by date range
  static Future<List<EducationCampaignModel>> getCampaignsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    await loadEducationData();
    return _campaigns
            ?.where(
              (campaign) =>
                  campaign.eventDate.isAfter(
                    startDate.subtract(const Duration(days: 1)),
                  ) &&
                  campaign.eventDate.isBefore(
                    endDate.add(const Duration(days: 1)),
                  ),
            )
            .toList() ??
        [];
  }

  // Get effectiveness statistics
  static Future<Map<String, double>> getEffectivenessStats() async {
    await loadEducationData();
    final campaigns = _campaigns ?? [];

    if (campaigns.isEmpty) {
      return {
        'averageScore': 0.0,
        'averageParticipants': 0.0,
        'averageCostPerParticipant': 0.0,
      };
    }

    final totalScore = campaigns.fold<int>(
      0,
      (sum, c) => sum + c.effectivenessScore,
    );
    final totalParticipants = campaigns.fold<int>(
      0,
      (sum, c) => sum + c.participantsReached,
    );

    final campaignsWithBudget = campaigns
        .where((c) => c.budget != null)
        .toList();
    final totalCost = campaignsWithBudget.fold<double>(
      0.0,
      (sum, c) => sum + c.budget!,
    );
    final totalParticipantsWithBudget = campaignsWithBudget.fold<int>(
      0,
      (sum, c) => sum + c.participantsReached,
    );

    return {
      'averageScore': totalScore / campaigns.length,
      'averageParticipants': totalParticipants / campaigns.length,
      'averageCostPerParticipant': totalParticipantsWithBudget > 0
          ? totalCost / totalParticipantsWithBudget
          : 0.0,
    };
  }

  // Get campaigns by effectiveness level
  static Future<Map<String, List<EducationCampaignModel>>>
  getCampaignsByEffectiveness() async {
    await loadEducationData();
    final campaigns = _campaigns ?? [];

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

  // Get monthly statistics for the current year
  static Future<Map<String, Map<String, int>>> getMonthlyStats() async {
    await loadEducationData();
    final campaigns = _campaigns ?? [];
    final currentYear = DateTime.now().year;

    final monthlyStats = <String, Map<String, int>>{};

    for (int month = 1; month <= 12; month++) {
      final monthCampaigns = campaigns
          .where(
            (c) =>
                c.eventDate.month == month && c.eventDate.year == currentYear,
          )
          .toList();

      final monthName = _getMonthName(month);
      monthlyStats[monthName] = {
        'campaigns': monthCampaigns.length,
        'participants': monthCampaigns.fold<int>(
          0,
          (sum, c) => sum + c.participantsReached,
        ),
        'highImpact': monthCampaigns
            .where((c) => c.effectivenessScore >= 80)
            .length,
      };
    }

    return monthlyStats;
  }

  static String _getMonthName(int month) {
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

  // Get unique wards
  static Future<List<String>> getUniqueWards() async {
    await loadEducationData();
    final wards =
        _campaigns
            ?.map((campaign) => campaign.location.ward)
            .where((ward) => ward != null && ward.isNotEmpty)
            .cast<String>()
            .toSet()
            .toList() ??
        [];
    wards.sort();
    return wards;
  }

  // Get campaigns with budget information
  static Future<List<EducationCampaignModel>> getCampaignsWithBudget() async {
    await loadEducationData();
    return _campaigns?.where((campaign) => campaign.budget != null).toList() ??
        [];
  }

  // Get total budget spent
  static Future<double> getTotalBudgetSpent() async {
    await loadEducationData();
    return _campaigns
            ?.where((campaign) => campaign.budget != null)
            .fold<double>(0.0, (sum, campaign) => sum + campaign.budget!) ??
        0.0;
  }

  // Get campaigns by rating
  static Future<Map<int, List<EducationCampaignModel>>>
  getCampaignsByRating() async {
    await loadEducationData();
    final campaigns = _campaigns ?? [];

    final ratingGroups = <int, List<EducationCampaignModel>>{};
    for (int rating = 1; rating <= 5; rating++) {
      ratingGroups[rating] = campaigns
          .where((c) => c.rating == rating)
          .toList();
    }

    return ratingGroups;
  }

  // Get top performing campaigns
  static Future<List<EducationCampaignModel>> getTopPerformingCampaigns({
    int limit = 10,
  }) async {
    await loadEducationData();
    final campaigns = List<EducationCampaignModel>.from(_campaigns ?? []);

    // Sort by effectiveness score descending
    campaigns.sort(
      (a, b) => b.effectivenessScore.compareTo(a.effectivenessScore),
    );

    return campaigns.take(limit).toList();
  }
}
