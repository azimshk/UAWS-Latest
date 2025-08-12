import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/models/models.dart';

class BiteCaseService {
  static List<BiteCaseModel>? _biteCases;
  static DateTime? _lastLoaded;
  static const int _cacheValidityMinutes = 10;

  // Load bite cases from dummy data
  static Future<void> loadBiteCaseData() async {
    if (_biteCases != null && _isDataValid()) {
      AppLogger.d('📦 Using cached bite case data');
      return;
    }

    try {
      AppLogger.d('📥 Loading bite case data from assets...');
      final String jsonString = await rootBundle.loadString(
        'dummyData/biteCases.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);

      _biteCases = jsonData.map((json) => BiteCaseModel.fromJson(json)).toList()
        ..sort((a, b) => b.incidentDate.compareTo(a.incidentDate));

      _lastLoaded = DateTime.now();
      AppLogger.i('✅ Loaded ${_biteCases!.length} bite cases');
    } catch (e) {
      AppLogger.e('❌ Error loading bite case data', e);
      _biteCases = [];
    }
  }

  static bool _isDataValid() {
    if (_lastLoaded == null) return false;
    return DateTime.now().difference(_lastLoaded!).inMinutes <
        _cacheValidityMinutes;
  }

  // Clear cache
  static void clearCache() {
    _biteCases = null;
    _lastLoaded = null;
    AppLogger.d('🧹 Cleared bite case cache');
  }

  // Get all bite cases
  static Future<List<BiteCaseModel>> getAllBiteCases() async {
    await loadBiteCaseData();
    return List.from(_biteCases ?? []);
  }

  // Get bite case by ID
  static Future<BiteCaseModel?> getBiteCaseById(String id) async {
    await loadBiteCaseData();
    try {
      return _biteCases?.firstWhere((biteCase) => biteCase.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get bite cases by status
  static Future<List<BiteCaseModel>> getBiteCasesByStatus(
    BiteCaseStatus status,
  ) async {
    await loadBiteCaseData();
    return _biteCases
            ?.where((biteCase) => biteCase.status == status)
            .toList() ??
        [];
  }

  // Get bite cases by priority
  static Future<List<BiteCaseModel>> getBiteCasesByPriority(
    BiteCasePriority priority,
  ) async {
    await loadBiteCaseData();
    return _biteCases
            ?.where((biteCase) => biteCase.priority == priority)
            .toList() ??
        [];
  }

  // Get bite cases by ward
  static Future<List<BiteCaseModel>> getBiteCasesByWard(String ward) async {
    await loadBiteCaseData();
    return _biteCases
            ?.where((biteCase) => biteCase.location.ward == ward)
            .toList() ??
        [];
  }

  // Get bite cases by date range
  static Future<List<BiteCaseModel>> getBiteCasesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    await loadBiteCaseData();
    return _biteCases?.where((biteCase) {
          final incidentDate = biteCase.incidentDate;
          return incidentDate.isAfter(
                startDate.subtract(const Duration(days: 1)),
              ) &&
              incidentDate.isBefore(endDate.add(const Duration(days: 1)));
        }).toList() ??
        [];
  }

  // Get bite cases for specific staff member
  static Future<List<BiteCaseModel>> getBiteCasesForStaff(
    String staffId,
  ) async {
    await loadBiteCaseData();
    return _biteCases
            ?.where(
              (biteCase) =>
                  biteCase.assignedOfficer == staffId ||
                  biteCase.createdBy == staffId,
            )
            .toList() ??
        [];
  }

  // Search bite cases
  static Future<List<BiteCaseModel>> searchBiteCases(String query) async {
    if (query.isEmpty) return getAllBiteCases();

    await loadBiteCaseData();
    final lowercaseQuery = query.toLowerCase();

    return _biteCases
            ?.where(
              (biteCase) =>
                  biteCase.victimDetails.name.toLowerCase().contains(
                    lowercaseQuery,
                  ) ||
                  biteCase.victimDetails.contact.toLowerCase().contains(
                    lowercaseQuery,
                  ) ||
                  (biteCase.location.address?.toLowerCase().contains(
                        lowercaseQuery,
                      ) ??
                      false) ||
                  (biteCase.location.ward?.toLowerCase().contains(
                        lowercaseQuery,
                      ) ??
                      false) ||
                  biteCase.animalDetails.species.toLowerCase().contains(
                    lowercaseQuery,
                  ) ||
                  biteCase.id.toLowerCase().contains(lowercaseQuery),
            )
            .toList() ??
        [];
  }

  // Get bite case statistics
  static Future<Map<String, int>> getBiteCaseStats() async {
    await loadBiteCaseData();

    final stats = <String, int>{
      'total': _biteCases?.length ?? 0,
      'open': 0,
      'under_investigation': 0,
      'closed': 0,
      'referred': 0,
      'minor': 0,
      'major': 0,
      'severe': 0,
      'last_7_days': 0,
      'last_30_days': 0,
    };

    if (_biteCases == null) return stats;

    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    for (final biteCase in _biteCases!) {
      // Status stats
      switch (biteCase.status) {
        case BiteCaseStatus.open:
          stats['open'] = (stats['open'] ?? 0) + 1;
          break;
        case BiteCaseStatus.underInvestigation:
          stats['under_investigation'] =
              (stats['under_investigation'] ?? 0) + 1;
          break;
        case BiteCaseStatus.closed:
          stats['closed'] = (stats['closed'] ?? 0) + 1;
          break;
        case BiteCaseStatus.referred:
          stats['referred'] = (stats['referred'] ?? 0) + 1;
          break;
      }

      // Severity stats
      switch (biteCase.incidentDetails.severity) {
        case BiteCaseSeverity.minor:
          stats['minor'] = (stats['minor'] ?? 0) + 1;
          break;
        case BiteCaseSeverity.major:
          stats['major'] = (stats['major'] ?? 0) + 1;
          break;
        case BiteCaseSeverity.severe:
          stats['severe'] = (stats['severe'] ?? 0) + 1;
          break;
      }

      // Date-based stats
      final incidentDate = biteCase.incidentDate;
      if (incidentDate.isAfter(sevenDaysAgo)) {
        stats['last_7_days'] = (stats['last_7_days'] ?? 0) + 1;
      }
      if (incidentDate.isAfter(thirtyDaysAgo)) {
        stats['last_30_days'] = (stats['last_30_days'] ?? 0) + 1;
      }
    }

    return stats;
  }

  // Get ward statistics
  static Future<Map<String, Map<String, int>>> getBiteCaseStatsByWard() async {
    await loadBiteCaseData();

    final wardStats = <String, Map<String, int>>{};

    if (_biteCases == null) return wardStats;

    for (final biteCase in _biteCases!) {
      final ward = biteCase.location.ward ?? 'Unknown';

      if (!wardStats.containsKey(ward)) {
        wardStats[ward] = {
          'total': 0,
          'open': 0,
          'under_investigation': 0,
          'closed': 0,
          'referred': 0,
          'minor': 0,
          'major': 0,
          'severe': 0,
        };
      }

      wardStats[ward]!['total'] = (wardStats[ward]!['total'] ?? 0) + 1;

      // Status stats
      switch (biteCase.status) {
        case BiteCaseStatus.open:
          wardStats[ward]!['open'] = (wardStats[ward]!['open'] ?? 0) + 1;
          break;
        case BiteCaseStatus.underInvestigation:
          wardStats[ward]!['under_investigation'] =
              (wardStats[ward]!['under_investigation'] ?? 0) + 1;
          break;
        case BiteCaseStatus.closed:
          wardStats[ward]!['closed'] = (wardStats[ward]!['closed'] ?? 0) + 1;
          break;
        case BiteCaseStatus.referred:
          wardStats[ward]!['referred'] =
              (wardStats[ward]!['referred'] ?? 0) + 1;
          break;
      }

      // Severity stats
      switch (biteCase.incidentDetails.severity) {
        case BiteCaseSeverity.minor:
          wardStats[ward]!['minor'] = (wardStats[ward]!['minor'] ?? 0) + 1;
          break;
        case BiteCaseSeverity.major:
          wardStats[ward]!['major'] = (wardStats[ward]!['major'] ?? 0) + 1;
          break;
        case BiteCaseSeverity.severe:
          wardStats[ward]!['severe'] = (wardStats[ward]!['severe'] ?? 0) + 1;
          break;
      }
    }

    return wardStats;
  }

  // Add new bite case
  static Future<bool> addBiteCase(BiteCaseModel biteCase) async {
    await loadBiteCaseData();

    try {
      // Check if ID already exists
      final exists = _biteCases!.any((existing) => existing.id == biteCase.id);
      if (exists) {
        AppLogger.w('Bite case with ID ${biteCase.id} already exists');
        return false;
      }

      _biteCases!.add(biteCase);
      AppLogger.i('Added bite case: ${biteCase.id}');
      return true;
    } catch (e) {
      AppLogger.e('Error adding bite case: $e');
      return false;
    }
  }

  // Update bite case
  static Future<bool> updateBiteCase(BiteCaseModel updatedBiteCase) async {
    await loadBiteCaseData();

    try {
      final index = _biteCases!.indexWhere(
        (biteCase) => biteCase.id == updatedBiteCase.id,
      );

      if (index == -1) {
        AppLogger.w(
          'Bite case with ID ${updatedBiteCase.id} not found for update',
        );
        return false;
      }

      _biteCases![index] = updatedBiteCase;
      AppLogger.i('Updated bite case: ${updatedBiteCase.id}');
      return true;
    } catch (e) {
      AppLogger.e('Error updating bite case: $e');
      return false;
    }
  }

  // Delete bite case
  static Future<bool> deleteBiteCase(String id) async {
    await loadBiteCaseData();

    try {
      final initialLength = _biteCases!.length;
      _biteCases!.removeWhere((biteCase) => biteCase.id == id);

      if (_biteCases!.length < initialLength) {
        AppLogger.i('Deleted bite case: $id');
        return true;
      } else {
        AppLogger.w('Bite case with ID $id not found for deletion');
        return false;
      }
    } catch (e) {
      AppLogger.e('Error deleting bite case: $e');
      return false;
    }
  }

  // Refresh data
  static Future<void> refreshData() async {
    clearCache();
    await loadBiteCaseData();
  }

  // Get cases requiring attention (high/critical priority or overdue)
  static Future<List<BiteCaseModel>> getCasesRequiringAttention() async {
    await loadBiteCaseData();

    final now = DateTime.now();

    return _biteCases
            ?.where(
              (biteCase) =>
                  // High or critical priority
                  biteCase.priority == BiteCasePriority.high ||
                  biteCase.priority == BiteCasePriority.critical ||
                  // Cases reported more than 24 hours ago but still open
                  (biteCase.status != BiteCaseStatus.closed &&
                      now.difference(biteCase.reportedDate).inHours > 24),
            )
            .toList() ??
        [];
  }
}
