import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../shared/models/quarantine/quarantine_record_model.dart';
import '../services/quarantine_service.dart';
import '../../../core/utils/app_logger.dart';

class QuarantineController extends GetxController {
  // Observable state
  final _isLoading = false.obs;
  final _quarantineRecords = <QuarantineRecordModel>[].obs;
  final _filteredRecords = <QuarantineRecordModel>[].obs;
  final _searchQuery = ''.obs;
  final _statistics = <String, dynamic>{}.obs;

  // Filter states
  final _currentObservationStatusFilter = Rxn<QuarantineObservationStatus>();
  final _currentLocationTypeFilter = Rxn<QuarantineLocationType>();
  final _currentFinalOutcomeFilter = Rxn<QuarantineFinalOutcome>();
  final _showOnlyActive = false.obs;
  final _showOnlyUrgent = false.obs;
  final _showOnlyCompleted = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<QuarantineRecordModel> get quarantineRecords => _quarantineRecords;
  List<QuarantineRecordModel> get filteredRecords => _filteredRecords;
  String get searchQuery => _searchQuery.value;
  Map<String, dynamic> get statistics => _statistics;

  // Filter getters
  QuarantineObservationStatus? get currentObservationStatusFilter =>
      _currentObservationStatusFilter.value;
  QuarantineLocationType? get currentLocationTypeFilter =>
      _currentLocationTypeFilter.value;
  QuarantineFinalOutcome? get currentFinalOutcomeFilter =>
      _currentFinalOutcomeFilter.value;
  bool get showOnlyActive => _showOnlyActive.value;
  bool get showOnlyUrgent => _showOnlyUrgent.value;
  bool get showOnlyCompleted => _showOnlyCompleted.value;

  @override
  void onInit() {
    super.onInit();
    loadQuarantineRecords();
    _setupReactiveFiltering();
  }

  // Setup reactive filtering
  void _setupReactiveFiltering() {
    // Listen to changes in filters and search query
    ever(_searchQuery, (_) => _applyFilters());
    ever(_currentObservationStatusFilter, (_) => _applyFilters());
    ever(_currentLocationTypeFilter, (_) => _applyFilters());
    ever(_currentFinalOutcomeFilter, (_) => _applyFilters());
    ever(_showOnlyActive, (_) => _applyFilters());
    ever(_showOnlyUrgent, (_) => _applyFilters());
    ever(_showOnlyCompleted, (_) => _applyFilters());
  }

  // Load all quarantine records
  Future<void> loadQuarantineRecords() async {
    try {
      _isLoading.value = true;
      AppLogger.i('📥 Loading quarantine records...');

      final records = await QuarantineService.getAllQuarantineRecords();
      _quarantineRecords.assignAll(records);

      await _updateStatistics();
      _applyFilters();

      AppLogger.i('✅ Successfully loaded ${records.length} quarantine records');
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error loading quarantine records: $e', e, stackTrace);
      Get.snackbar(
        'Error',
        'Failed to load quarantine records',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await loadQuarantineRecords();
  }

  // Search quarantine records
  Future<void> searchQuarantineRecords(String query) async {
    _searchQuery.value = query;
    // Filtering is handled by reactive system
  }

  // Apply all active filters
  void _applyFilters() {
    var filtered = List<QuarantineRecordModel>.from(_quarantineRecords);

    // Apply search filter
    if (_searchQuery.value.isNotEmpty) {
      final query = _searchQuery.value.toLowerCase();
      filtered = filtered.where((record) {
        return record.id.toLowerCase().contains(query) ||
            record.biteCaseId?.toLowerCase().contains(query) == true ||
            record.animalInfo.species.name.toLowerCase().contains(query) ||
            record.animalInfo.tagNumber?.toLowerCase().contains(query) ==
                true ||
            record.animalInfo.color.toLowerCase().contains(query) ||
            record.quarantineLocation.address.toLowerCase().contains(query) ||
            record.ownerDetails?.name?.toLowerCase().contains(query) == true ||
            record.ownerDetails?.contact?.toLowerCase().contains(query) ==
                true ||
            record.dailyObservations.any(
              (obs) =>
                  obs.notes?.toLowerCase().contains(query) == true ||
                  obs.observedBy.toLowerCase().contains(query),
            );
      }).toList();
    }

    // Apply observation status filter
    if (_currentObservationStatusFilter.value != null) {
      filtered = filtered
          .where(
            (record) =>
                record.observationStatus ==
                _currentObservationStatusFilter.value,
          )
          .toList();
    }

    // Apply location type filter
    if (_currentLocationTypeFilter.value != null) {
      filtered = filtered
          .where(
            (record) =>
                record.quarantineLocation.type ==
                _currentLocationTypeFilter.value,
          )
          .toList();
    }

    // Apply final outcome filter
    if (_currentFinalOutcomeFilter.value != null) {
      filtered = filtered
          .where(
            (record) => record.finalOutcome == _currentFinalOutcomeFilter.value,
          )
          .toList();
    }

    // Apply active only filter
    if (_showOnlyActive.value) {
      final now = DateTime.now();
      filtered = filtered
          .where(
            (record) =>
                now.isAfter(record.startDate) &&
                now.isBefore(record.endDate) &&
                record.finalOutcome == null,
          )
          .toList();
    }

    // Apply completed only filter
    if (_showOnlyCompleted.value) {
      final now = DateTime.now();
      filtered = filtered
          .where(
            (record) =>
                now.isAfter(record.endDate) || record.finalOutcome != null,
          )
          .toList();
    }

    // Apply urgent only filter
    if (_showOnlyUrgent.value) {
      filtered = filtered
          .where((record) => record.needsUrgentAttention)
          .toList();
    }

    _filteredRecords.assignAll(filtered);
  }

  // Update statistics
  Future<void> _updateStatistics() async {
    try {
      final stats = await QuarantineService.getQuarantineStatistics();
      _statistics.assignAll(stats);
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error updating statistics: $e', e, stackTrace);
    }
  }

  // Filter methods
  void filterByObservationStatus(QuarantineObservationStatus? status) {
    _currentObservationStatusFilter.value = status;
  }

  void filterByLocationType(QuarantineLocationType? locationType) {
    _currentLocationTypeFilter.value = locationType;
  }

  void filterByFinalOutcome(QuarantineFinalOutcome? outcome) {
    _currentFinalOutcomeFilter.value = outcome;
  }

  void toggleActiveFilter() {
    _showOnlyActive.value = !_showOnlyActive.value;
    if (_showOnlyActive.value) {
      _showOnlyCompleted.value = false;
    }
  }

  void toggleCompletedFilter() {
    _showOnlyCompleted.value = !_showOnlyCompleted.value;
    if (_showOnlyCompleted.value) {
      _showOnlyActive.value = false;
    }
  }

  void toggleUrgentFilter() {
    _showOnlyUrgent.value = !_showOnlyUrgent.value;
  }

  // Clear all filters
  void clearAllFilters() {
    _searchQuery.value = '';
    _currentObservationStatusFilter.value = null;
    _currentLocationTypeFilter.value = null;
    _currentFinalOutcomeFilter.value = null;
    _showOnlyActive.value = false;
    _showOnlyUrgent.value = false;
    _showOnlyCompleted.value = false;
  }

  // Navigation methods
  void navigateToQuarantineDetail(QuarantineRecordModel record) {
    Get.toNamed('/quarantine/detail', arguments: record);
  }

  void navigateToAddQuarantine() {
    Get.toNamed('/quarantine/add');
  }

  void navigateToEditQuarantine(QuarantineRecordModel record) {
    Get.toNamed('/quarantine/edit', arguments: record);
  }

  // CRUD operations
  Future<void> addQuarantineRecord(QuarantineRecordModel record) async {
    try {
      _isLoading.value = true;
      final success = await QuarantineService.addQuarantineRecord(record);

      if (success) {
        await loadQuarantineRecords(); // Refresh the list
        Get.snackbar(
          'Success',
          'Quarantine record added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.back(); // Navigate back to list
      } else {
        throw Exception('Failed to add quarantine record');
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error adding quarantine record: $e', e, stackTrace);
      Get.snackbar(
        'Error',
        'Failed to add quarantine record: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateQuarantineRecord(QuarantineRecordModel record) async {
    try {
      _isLoading.value = true;
      final success = await QuarantineService.updateQuarantineRecord(record);

      if (success) {
        await loadQuarantineRecords(); // Refresh the list
        Get.snackbar(
          'Success',
          'Quarantine record updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.back(); // Navigate back to list
      } else {
        throw Exception('Failed to update quarantine record');
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error updating quarantine record: $e', e, stackTrace);
      Get.snackbar(
        'Error',
        'Failed to update quarantine record: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> deleteQuarantineRecord(String recordId) async {
    try {
      _isLoading.value = true;
      final success = await QuarantineService.deleteQuarantineRecord(recordId);

      if (success) {
        await loadQuarantineRecords(); // Refresh the list
        Get.snackbar(
          'Success',
          'Quarantine record deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Failed to delete quarantine record');
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error deleting quarantine record: $e', e, stackTrace);
      Get.snackbar(
        'Error',
        'Failed to delete quarantine record: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> addDailyObservation(
    String recordId,
    DailyObservation observation,
  ) async {
    try {
      _isLoading.value = true;
      final success = await QuarantineService.addDailyObservation(
        recordId,
        observation,
      );

      if (success) {
        await loadQuarantineRecords(); // Refresh the list
        Get.snackbar(
          'Success',
          'Daily observation added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception('Failed to add daily observation');
      }
    } catch (e, stackTrace) {
      AppLogger.e('❌ Error adding daily observation: $e', e, stackTrace);
      Get.snackbar(
        'Error',
        'Failed to add daily observation: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Helper methods for UI
  Color getObservationStatusColor(QuarantineObservationStatus status) {
    switch (status) {
      case QuarantineObservationStatus.aliveHealthy:
        return Colors.green;
      case QuarantineObservationStatus.sick:
        return Colors.orange;
      case QuarantineObservationStatus.dead:
        return Colors.red;
      case QuarantineObservationStatus.escaped:
        return Colors.purple;
      case QuarantineObservationStatus.notObserved:
        return Colors.grey;
    }
  }

  Color getLocationTypeColor(QuarantineLocationType type) {
    switch (type) {
      case QuarantineLocationType.facility:
        return Colors.blue;
      case QuarantineLocationType.home:
        return Colors.green;
      case QuarantineLocationType.street:
        return Colors.orange;
    }
  }

  Color getFinalOutcomeColor(QuarantineFinalOutcome outcome) {
    switch (outcome) {
      case QuarantineFinalOutcome.released:
        return Colors.green;
      case QuarantineFinalOutcome.euthanized:
        return Colors.red;
      case QuarantineFinalOutcome.naturalDeath:
        return Colors.red.shade300;
      case QuarantineFinalOutcome.transferred:
        return Colors.blue;
      case QuarantineFinalOutcome.escaped:
        return Colors.purple;
    }
  }

  // Get progress percentage for observation period
  double getObservationProgress(QuarantineRecordModel record) {
    final now = DateTime.now();
    final totalDays = record.endDate.difference(record.startDate).inDays;
    final daysPassed = now.difference(record.startDate).inDays;

    if (daysPassed <= 0) return 0.0;
    if (daysPassed >= totalDays) return 1.0;

    return daysPassed / totalDays;
  }

  // Get days remaining in observation
  int getDaysRemaining(QuarantineRecordModel record) {
    final now = DateTime.now();
    final daysRemaining = record.endDate.difference(now).inDays;
    return daysRemaining < 0 ? 0 : daysRemaining;
  }

  // Check if observation is overdue
  bool isObservationOverdue(QuarantineRecordModel record) {
    final now = DateTime.now();
    return now.isAfter(record.endDate) && record.finalOutcome == null;
  }
}
