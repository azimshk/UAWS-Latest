import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/models/models.dart';

class RabiesService {
  static List<RabiesCaseModel>? _rabiesCases;

  // Load rabies cases data from JSON
  static Future<void> loadRabiesData() async {
    if (_rabiesCases != null) {
      return; // Already loaded
    }

    try {
      AppLogger.i(
        '📁 Loading rabies cases data from dummyData/rabiesCases.json...',
      );

      final String jsonString = await rootBundle.loadString(
        'dummyData/rabiesCases.json',
      );
      final List<dynamic> rabiesJson = json.decode(jsonString);

      _rabiesCases = rabiesJson
          .map((json) => RabiesCaseModel.fromJson(json))
          .toList();

      AppLogger.i('✅ Loaded ${_rabiesCases!.length} rabies case records');

      // Debug: Print loaded rabies cases
      AppLogger.d('📋 Available rabies cases:');
      for (var rabiesCase in _rabiesCases!) {
        AppLogger.d(
          '   - ID: ${rabiesCase.id}, Suspicion: ${rabiesCase.suspicionLevel.name}, Status: ${rabiesCase.statusSummary}',
        );
      }
    } catch (e) {
      AppLogger.e('❌ Error loading rabies cases data', e);
      _rabiesCases = [];
    }
  }

  // Get all rabies cases
  static Future<List<RabiesCaseModel>> getAllRabiesCases() async {
    await loadRabiesData();
    return List.from(_rabiesCases ?? []);
  }

  // Get rabies cases by suspicion level
  static Future<List<RabiesCaseModel>> getRabiesCasesBySuspicionLevel(
    RabiesSuspicionLevel suspicionLevel,
  ) async {
    await loadRabiesData();
    return _rabiesCases
            ?.where((rabiesCase) => rabiesCase.suspicionLevel == suspicionLevel)
            .toList() ??
        [];
  }

  // Get rabies cases by outcome status
  static Future<List<RabiesCaseModel>> getRabiesCasesByOutcomeStatus(
    RabiesOutcomeStatus outcomeStatus,
  ) async {
    await loadRabiesData();
    return _rabiesCases
            ?.where((rabiesCase) => rabiesCase.outcome.status == outcomeStatus)
            .toList() ??
        [];
  }

  // Get urgent rabies cases
  static Future<List<RabiesCaseModel>> getUrgentRabiesCases() async {
    await loadRabiesData();
    return _rabiesCases
            ?.where((rabiesCase) => rabiesCase.needsUrgentAttention)
            .toList() ??
        [];
  }

  // Get confirmed positive cases
  static Future<List<RabiesCaseModel>> getConfirmedPositiveCases() async {
    await loadRabiesData();
    return _rabiesCases
            ?.where((rabiesCase) => rabiesCase.isConfirmedPositive)
            .toList() ??
        [];
  }

  // Search rabies cases
  static Future<List<RabiesCaseModel>> searchRabiesCases(String query) async {
    if (query.isEmpty) {
      return getAllRabiesCases();
    }

    await loadRabiesData();
    final searchQuery = query.toLowerCase();

    return _rabiesCases?.where((rabiesCase) {
          // Search in ID
          if (rabiesCase.id.toLowerCase().contains(searchQuery)) {
            return true;
          }

          // Search in animal info
          final animalInfo = rabiesCase.animalInfo;
          if (animalInfo.species.name.toLowerCase().contains(searchQuery)) {
            return true;
          }
          if (animalInfo.tagNumber?.toLowerCase().contains(searchQuery) ==
              true) {
            return true;
          }
          if (animalInfo.color.toLowerCase().contains(searchQuery)) {
            return true;
          }

          // Search in location
          final location = rabiesCase.location;
          if (location.address?.toLowerCase().contains(searchQuery) == true) {
            return true;
          }
          if (location.ward?.toLowerCase().contains(searchQuery) == true) {
            return true;
          }
          if (location.zone?.toLowerCase().contains(searchQuery) == true) {
            return true;
          }

          // Search in clinical signs
          final clinicalSigns = rabiesCase.clinicalSigns;
          if (clinicalSigns.allSigns.any(
            (sign) => sign.toLowerCase().contains(searchQuery),
          )) {
            return true;
          }

          // Search in reported by
          if (rabiesCase.reportedBy?.toLowerCase().contains(searchQuery) ==
              true) {
            return true;
          }

          // Search in verified by
          if (rabiesCase.verifiedBy?.toLowerCase().contains(searchQuery) ==
              true) {
            return true;
          }

          // Search in status summary
          if (rabiesCase.statusSummary.toLowerCase().contains(searchQuery)) {
            return true;
          }

          return false;
        }).toList() ??
        [];
  }

  // Get rabies case by ID
  static Future<RabiesCaseModel?> getRabiesCaseById(String id) async {
    await loadRabiesData();
    try {
      return _rabiesCases?.firstWhere((rabiesCase) => rabiesCase.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get rabies case statistics
  static Future<Map<String, int>> getRabiesCaseStats() async {
    await loadRabiesData();
    final rabiesCases = _rabiesCases ?? [];

    return {
      'total': rabiesCases.length,
      'lowSuspicion': rabiesCases
          .where((c) => c.suspicionLevel == RabiesSuspicionLevel.low)
          .length,
      'mediumSuspicion': rabiesCases
          .where((c) => c.suspicionLevel == RabiesSuspicionLevel.medium)
          .length,
      'highSuspicion': rabiesCases
          .where((c) => c.suspicionLevel == RabiesSuspicionLevel.high)
          .length,
      'underObservation': rabiesCases
          .where(
            (c) => c.outcome.status == RabiesOutcomeStatus.underObservation,
          )
          .length,
      'deceased': rabiesCases
          .where((c) => c.outcome.status == RabiesOutcomeStatus.deceased)
          .length,
      'released': rabiesCases
          .where((c) => c.outcome.status == RabiesOutcomeStatus.released)
          .length,
      'confirmed': rabiesCases.where((c) => c.isConfirmedPositive).length,
      'urgent': rabiesCases.where((c) => c.needsUrgentAttention).length,
      'awaitingLabResults': rabiesCases
          .where(
            (c) =>
                c.labSamples.any((s) => s.result == RabiesTestResult.pending),
          )
          .length,
      'documentsComplete': rabiesCases
          .where((c) => c.isDocumentationComplete)
          .length,
      'thisMonth': rabiesCases
          .where(
            (c) =>
                c.reportDate.month == DateTime.now().month &&
                c.reportDate.year == DateTime.now().year,
          )
          .length,
      'thisWeek': rabiesCases
          .where((c) => DateTime.now().difference(c.reportDate).inDays <= 7)
          .length,
    };
  }

  // Get cases requiring attention
  static Future<List<RabiesCaseModel>> getCasesRequiringAttention() async {
    await loadRabiesData();
    return _rabiesCases?.where((rabiesCase) {
          // High suspicion cases
          if (rabiesCase.suspicionLevel == RabiesSuspicionLevel.high) {
            return true;
          }

          // Cases with concerning clinical signs
          if (rabiesCase.clinicalSigns.hasConcerningSigns) {
            return true;
          }

          // Confirmed positive cases
          if (rabiesCase.isConfirmedPositive) {
            return true;
          }

          // Cases with pending lab results over 7 days
          if (rabiesCase.labSamples.any(
            (sample) =>
                sample.result == RabiesTestResult.pending &&
                DateTime.now().difference(sample.collectionDate).inDays > 7,
          )) {
            return true;
          }

          // Cases under observation over 14 days
          if (rabiesCase.outcome.status ==
                  RabiesOutcomeStatus.underObservation &&
              DateTime.now().difference(rabiesCase.reportDate).inDays > 14) {
            return true;
          }

          return false;
        }).toList() ??
        [];
  }

  // Add new rabies case
  static Future<bool> addRabiesCase(RabiesCaseModel rabiesCase) async {
    try {
      await loadRabiesData();
      _rabiesCases ??= [];

      // Check if ID already exists
      if (_rabiesCases!.any((existing) => existing.id == rabiesCase.id)) {
        AppLogger.w('⚠️ Rabies case with ID ${rabiesCase.id} already exists');
        return false;
      }

      _rabiesCases!.add(rabiesCase);
      AppLogger.i('✅ Added new rabies case: ${rabiesCase.id}');
      return true;
    } catch (e) {
      AppLogger.e('❌ Error adding rabies case', e);
      return false;
    }
  }

  // Update rabies case
  static Future<bool> updateRabiesCase(
    RabiesCaseModel updatedRabiesCase,
  ) async {
    try {
      await loadRabiesData();
      _rabiesCases ??= [];

      final index = _rabiesCases!.indexWhere(
        (rabiesCase) => rabiesCase.id == updatedRabiesCase.id,
      );
      if (index == -1) {
        AppLogger.w('⚠️ Rabies case with ID ${updatedRabiesCase.id} not found');
        return false;
      }

      _rabiesCases![index] = updatedRabiesCase;
      AppLogger.i('✅ Updated rabies case: ${updatedRabiesCase.id}');
      return true;
    } catch (e) {
      AppLogger.e('❌ Error updating rabies case', e);
      return false;
    }
  }

  // Delete rabies case
  static Future<bool> deleteRabiesCase(String id) async {
    try {
      await loadRabiesData();
      _rabiesCases ??= [];

      final index = _rabiesCases!.indexWhere(
        (rabiesCase) => rabiesCase.id == id,
      );
      if (index == -1) {
        AppLogger.w('⚠️ Rabies case with ID $id not found');
        return false;
      }

      _rabiesCases!.removeAt(index);
      AppLogger.i('✅ Deleted rabies case: $id');
      return true;
    } catch (e) {
      AppLogger.e('❌ Error deleting rabies case', e);
      return false;
    }
  }

  // Refresh data (simulate network refresh)
  static Future<void> refreshData() async {
    AppLogger.i('🔄 Refreshing rabies cases data...');
    _rabiesCases = null; // Clear cache
    await loadRabiesData(); // Reload data
  }

  // Get cases by ward
  static Future<List<RabiesCaseModel>> getRabiesCasesByWard(String ward) async {
    await loadRabiesData();
    return _rabiesCases
            ?.where(
              (rabiesCase) =>
                  rabiesCase.location.ward?.toLowerCase() == ward.toLowerCase(),
            )
            .toList() ??
        [];
  }

  // Get cases by date range
  static Future<List<RabiesCaseModel>> getRabiesCasesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    await loadRabiesData();
    return _rabiesCases
            ?.where(
              (rabiesCase) =>
                  rabiesCase.reportDate.isAfter(
                    startDate.subtract(const Duration(days: 1)),
                  ) &&
                  rabiesCase.reportDate.isBefore(
                    endDate.add(const Duration(days: 1)),
                  ),
            )
            .toList() ??
        [];
  }

  // Get lab result statistics
  static Future<Map<String, int>> getLabResultStats() async {
    await loadRabiesData();
    final rabiesCases = _rabiesCases ?? [];
    final allSamples = rabiesCases.expand((c) => c.labSamples).toList();

    return {
      'totalSamples': allSamples.length,
      'positive': allSamples
          .where((s) => s.result == RabiesTestResult.positive)
          .length,
      'negative': allSamples
          .where((s) => s.result == RabiesTestResult.negative)
          .length,
      'pending': allSamples
          .where((s) => s.result == RabiesTestResult.pending)
          .length,
      'inconclusive': allSamples
          .where((s) => s.result == RabiesTestResult.inconclusive)
          .length,
    };
  }
}
