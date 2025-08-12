import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/models/models.dart';
import '../services/rabies_service.dart';
import '../../auth/services/auth_service.dart';

class RabiesController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Observable lists
  final RxList<RabiesCaseModel> _allRabiesCases = <RabiesCaseModel>[].obs;
  final RxList<RabiesCaseModel> _filteredRabiesCases = <RabiesCaseModel>[].obs;

  // Loading states
  final RxBool _isLoading = false.obs;
  final RxBool _isRefreshing = false.obs;

  // Current filter and search
  final RxString _searchQuery = ''.obs;
  final Rx<RabiesSuspicionLevel?> _currentSuspicionFilter =
      Rx<RabiesSuspicionLevel?>(null);
  final Rx<RabiesOutcomeStatus?> _currentOutcomeFilter =
      Rx<RabiesOutcomeStatus?>(null);
  final RxBool _showOnlyUrgent = false.obs;
  final RxBool _showOnlyConfirmed = false.obs;

  // Statistics
  final RxMap<String, int> _statistics = <String, int>{}.obs;

  // Current user info
  String? get currentUserId => _authService.currentUser?.id;
  String? get currentUserRole => _authService.currentUser?.role;

  // Getters
  List<RabiesCaseModel> get allRabiesCases => _allRabiesCases;
  List<RabiesCaseModel> get filteredRabiesCases => _filteredRabiesCases;
  bool get isLoading => _isLoading.value;
  bool get isRefreshing => _isRefreshing.value;
  String get searchQuery => _searchQuery.value;
  RabiesSuspicionLevel? get currentSuspicionFilter =>
      _currentSuspicionFilter.value;
  RabiesOutcomeStatus? get currentOutcomeFilter => _currentOutcomeFilter.value;
  bool get showOnlyUrgent => _showOnlyUrgent.value;
  bool get showOnlyConfirmed => _showOnlyConfirmed.value;
  Map<String, int> get statistics => _statistics;

  @override
  void onInit() {
    super.onInit();
    AppLogger.i('🎮 Initializing RabiesController...');
    loadRabiesCases();
  }

  // Load rabies cases
  Future<void> loadRabiesCases() async {
    if (_isLoading.value) return;

    try {
      _setLoading(true);
      AppLogger.i('📥 Loading rabies cases...');

      final rabiesCases = await RabiesService.getAllRabiesCases();
      _allRabiesCases.assignAll(rabiesCases);

      await _loadStatistics();
      _applyFilters();

      AppLogger.i('✅ Loaded ${rabiesCases.length} rabies cases');
    } catch (e) {
      AppLogger.e('❌ Error loading rabies cases', e);
      _showError('Failed to load rabies cases: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  // Refresh rabies cases
  Future<void> refreshRabiesCases() async {
    if (_isRefreshing.value) return;

    try {
      _setRefreshing(true);
      AppLogger.i('🔄 Refreshing rabies cases...');

      await RabiesService.refreshData();
      final rabiesCases = await RabiesService.getAllRabiesCases();
      _allRabiesCases.assignAll(rabiesCases);

      await _loadStatistics();
      _applyFilters();

      AppLogger.i('✅ Refreshed ${rabiesCases.length} rabies cases');
      Get.snackbar(
        'success'.tr,
        'rabies_cases_refreshed'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      AppLogger.e('❌ Error refreshing rabies cases', e);
      _showError('Failed to refresh rabies cases: ${e.toString()}');
    } finally {
      _setRefreshing(false);
    }
  }

  // Load statistics
  Future<void> _loadStatistics() async {
    try {
      final stats = await RabiesService.getRabiesCaseStats();
      final labStats = await RabiesService.getLabResultStats();

      _statistics.assignAll({...stats, ...labStats});

      AppLogger.d('📊 Updated statistics: $_statistics');
    } catch (e) {
      AppLogger.e('❌ Error loading statistics', e);
    }
  }

  // Search functionality
  void search(String query) {
    _searchQuery.value = query;
    _applyFilters();
  }

  // Clear search
  void clearSearch() {
    _searchQuery.value = '';
    _applyFilters();
  }

  // Filter by suspicion level
  void filterBySuspicionLevel(RabiesSuspicionLevel? suspicionLevel) {
    _currentSuspicionFilter.value = suspicionLevel;
    _applyFilters();
  }

  // Filter by outcome status
  void filterByOutcomeStatus(RabiesOutcomeStatus? outcomeStatus) {
    _currentOutcomeFilter.value = outcomeStatus;
    _applyFilters();
  }

  // Toggle urgent filter
  void toggleUrgentFilter() {
    _showOnlyUrgent.value = !_showOnlyUrgent.value;
    _applyFilters();
  }

  // Toggle confirmed filter
  void toggleConfirmedFilter() {
    _showOnlyConfirmed.value = !_showOnlyConfirmed.value;
    _applyFilters();
  }

  // Clear all filters
  void clearFilters() {
    _currentSuspicionFilter.value = null;
    _currentOutcomeFilter.value = null;
    _showOnlyUrgent.value = false;
    _showOnlyConfirmed.value = false;
    _searchQuery.value = '';
    _applyFilters();
  }

  // Apply filters and search
  void _applyFilters() {
    List<RabiesCaseModel> filtered = List.from(_allRabiesCases);

    // Apply search filter
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered.where((rabiesCase) {
        final query = _searchQuery.value.toLowerCase();

        // Search in ID, animal info, location, clinical signs, etc.
        return rabiesCase.id.toLowerCase().contains(query) ||
            rabiesCase.animalInfo.species.name.toLowerCase().contains(query) ||
            rabiesCase.animalInfo.tagNumber?.toLowerCase().contains(query) ==
                true ||
            rabiesCase.location.address?.toLowerCase().contains(query) ==
                true ||
            rabiesCase.location.ward?.toLowerCase().contains(query) == true ||
            rabiesCase.clinicalSigns.allSigns.any(
              (sign) => sign.toLowerCase().contains(query),
            ) ||
            rabiesCase.reportedBy?.toLowerCase().contains(query) == true ||
            rabiesCase.statusSummary.toLowerCase().contains(query);
      }).toList();
    }

    // Apply suspicion level filter
    if (_currentSuspicionFilter.value != null) {
      filtered = filtered
          .where(
            (rabiesCase) =>
                rabiesCase.suspicionLevel == _currentSuspicionFilter.value,
          )
          .toList();
    }

    // Apply outcome status filter
    if (_currentOutcomeFilter.value != null) {
      filtered = filtered
          .where(
            (rabiesCase) =>
                rabiesCase.outcome.status == _currentOutcomeFilter.value,
          )
          .toList();
    }

    // Apply urgent filter
    if (_showOnlyUrgent.value) {
      filtered = filtered
          .where((rabiesCase) => rabiesCase.needsUrgentAttention)
          .toList();
    }

    // Apply confirmed filter
    if (_showOnlyConfirmed.value) {
      filtered = filtered
          .where((rabiesCase) => rabiesCase.isConfirmedPositive)
          .toList();
    }

    _filteredRabiesCases.assignAll(filtered);

    AppLogger.d(
      '🔍 Applied filters: ${filtered.length}/${_allRabiesCases.length} rabies cases',
    );
  }

  // Get rabies case by ID
  RabiesCaseModel? getRabiesCaseById(String id) {
    try {
      return _allRabiesCases.firstWhere((rabiesCase) => rabiesCase.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add new rabies case
  Future<bool> addRabiesCase(RabiesCaseModel rabiesCase) async {
    try {
      _setLoading(true);

      final success = await RabiesService.addRabiesCase(rabiesCase);
      if (success) {
        _allRabiesCases.add(rabiesCase);
        await _loadStatistics();
        _applyFilters();

        Get.snackbar(
          'success'.tr,
          'rabies_case_added_successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        AppLogger.i('✅ Added rabies case: ${rabiesCase.id}');
        return true;
      } else {
        _showError('Failed to add rabies case');
        return false;
      }
    } catch (e) {
      AppLogger.e('❌ Error adding rabies case', e);
      _showError('Error adding rabies case: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update rabies case
  Future<bool> updateRabiesCase(RabiesCaseModel updatedRabiesCase) async {
    try {
      _setLoading(true);

      final success = await RabiesService.updateRabiesCase(updatedRabiesCase);
      if (success) {
        final index = _allRabiesCases.indexWhere(
          (rabiesCase) => rabiesCase.id == updatedRabiesCase.id,
        );
        if (index != -1) {
          _allRabiesCases[index] = updatedRabiesCase;
          await _loadStatistics();
          _applyFilters();
        }

        Get.snackbar(
          'success'.tr,
          'rabies_case_updated_successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        AppLogger.i('✅ Updated rabies case: ${updatedRabiesCase.id}');
        return true;
      } else {
        _showError('Failed to update rabies case');
        return false;
      }
    } catch (e) {
      AppLogger.e('❌ Error updating rabies case', e);
      _showError('Error updating rabies case: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete rabies case
  Future<bool> deleteRabiesCase(String id) async {
    try {
      _setLoading(true);

      final success = await RabiesService.deleteRabiesCase(id);
      if (success) {
        _allRabiesCases.removeWhere((rabiesCase) => rabiesCase.id == id);
        await _loadStatistics();
        _applyFilters();

        Get.snackbar(
          'success'.tr,
          'rabies_case_deleted_successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        AppLogger.i('✅ Deleted rabies case: $id');
        return true;
      } else {
        _showError('Failed to delete rabies case');
        return false;
      }
    } catch (e) {
      AppLogger.e('❌ Error deleting rabies case', e);
      _showError('Error deleting rabies case: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Navigation methods
  void navigateToRabiesCaseDetail(String rabiesCaseId) {
    Get.toNamed('/rabies-detail', arguments: rabiesCaseId);
  }

  void navigateToAddRabiesCase() {
    Get.toNamed('/add-rabies-case');
  }

  void navigateToEditRabiesCase(String rabiesCaseId) {
    Get.toNamed('/edit-rabies-case', arguments: rabiesCaseId);
  }

  // Get cases requiring attention
  Future<List<RabiesCaseModel>> getCasesRequiringAttention() async {
    return await RabiesService.getCasesRequiringAttention();
  }

  // Get urgent cases count
  int get urgentCasesCount => _statistics['urgent'] ?? 0;

  // Get confirmed cases count
  int get confirmedCasesCount => _statistics['confirmed'] ?? 0;

  // Get pending lab results count
  int get pendingLabResultsCount => _statistics['pending'] ?? 0;

  // Utility methods
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void _setRefreshing(bool refreshing) {
    _isRefreshing.value = refreshing;
  }

  void _showError(String message) {
    Get.snackbar(
      'error'.tr,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // Get suspicion level color
  Color getSuspicionLevelColor(RabiesSuspicionLevel level) {
    switch (level) {
      case RabiesSuspicionLevel.low:
        return Colors.green;
      case RabiesSuspicionLevel.medium:
        return Colors.orange;
      case RabiesSuspicionLevel.high:
        return Colors.red;
    }
  }

  // Get outcome status color
  Color getOutcomeStatusColor(RabiesOutcomeStatus status) {
    switch (status) {
      case RabiesOutcomeStatus.underObservation:
        return Colors.blue;
      case RabiesOutcomeStatus.deceased:
        return Colors.grey;
      case RabiesOutcomeStatus.euthanized:
        return Colors.grey.shade600;
      case RabiesOutcomeStatus.released:
        return Colors.green;
      case RabiesOutcomeStatus.escaped:
        return Colors.orange;
    }
  }

  // Get test result color
  Color getTestResultColor(RabiesTestResult result) {
    switch (result) {
      case RabiesTestResult.positive:
        return Colors.red;
      case RabiesTestResult.negative:
        return Colors.green;
      case RabiesTestResult.pending:
        return Colors.orange;
      case RabiesTestResult.inconclusive:
        return Colors.grey;
    }
  }
}
