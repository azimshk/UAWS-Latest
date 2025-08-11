import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/models/models.dart';
import '../services/sterilization_service.dart';
import '../../auth/services/auth_service.dart';

class SterilizationController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Observable lists
  final RxList<SterilizationModel> _allSterilizations =
      <SterilizationModel>[].obs;
  final RxList<SterilizationModel> _filteredSterilizations =
      <SterilizationModel>[].obs;

  // Loading states
  final RxBool _isLoading = false.obs;
  final RxBool _isRefreshing = false.obs;

  // Current filter and search
  final RxString _searchQuery = ''.obs;
  final Rx<SterilizationStage?> _currentStageFilter = Rx<SterilizationStage?>(
    null,
  );
  final RxBool _showOnlyMyAssignments = false.obs;

  // Statistics
  final RxMap<String, int> _statistics = <String, int>{}.obs;

  // Current user info
  String? get currentUserId => _authService.currentUser?.id;
  String? get currentUserRole => _authService.currentUser?.role;

  // Getters
  List<SterilizationModel> get allSterilizations => _allSterilizations;
  List<SterilizationModel> get filteredSterilizations =>
      _filteredSterilizations;
  bool get isLoading => _isLoading.value;
  bool get isRefreshing => _isRefreshing.value;
  String get searchQuery => _searchQuery.value;
  SterilizationStage? get currentStageFilter => _currentStageFilter.value;
  bool get showOnlyMyAssignments => _showOnlyMyAssignments.value;
  Map<String, int> get statistics => _statistics;

  @override
  void onInit() {
    super.onInit();
    AppLogger.i('🎮 Initializing SterilizationController...');
    loadSterilizations();
  }

  // Load all sterilizations
  Future<void> loadSterilizations() async {
    try {
      _isLoading.value = true;
      AppLogger.d('📥 Loading sterilizations...');

      final sterilizations = await SterilizationService.getAllSterilizations();
      _allSterilizations.assignAll(sterilizations);

      // Load statistics
      final stats = await SterilizationService.getSterilizationStats();
      _statistics.assignAll(stats);

      // Apply current filters
      _applyFilters();

      AppLogger.i('✅ Loaded ${sterilizations.length} sterilizations');
    } catch (e) {
      AppLogger.e('❌ Error loading sterilizations', e);
      Get.snackbar(
        'error'.tr,
        'failed_to_load_sterilizations'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    } finally {
      _isLoading.value = false;
    }
  }

  // Refresh data
  Future<void> refreshSterilizations() async {
    try {
      _isRefreshing.value = true;
      AppLogger.d('🔄 Refreshing sterilizations...');

      // Clear cache and reload
      SterilizationService.clearCache();
      await loadSterilizations();

      Get.snackbar(
        'success'.tr,
        'data_refreshed'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
    } catch (e) {
      AppLogger.e('❌ Error refreshing sterilizations', e);
    } finally {
      _isRefreshing.value = false;
    }
  }

  // Search sterilizations
  void searchSterilizations(String query) {
    _searchQuery.value = query;
    _applyFilters();
  }

  // Filter by stage
  void filterByStage(SterilizationStage? stage) {
    _currentStageFilter.value = stage;
    _applyFilters();
  }

  // Toggle my assignments filter
  void toggleMyAssignments() {
    _showOnlyMyAssignments.value = !_showOnlyMyAssignments.value;
    _applyFilters();
  }

  // Apply all filters
  void _applyFilters() {
    List<SterilizationModel> filtered = List.from(_allSterilizations);

    // Apply search filter
    if (_searchQuery.value.isNotEmpty) {
      final query = _searchQuery.value.toLowerCase();
      filtered = filtered
          .where(
            (s) =>
                s.animalInfo.tagNumber?.toLowerCase().contains(query) == true ||
                s.animalInfo.color.toLowerCase().contains(query) ||
                s.animalInfo.species.name.toLowerCase().contains(query) ||
                s.pickupStage.staffName.toLowerCase().contains(query) ||
                s.operationStage.veterinarianName?.toLowerCase().contains(
                      query,
                    ) ==
                    true ||
                s.id?.toLowerCase().contains(query) == true,
          )
          .toList();
    }

    // Apply stage filter
    if (_currentStageFilter.value != null) {
      filtered = filtered
          .where((s) => s.currentStage == _currentStageFilter.value)
          .toList();
    }

    // Apply my assignments filter
    if (_showOnlyMyAssignments.value && currentUserId != null) {
      filtered = filtered
          .where(
            (s) =>
                s.pickupStage.staffId == currentUserId ||
                s.operationStage.veterinarianId == currentUserId ||
                s.releaseStage.staffId == currentUserId,
          )
          .toList();
    }

    _filteredSterilizations.assignAll(filtered);
    AppLogger.d('🔍 Applied filters: ${filtered.length} results');
  }

  // Clear all filters
  void clearFilters() {
    _searchQuery.value = '';
    _currentStageFilter.value = null;
    _showOnlyMyAssignments.value = false;
    _applyFilters();
  }

  // Get sterilizations by stage for specific views
  Future<List<SterilizationModel>> getSterilizationsByStage(
    SterilizationStage stage,
  ) async {
    return await SterilizationService.getSterilizationsByStage(stage);
  }

  // Create new sterilization (pickup stage)
  Future<SterilizationModel?> createNewSterilization({
    required AnimalInfo animalInfo,
    required PickupStage pickupStage,
  }) async {
    try {
      AppLogger.i('🆕 Creating new sterilization...');

      final newSterilization = SterilizationModel(
        animalInfo: animalInfo,
        pickupStage: pickupStage,
        operationStage: OperationStage(),
        releaseStage: ReleaseStage(),
        currentStage: SterilizationStage.pickup,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: currentUserId ?? 'unknown',
      );

      final created = await SterilizationService.createSterilization(
        newSterilization,
      );

      // Refresh data
      await loadSterilizations();

      Get.snackbar(
        'success'.tr,
        'sterilization_created_successfully'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );

      AppLogger.i('✅ Created sterilization: ${created.id}');
      return created;
    } catch (e) {
      AppLogger.e('❌ Error creating sterilization', e);
      Get.snackbar(
        'error'.tr,
        'failed_to_create_sterilization'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return null;
    }
  }

  // Update pickup stage
  Future<bool> updatePickupStage(
    String sterilizationId,
    PickupStage pickupStage,
  ) async {
    try {
      AppLogger.i('🔄 Updating pickup stage for: $sterilizationId');

      await SterilizationService.updatePickupStage(
        sterilizationId,
        pickupStage,
      );

      // Refresh data
      await loadSterilizations();

      Get.snackbar(
        'success'.tr,
        'pickup_stage_updated'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );

      return true;
    } catch (e) {
      AppLogger.e('❌ Error updating pickup stage', e);
      Get.snackbar(
        'error'.tr,
        'failed_to_update_pickup_stage'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return false;
    }
  }

  // Update operation stage
  Future<bool> updateOperationStage(
    String sterilizationId,
    OperationStage operationStage,
  ) async {
    try {
      AppLogger.i('🔄 Updating operation stage for: $sterilizationId');

      await SterilizationService.updateOperationStage(
        sterilizationId,
        operationStage,
      );

      // Refresh data
      await loadSterilizations();

      Get.snackbar(
        'success'.tr,
        'operation_stage_updated'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );

      return true;
    } catch (e) {
      AppLogger.e('❌ Error updating operation stage', e);
      Get.snackbar(
        'error'.tr,
        'failed_to_update_operation_stage'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return false;
    }
  }

  // Update release stage
  Future<bool> updateReleaseStage(
    String sterilizationId,
    ReleaseStage releaseStage,
  ) async {
    try {
      AppLogger.i('🔄 Updating release stage for: $sterilizationId');

      await SterilizationService.updateReleaseStage(
        sterilizationId,
        releaseStage,
      );

      // Refresh data
      await loadSterilizations();

      Get.snackbar(
        'success'.tr,
        'release_stage_updated'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );

      return true;
    } catch (e) {
      AppLogger.e('❌ Error updating release stage', e);
      Get.snackbar(
        'error'.tr,
        'failed_to_update_release_stage'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return false;
    }
  }

  // Delete sterilization
  Future<bool> deleteSterilization(String id) async {
    try {
      AppLogger.i('🗑️ Deleting sterilization: $id');

      await SterilizationService.deleteSterilization(id);

      // Refresh data
      await loadSterilizations();

      Get.snackbar(
        'success'.tr,
        'sterilization_deleted'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );

      return true;
    } catch (e) {
      AppLogger.e('❌ Error deleting sterilization', e);
      Get.snackbar(
        'error'.tr,
        'failed_to_delete_sterilization'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return false;
    }
  }

  // Get sterilization by ID
  SterilizationModel? getSterilizationById(String id) {
    try {
      return _allSterilizations.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }

  // Navigation methods for different user roles
  void navigateToPickupForm() {
    if (currentUserRole == 'field_staff') {
      Get.toNamed('/sterilization/pickup');
    } else {
      Get.snackbar(
        'access_denied'.tr,
        'only_field_staff_can_create_pickup'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[800],
      );
    }
  }

  void navigateToOperationForm(String sterilizationId) {
    final sterilization = getSterilizationById(sterilizationId);
    if (sterilization != null && sterilization.isPickupCompleted) {
      if (currentUserRole == 'supervisor' || currentUserRole == 'admin') {
        Get.toNamed('/sterilization/operation/$sterilizationId');
      } else {
        Get.snackbar(
          'access_denied'.tr,
          'only_supervisors_can_perform_operations'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[800],
        );
      }
    } else {
      Get.snackbar(
        'invalid_stage'.tr,
        'pickup_must_be_completed_first'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[800],
      );
    }
  }

  void navigateToReleaseForm(String sterilizationId) {
    final sterilization = getSterilizationById(sterilizationId);
    if (sterilization != null && sterilization.isOperationCompleted) {
      Get.toNamed('/sterilization/release/$sterilizationId');
    } else {
      Get.snackbar(
        'invalid_stage'.tr,
        'operation_must_be_completed_first'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[800],
      );
    }
  }

  void navigateToDetails(String sterilizationId) {
    Get.toNamed('/sterilization/details/$sterilizationId');
  }

  // Utility methods
  String getStageDisplayName(SterilizationStage stage) {
    switch (stage) {
      case SterilizationStage.pickup:
        return 'pickup_stage'.tr;
      case SterilizationStage.operation:
        return 'operation_stage'.tr;
      case SterilizationStage.release:
        return 'release_stage'.tr;
    }
  }

  Color getStageColor(SterilizationStage stage) {
    switch (stage) {
      case SterilizationStage.pickup:
        return const Color(0xFF2E7D32); // Green
      case SterilizationStage.operation:
        return const Color(0xFF4CAF50); // Light Green
      case SterilizationStage.release:
        return const Color(0xFF66BB6A); // Lighter Green
    }
  }

  IconData getStageIcon(SterilizationStage stage) {
    switch (stage) {
      case SterilizationStage.pickup:
        return Icons.pets;
      case SterilizationStage.operation:
        return Icons.medical_services;
      case SterilizationStage.release:
        return Icons.home;
    }
  }

  // Check if current user can access specific operations
  bool canCreatePickup() => currentUserRole == 'field_staff';
  bool canPerformOperation() =>
      currentUserRole == 'supervisor' || currentUserRole == 'admin';
  bool canPerformRelease() =>
      true; // Both field staff and supervisors can release
  bool canViewAll() =>
      currentUserRole == 'supervisor' || currentUserRole == 'admin';
  bool canDelete() => currentUserRole == 'admin';
}
