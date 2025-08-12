import 'package:flutter/services.dart';
import 'dart:convert';

import '../../../shared/models/quarantine/quarantine_record_model.dart';
import '../../../core/utils/app_logger.dart';

class QuarantineService {
  static List<QuarantineRecordModel>? _quarantineRecords;

  // Load quarantine records data from JSON
  static Future<void> loadQuarantineData() async {
    if (_quarantineRecords != null) {
      return; // Already loaded
    }

    try {
      AppLogger.i(
        '📁 Loading quarantine records data from dummyData/quarantineRecords.json...',
      );

      final String response = await rootBundle.loadString(
        'dummyData/quarantineRecords.json',
      );
      final List<dynamic> data = json.decode(response);

      _quarantineRecords = data
          .map((json) => QuarantineRecordModel.fromJson(json))
          .toList();

      AppLogger.i(
        '✅ Successfully loaded ${_quarantineRecords!.length} quarantine records',
      );
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error loading quarantine records data: $e', e, stackTrace);
      _quarantineRecords = []; // Set empty list to prevent repeated attempts
    }
  }

  // Get all quarantine records
  static Future<List<QuarantineRecordModel>> getAllQuarantineRecords() async {
    await loadQuarantineData();
    return List.from(_quarantineRecords ?? []);
  }

  // Get active quarantine records (currently in observation period)
  static Future<List<QuarantineRecordModel>>
  getActiveQuarantineRecords() async {
    await loadQuarantineData();
    final now = DateTime.now();
    return _quarantineRecords
            ?.where(
              (record) =>
                  now.isAfter(record.startDate) &&
                  now.isBefore(record.endDate) &&
                  record.finalOutcome == null,
            )
            .toList() ??
        [];
  }

  // Get completed quarantine records
  static Future<List<QuarantineRecordModel>>
  getCompletedQuarantineRecords() async {
    await loadQuarantineData();
    final now = DateTime.now();
    return _quarantineRecords
            ?.where(
              (record) =>
                  now.isAfter(record.endDate) || record.finalOutcome != null,
            )
            .toList() ??
        [];
  }

  // Search quarantine records
  static Future<List<QuarantineRecordModel>> searchQuarantineRecords(
    String query,
  ) async {
    if (query.isEmpty) {
      return getAllQuarantineRecords();
    }

    await loadQuarantineData();
    final searchQuery = query.toLowerCase();

    return _quarantineRecords?.where((record) {
          // Search in ID
          if (record.id.toLowerCase().contains(searchQuery)) {
            return true;
          }

          // Search in bite case ID
          if (record.biteCaseId?.toLowerCase().contains(searchQuery) == true) {
            return true;
          }

          // Search in animal info
          final animalInfo = record.animalInfo;
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

          // Search in quarantine location
          if (record.quarantineLocation.address.toLowerCase().contains(
            searchQuery,
          )) {
            return true;
          }

          // Search in owner details
          final owner = record.ownerDetails;
          if (owner?.name?.toLowerCase().contains(searchQuery) == true) {
            return true;
          }
          if (owner?.contact?.toLowerCase().contains(searchQuery) == true) {
            return true;
          }

          // Search in observation notes
          for (final observation in record.dailyObservations) {
            if (observation.notes?.toLowerCase().contains(searchQuery) ==
                true) {
              return true;
            }
            if (observation.observedBy.toLowerCase().contains(searchQuery)) {
              return true;
            }
          }

          return false;
        }).toList() ??
        [];
  }

  // Filter by observation status
  static Future<List<QuarantineRecordModel>> filterByObservationStatus(
    QuarantineObservationStatus status,
  ) async {
    await loadQuarantineData();
    return _quarantineRecords
            ?.where((record) => record.observationStatus == status)
            .toList() ??
        [];
  }

  // Filter by quarantine location type
  static Future<List<QuarantineRecordModel>> filterByLocationType(
    QuarantineLocationType locationType,
  ) async {
    await loadQuarantineData();
    return _quarantineRecords
            ?.where((record) => record.quarantineLocation.type == locationType)
            .toList() ??
        [];
  }

  // Filter by final outcome
  static Future<List<QuarantineRecordModel>> filterByFinalOutcome(
    QuarantineFinalOutcome outcome,
  ) async {
    await loadQuarantineData();
    return _quarantineRecords
            ?.where((record) => record.finalOutcome == outcome)
            .toList() ??
        [];
  }

  // Get quarantine statistics
  static Future<Map<String, dynamic>> getQuarantineStatistics() async {
    await loadQuarantineData();
    final records = _quarantineRecords ?? [];

    final now = DateTime.now();
    final activeRecords = records.where(
      (r) =>
          now.isAfter(r.startDate) &&
          now.isBefore(r.endDate) &&
          r.finalOutcome == null,
    );

    final completedRecords = records.where(
      (r) => now.isAfter(r.endDate) || r.finalOutcome != null,
    );

    final urgentRecords = records.where((r) => r.needsUrgentAttention);

    return {
      'total': records.length,
      'active': activeRecords.length,
      'completed': completedRecords.length,
      'urgent': urgentRecords.length,
      'successfulReleases': records
          .where((r) => r.finalOutcome == QuarantineFinalOutcome.released)
          .length,
      'deaths': records
          .where(
            (r) =>
                r.finalOutcome == QuarantineFinalOutcome.naturalDeath ||
                r.finalOutcome == QuarantineFinalOutcome.euthanized,
          )
          .length,
      'escaped': records
          .where((r) => r.finalOutcome == QuarantineFinalOutcome.escaped)
          .length,
      'averageObservationDays': records.isNotEmpty
          ? records
                    .map((r) => r.dailyObservations.length)
                    .reduce((a, b) => a + b) /
                records.length
          : 0,
      'withOwnerInfo': records.where((r) => r.ownerDetails != null).length,
      'facilityQuarantine': records
          .where(
            (r) => r.quarantineLocation.type == QuarantineLocationType.facility,
          )
          .length,
      'homeQuarantine': records
          .where(
            (r) => r.quarantineLocation.type == QuarantineLocationType.home,
          )
          .length,
    };
  }

  // Get records requiring attention
  static Future<List<QuarantineRecordModel>>
  getRecordsRequiringAttention() async {
    await loadQuarantineData();
    return _quarantineRecords?.where((record) {
          // Records needing urgent attention
          if (record.needsUrgentAttention) {
            return true;
          }

          // Records missing recent observations
          final now = DateTime.now();
          if (now.isAfter(record.startDate) &&
              now.isBefore(record.endDate) &&
              record.finalOutcome == null) {
            final latestObs = record.latestObservation;
            if (latestObs == null) {
              return true;
            }

            // If latest observation is more than 1 day old
            final daysSinceLastObs = now.difference(latestObs.date).inDays;
            if (daysSinceLastObs > 1) {
              return true;
            }
          }

          // Records nearing end date without final outcome
          final daysToEnd = record.endDate.difference(now).inDays;
          if (daysToEnd <= 2 && daysToEnd >= 0 && record.finalOutcome == null) {
            return true;
          }

          return false;
        }).toList() ??
        [];
  }

  // Add new quarantine record
  static Future<bool> addQuarantineRecord(QuarantineRecordModel record) async {
    try {
      await loadQuarantineData();
      _quarantineRecords ??= [];
      _quarantineRecords!.add(record);

      AppLogger.i('✅ Successfully added quarantine record: ${record.id}');
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error adding quarantine record: $e', e, stackTrace);
      return false;
    }
  }

  // Update quarantine record
  static Future<bool> updateQuarantineRecord(
    QuarantineRecordModel updatedRecord,
  ) async {
    try {
      await loadQuarantineData();
      if (_quarantineRecords == null) return false;

      final index = _quarantineRecords!.indexWhere(
        (r) => r.id == updatedRecord.id,
      );
      if (index != -1) {
        _quarantineRecords![index] = updatedRecord;
        AppLogger.i(
          '✅ Successfully updated quarantine record: ${updatedRecord.id}',
        );
        return true;
      }
      return false;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error updating quarantine record: $e', e, stackTrace);
      return false;
    }
  }

  // Delete quarantine record
  static Future<bool> deleteQuarantineRecord(String recordId) async {
    try {
      await loadQuarantineData();
      if (_quarantineRecords == null) return false;

      final initialLength = _quarantineRecords!.length;
      _quarantineRecords!.removeWhere((r) => r.id == recordId);
      final finalLength = _quarantineRecords!.length;

      if (initialLength > finalLength) {
        AppLogger.i('✅ Successfully deleted quarantine record: $recordId');
        return true;
      }
      return false;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error deleting quarantine record: $e', e, stackTrace);
      return false;
    }
  }

  // Get quarantine record by ID
  static Future<QuarantineRecordModel?> getQuarantineRecordById(
    String id,
  ) async {
    await loadQuarantineData();
    try {
      return _quarantineRecords?.firstWhere((record) => record.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add daily observation to a quarantine record
  static Future<bool> addDailyObservation(
    String recordId,
    DailyObservation observation,
  ) async {
    try {
      await loadQuarantineData();
      if (_quarantineRecords == null) return false;

      final recordIndex = _quarantineRecords!.indexWhere(
        (r) => r.id == recordId,
      );
      if (recordIndex == -1) return false;

      final record = _quarantineRecords![recordIndex];
      final updatedObservations = List<DailyObservation>.from(
        record.dailyObservations,
      )..add(observation);

      final updatedRecord = QuarantineRecordModel(
        id: record.id,
        biteCaseId: record.biteCaseId,
        animalInfo: record.animalInfo,
        startDate: record.startDate,
        endDate: record.endDate,
        observationStatus: observation.status, // Update overall status
        quarantineLocation: record.quarantineLocation,
        dailyObservations: updatedObservations,
        ownerDetails: record.ownerDetails,
        finalOutcome: record.finalOutcome,
        finalOutcomeNotes: record.finalOutcomeNotes,
        finalOutcomeDate: record.finalOutcomeDate,
        notes: record.notes,
        createdAt: record.createdAt,
        createdBy: record.createdBy,
        lastUpdated: DateTime.now(),
      );

      _quarantineRecords![recordIndex] = updatedRecord;
      AppLogger.i(
        '✅ Successfully added daily observation to record: $recordId',
      );
      return true;
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error adding daily observation: $e', e, stackTrace);
      return false;
    }
  }
}
