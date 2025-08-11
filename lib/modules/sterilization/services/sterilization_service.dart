import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/models/models.dart';

class SterilizationService {
  static List<SterilizationModel>? _sterilizations;

  // Load sterilization data from JSON
  static Future<void> loadSterilizationData() async {
    if (_sterilizations != null) return; // Already loaded

    try {
      AppLogger.i(
        '📁 Loading sterilization data from dummyData/sterilizations.json...',
      );

      final String jsonString = await rootBundle.loadString(
        'dummyData/sterilizations.json',
      );
      final List<dynamic> sterilizationJson = json.decode(jsonString);

      _sterilizations = sterilizationJson
          .map((json) => SterilizationModel.fromJson(json))
          .toList();

      AppLogger.i('✅ Loaded ${_sterilizations!.length} sterilization records');

      // Debug: Print loaded sterilizations
      AppLogger.d('📋 Available sterilizations:');
      for (var sterilization in _sterilizations!) {
        AppLogger.d(
          '   - ID: ${sterilization.id}, Tag: ${sterilization.animalInfo.tagNumber}, Stage: ${sterilization.currentStage.name}',
        );
      }
    } catch (e) {
      AppLogger.e('❌ Error loading sterilization data', e);
      _sterilizations = [];
    }
  }

  // Get all sterilization records
  static Future<List<SterilizationModel>> getAllSterilizations() async {
    await loadSterilizationData();
    return List.from(_sterilizations ?? []);
  }

  // Get sterilizations by current stage
  static Future<List<SterilizationModel>> getSterilizationsByStage(
    SterilizationStage stage,
  ) async {
    await loadSterilizationData();
    return _sterilizations?.where((s) => s.currentStage == stage).toList() ??
        [];
  }

  // Get sterilizations assigned to a specific staff member
  static Future<List<SterilizationModel>> getSterilizationsByStaffId(
    String staffId,
  ) async {
    await loadSterilizationData();
    return _sterilizations
            ?.where(
              (s) =>
                  s.pickupStage.staffId == staffId ||
                  s.operationStage.veterinarianId == staffId ||
                  s.releaseStage.staffId == staffId,
            )
            .toList() ??
        [];
  }

  // Get sterilization by ID
  static Future<SterilizationModel?> getSterilizationById(String id) async {
    await loadSterilizationData();
    try {
      return _sterilizations?.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get sterilizations by completion status
  static Future<List<SterilizationModel>> getSterilizationsByCompletion(
    bool isCompleted,
  ) async {
    await loadSterilizationData();
    return _sterilizations
            ?.where((s) => s.isFullyCompleted == isCompleted)
            .toList() ??
        [];
  }

  // Get sterilizations needing attention (pending stages)
  static Future<List<SterilizationModel>> getPendingSterilizations() async {
    await loadSterilizationData();
    return _sterilizations?.where((s) => !s.isFullyCompleted).toList() ?? [];
  }

  // Get statistics
  static Future<Map<String, int>> getSterilizationStats() async {
    await loadSterilizationData();

    if (_sterilizations == null || _sterilizations!.isEmpty) {
      return {
        'total': 0,
        'pending_pickup': 0,
        'pending_operation': 0,
        'pending_release': 0,
        'completed': 0,
      };
    }

    final total = _sterilizations!.length;
    final pendingPickup = _sterilizations!
        .where(
          (s) =>
              s.currentStage == SterilizationStage.pickup &&
              !s.isPickupCompleted,
        )
        .length;
    final pendingOperation = _sterilizations!
        .where(
          (s) =>
              s.currentStage == SterilizationStage.operation &&
              !s.isOperationCompleted,
        )
        .length;
    final pendingRelease = _sterilizations!
        .where(
          (s) =>
              s.currentStage == SterilizationStage.release &&
              !s.isReleaseCompleted,
        )
        .length;
    final completed = _sterilizations!.where((s) => s.isFullyCompleted).length;

    return {
      'total': total,
      'pending_pickup': pendingPickup,
      'pending_operation': pendingOperation,
      'pending_release': pendingRelease,
      'completed': completed,
    };
  }

  // Create new sterilization record (for future Firebase implementation)
  static Future<SterilizationModel> createSterilization(
    SterilizationModel sterilization,
  ) async {
    // Simulate creating a new sterilization record
    AppLogger.i('🆕 Creating new sterilization record...');

    // In real implementation, this would save to Firebase
    // For now, just add to local list
    final newSterilization = sterilization.copyWith(
      id: 'sterilization-${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await loadSterilizationData();
    _sterilizations?.add(newSterilization);

    AppLogger.i('✅ Created sterilization record: ${newSterilization.id}');
    return newSterilization;
  }

  // Update existing sterilization record
  static Future<SterilizationModel> updateSterilization(
    SterilizationModel sterilization,
  ) async {
    AppLogger.i('🔄 Updating sterilization record: ${sterilization.id}');

    await loadSterilizationData();

    if (_sterilizations != null) {
      final index = _sterilizations!.indexWhere(
        (s) => s.id == sterilization.id,
      );
      if (index != -1) {
        final updatedSterilization = sterilization.copyWith(
          updatedAt: DateTime.now(),
        );
        _sterilizations![index] = updatedSterilization;

        AppLogger.i('✅ Updated sterilization record: ${sterilization.id}');
        return updatedSterilization;
      }
    }

    throw Exception('Sterilization record not found: ${sterilization.id}');
  }

  // Update specific stage
  static Future<SterilizationModel> updatePickupStage(
    String sterilizationId,
    PickupStage pickupStage,
  ) async {
    final sterilization = await getSterilizationById(sterilizationId);
    if (sterilization == null) {
      throw Exception('Sterilization not found: $sterilizationId');
    }

    final updatedSterilization = sterilization.copyWith(
      pickupStage: pickupStage,
      currentStage: pickupStage.isCompleted
          ? SterilizationStage.operation
          : SterilizationStage.pickup,
      updatedAt: DateTime.now(),
    );

    return updateSterilization(updatedSterilization);
  }

  static Future<SterilizationModel> updateOperationStage(
    String sterilizationId,
    OperationStage operationStage,
  ) async {
    final sterilization = await getSterilizationById(sterilizationId);
    if (sterilization == null) {
      throw Exception('Sterilization not found: $sterilizationId');
    }

    final updatedSterilization = sterilization.copyWith(
      operationStage: operationStage,
      currentStage: operationStage.isCompleted
          ? SterilizationStage.release
          : SterilizationStage.operation,
      updatedAt: DateTime.now(),
    );

    return updateSterilization(updatedSterilization);
  }

  static Future<SterilizationModel> updateReleaseStage(
    String sterilizationId,
    ReleaseStage releaseStage,
  ) async {
    final sterilization = await getSterilizationById(sterilizationId);
    if (sterilization == null) {
      throw Exception('Sterilization not found: $sterilizationId');
    }

    final updatedSterilization = sterilization.copyWith(
      releaseStage: releaseStage,
      updatedAt: DateTime.now(),
    );

    return updateSterilization(updatedSterilization);
  }

  // Delete sterilization record
  static Future<void> deleteSterilization(String id) async {
    AppLogger.i('🗑️ Deleting sterilization record: $id');

    await loadSterilizationData();
    _sterilizations?.removeWhere((s) => s.id == id);

    AppLogger.i('✅ Deleted sterilization record: $id');
  }

  // Clear cache (for testing)
  static void clearCache() {
    _sterilizations = null;
    AppLogger.d('🧹 Cleared sterilization cache');
  }

  // Search sterilizations
  static Future<List<SterilizationModel>> searchSterilizations(
    String query,
  ) async {
    await loadSterilizationData();

    if (query.isEmpty) return _sterilizations ?? [];

    final lowercaseQuery = query.toLowerCase();

    return _sterilizations
            ?.where(
              (s) =>
                  s.animalInfo.tagNumber?.toLowerCase().contains(
                        lowercaseQuery,
                      ) ==
                      true ||
                  s.animalInfo.color.toLowerCase().contains(lowercaseQuery) ||
                  s.animalInfo.species.name.toLowerCase().contains(
                    lowercaseQuery,
                  ) ||
                  s.pickupStage.staffName.toLowerCase().contains(
                    lowercaseQuery,
                  ) ||
                  s.operationStage.veterinarianName?.toLowerCase().contains(
                        lowercaseQuery,
                      ) ==
                      true ||
                  s.id?.toLowerCase().contains(lowercaseQuery) == true,
            )
            .toList() ??
        [];
  }

  // Get sterilizations by date range
  static Future<List<SterilizationModel>> getSterilizationsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    await loadSterilizationData();

    return _sterilizations
            ?.where(
              (s) =>
                  s.createdAt.isAfter(startDate) &&
                  s.createdAt.isBefore(endDate.add(const Duration(days: 1))),
            )
            .toList() ??
        [];
  }
}
