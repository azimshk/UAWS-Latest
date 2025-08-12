import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/models/models.dart';
import '../services/vaccination_service.dart';
import '../../auth/services/auth_service.dart';

class VaccinationController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Observable lists
  final RxList<VaccinationModel> _allVaccinations = <VaccinationModel>[].obs;
  final RxList<VaccinationModel> _filteredVaccinations =
      <VaccinationModel>[].obs;

  // Loading states
  final RxBool _isLoading = false.obs;
  final RxBool _isRefreshing = false.obs;

  // Filter states
  final RxString _selectedStatus = ''.obs;

  // Form key and controllers for add/edit screens
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController animalIdController = TextEditingController();
  final TextEditingController breedController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController batchNumberController = TextEditingController();
  final TextEditingController vaccinationDateController =
      TextEditingController();
  final TextEditingController nextDueDateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController veterinarianNameController =
      TextEditingController();
  final TextEditingController veterinarianLicenseController =
      TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController costController = TextEditingController();
  final TextEditingController sideEffectsController = TextEditingController();

  // Form observables
  final Rx<AnimalSpecies?> selectedSpecies = Rx<AnimalSpecies?>(null);
  final Rx<AnimalSex?> selectedSex = Rx<AnimalSex?>(null);
  final Rx<AnimalAge?> selectedAge = Rx<AnimalAge?>(null);
  final Rx<AnimalSize?> selectedSize = Rx<AnimalSize?>(null);
  final Rx<VaccinationStatus?> selectedVaccinationStatus =
      Rx<VaccinationStatus?>(null);
  final Rx<DateTime?> selectedVaccinationDate = Rx<DateTime?>(null);
  final Rx<DateTime?> selectedNextDueDate = Rx<DateTime?>(null);
  final Rx<LocationModel?> currentLocation = Rx<LocationModel?>(null);
  final RxString _selectedVaccineType = ''.obs;
  final RxString _selectedWard = ''.obs;
  final RxString _searchQuery = ''.obs;

  // Getters
  List<VaccinationModel> get allVaccinations => _allVaccinations;
  List<VaccinationModel> get filteredVaccinations => _filteredVaccinations;
  bool get isLoading => _isLoading.value;
  bool get isRefreshing => _isRefreshing.value;
  String get selectedStatus => _selectedStatus.value;
  String get selectedVaccineType => _selectedVaccineType.value;
  String get selectedWard => _selectedWard.value;
  String get searchQuery => _searchQuery.value;

  // User access
  UserModel? get currentUser => _authService.currentUser;

  @override
  void onInit() {
    super.onInit();
    loadVaccinations();
  }

  @override
  void onReady() {
    super.onReady();
    _setupDebouncer();
  }

  void _setupDebouncer() {
    // Debounce search to avoid excessive filtering
    debounce(
      _searchQuery,
      (_) => _filterVaccinations(),
      time: const Duration(milliseconds: 300),
    );
  }

  // Load all vaccinations
  Future<void> loadVaccinations() async {
    try {
      _isLoading.value = true;
      AppLogger.i('Loading vaccination records...');

      final vaccinations = await VaccinationService.getAllVaccinations();
      _allVaccinations.assignAll(vaccinations);
      _filteredVaccinations.assignAll(vaccinations);

      AppLogger.i('Loaded ${vaccinations.length} vaccination records');
    } catch (e) {
      AppLogger.e('Error loading vaccinations: $e');
      _showErrorSnackbar('Failed to load vaccination records');
    } finally {
      _isLoading.value = false;
    }
  }

  // Refresh vaccinations
  Future<void> refreshVaccinations() async {
    try {
      _isRefreshing.value = true;
      AppLogger.i('Refreshing vaccination records...');

      final vaccinations = await VaccinationService.getAllVaccinations();
      _allVaccinations.assignAll(vaccinations);
      _filterVaccinations();

      AppLogger.i('Refreshed ${vaccinations.length} vaccination records');
      _showSuccessSnackbar('Vaccination records updated');
    } catch (e) {
      AppLogger.e('Error refreshing vaccinations: $e');
      _showErrorSnackbar('Failed to refresh vaccination records');
    } finally {
      _isRefreshing.value = false;
    }
  }

  // Search functionality
  void updateSearchQuery(String query) {
    _searchQuery.value = query.toLowerCase();
  }

  // Filter by status
  void filterByStatus(String status) {
    _selectedStatus.value = status;
    _filterVaccinations();
  }

  // Filter by vaccine type
  void filterByVaccineType(String vaccineType) {
    _selectedVaccineType.value = vaccineType;
    _filterVaccinations();
  }

  // Filter by ward
  void filterByWard(String ward) {
    _selectedWard.value = ward;
    _filterVaccinations();
  }

  // Clear all filters
  void clearFilters() {
    _selectedStatus.value = '';
    _selectedVaccineType.value = '';
    _selectedWard.value = '';
    _searchQuery.value = '';
    _filteredVaccinations.assignAll(_allVaccinations);
  }

  // Apply filters
  void _filterVaccinations() {
    List<VaccinationModel> filtered = List.from(_allVaccinations);

    // Apply search filter
    if (_searchQuery.value.isNotEmpty) {
      filtered = filtered.where((vaccination) {
        return vaccination.animalId.toLowerCase().contains(
              _searchQuery.value,
            ) ||
            vaccination.animalInfo.species.name.toLowerCase().contains(
              _searchQuery.value,
            ) ||
            vaccination.vaccineType.toLowerCase().contains(
              _searchQuery.value,
            ) ||
            vaccination.veterinarianName.toLowerCase().contains(
              _searchQuery.value,
            ) ||
            vaccination.wardName.toLowerCase().contains(_searchQuery.value);
      }).toList();
    }

    // Apply status filter
    if (_selectedStatus.value.isNotEmpty) {
      filtered = filtered.where((vaccination) {
        return vaccination.status.name.toLowerCase() ==
            _selectedStatus.value.toLowerCase();
      }).toList();
    }

    // Apply vaccine type filter
    if (_selectedVaccineType.value.isNotEmpty) {
      filtered = filtered.where((vaccination) {
        return vaccination.vaccineType.toLowerCase().contains(
          _selectedVaccineType.value.toLowerCase(),
        );
      }).toList();
    }

    // Apply ward filter
    if (_selectedWard.value.isNotEmpty) {
      filtered = filtered.where((vaccination) {
        return vaccination.wardName.toLowerCase().contains(
          _selectedWard.value.toLowerCase(),
        );
      }).toList();
    }

    _filteredVaccinations.assignAll(filtered);
    AppLogger.i('Filtered to ${filtered.length} vaccination records');
  }

  // Get vaccination by ID
  VaccinationModel? getVaccinationById(String id) {
    try {
      return _allVaccinations.firstWhere((vaccination) => vaccination.id == id);
    } catch (e) {
      AppLogger.w('Vaccination with ID $id not found');
      return null;
    }
  }

  // Get vaccinations by animal ID
  List<VaccinationModel> getVaccinationsByAnimalId(String animalId) {
    return _allVaccinations
        .where((vaccination) => vaccination.animalId == animalId)
        .toList();
  }

  // Get vaccinations by status
  List<VaccinationModel> getVaccinationsByStatus(VaccinationStatus status) {
    return _allVaccinations
        .where((vaccination) => vaccination.status == status)
        .toList();
  }

  // Get vaccination statistics
  Map<String, int> getVaccinationStats() {
    final stats = <String, int>{};

    // Count by status
    for (final status in VaccinationStatus.values) {
      stats['${status.name}_count'] = getVaccinationsByStatus(status).length;
    }

    // Count by vaccine type
    final vaccineTypes = _allVaccinations.map((v) => v.vaccineType).toSet();
    for (final type in vaccineTypes) {
      final count = _allVaccinations.where((v) => v.vaccineType == type).length;
      stats['vaccine_${type.toLowerCase().replaceAll(' ', '_')}_count'] = count;
    }

    // Total count
    stats['total_count'] = _allVaccinations.length;

    return stats;
  }

  // Get unique vaccine types
  List<String> getUniqueVaccineTypes() {
    return _allVaccinations.map((v) => v.vaccineType).toSet().toList()..sort();
  }

  // Get unique wards
  List<String> getUniqueWards() {
    return _allVaccinations.map((v) => v.wardName).toSet().toList()..sort();
  }

  // Navigate to vaccination details
  void navigateToVaccinationDetails(String vaccinationId) {
    Get.toNamed(
      '/vaccination-details',
      arguments: {'vaccinationId': vaccinationId},
    );
  }

  // Navigate to add new vaccination
  void navigateToAddVaccination() {
    Get.toNamed('/add-vaccination');
  }

  // Export vaccinations (placeholder)
  Future<void> exportVaccinations() async {
    try {
      AppLogger.i('Exporting vaccination records...');
      _showSuccessSnackbar('Export feature coming soon');
    } catch (e) {
      AppLogger.e('Error exporting vaccinations: $e');
      _showErrorSnackbar('Failed to export vaccination records');
    }
  }

  // Helper methods for snackbars
  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'success'.tr,
      message,
      backgroundColor: const Color(0xFF4CAF50),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'error'.tr,
      message,
      backgroundColor: const Color(0xFFD32F2F),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
    );
  }

  // Form handling methods for add/edit screens
  void updateSpecies(AnimalSpecies species) {
    selectedSpecies.value = species;
  }

  void updateSex(AnimalSex sex) {
    selectedSex.value = sex;
  }

  void updateAge(AnimalAge age) {
    selectedAge.value = age;
  }

  void updateVaccineType(String type) {
    _selectedVaccineType.value = type;
  }

  void updateVaccinationStatus(VaccinationStatus status) {
    selectedVaccinationStatus.value = status;
  }

  void updateVaccinationDate(DateTime date) {
    selectedVaccinationDate.value = date;
    vaccinationDateController.text = '${date.day}/${date.month}/${date.year}';
  }

  void updateNextDueDate(DateTime date) {
    selectedNextDueDate.value = date;
    nextDueDateController.text = '${date.day}/${date.month}/${date.year}';
  }

  Future<void> captureCurrentLocation() async {
    try {
      // Simulate location capture - in real implementation, use geolocator
      currentLocation.value = LocationModel(
        lat: 27.7172 + (Get.testMode ? 0.001 : 0), // Kathmandu coordinates
        lng: 85.3240 + (Get.testMode ? 0.001 : 0),
        address: addressController.text.isNotEmpty
            ? addressController.text
            : null,
      );

      Get.snackbar(
        'Success',
        'Location captured successfully',
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture location: $e',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void saveVaccination() {
    if (formKey.currentState?.validate() != true) {
      return;
    }

    try {
      _isLoading.value = true;

      // Create vaccination model from form data
      final vaccination = VaccinationModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        animalId: animalIdController.text,
        animalInfo: AnimalInfo(
          species: selectedSpecies.value!,
          sex: selectedSex.value!,
          age: selectedAge.value!,
          color: colorController.text,
          size: selectedSize.value ?? AnimalSize.medium,
          breed: breedController.text.isNotEmpty ? breedController.text : null,
          weight: weightController.text.isNotEmpty
              ? double.tryParse(weightController.text)
              : null,
        ),
        location:
            currentLocation.value ??
            LocationModel(
              lat: 27.7172,
              lng: 85.3240,
              address: addressController.text.isNotEmpty
                  ? addressController.text
                  : null,
            ),
        vaccineType: _selectedVaccineType.value,
        batchNumber: batchNumberController.text,
        vaccinationDate: selectedVaccinationDate.value!,
        nextDueDate: selectedNextDueDate.value,
        veterinarianName: veterinarianNameController.text,
        veterinarianLicense: veterinarianLicenseController.text,
        status: selectedVaccinationStatus.value!,
        notes: notesController.text.isNotEmpty ? notesController.text : null,
        beforePhotos: [],
        afterPhotos: [],
        certificatePhotos: [],
        reportedBy: _authService.currentUser?.displayName ?? 'Unknown',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        wardId: _selectedWard.value.isNotEmpty ? _selectedWard.value : 'ward-1',
        wardName: _selectedWard.value.isNotEmpty
            ? _selectedWard.value
            : 'Ward 1',
        cost: costController.text.isNotEmpty
            ? double.tryParse(costController.text)
            : null,
        sideEffects: sideEffectsController.text.isNotEmpty
            ? sideEffectsController.text
            : null,
      );

      // Add to the list (in real implementation, save to backend)
      _allVaccinations.add(vaccination);
      updateSearchQuery(''); // Refresh filters

      Get.back();
      Get.snackbar(
        'Success',
        'Vaccination record saved successfully',
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Clear form
      _clearForm();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save vaccination: $e',
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void _clearForm() {
    animalIdController.clear();
    breedController.clear();
    colorController.clear();
    weightController.clear();
    batchNumberController.clear();
    vaccinationDateController.clear();
    nextDueDateController.clear();
    addressController.clear();
    veterinarianNameController.clear();
    veterinarianLicenseController.clear();
    notesController.clear();
    costController.clear();
    sideEffectsController.clear();

    selectedSpecies.value = null;
    selectedSex.value = null;
    selectedAge.value = null;
    selectedSize.value = null;
    selectedVaccinationStatus.value = null;
    selectedVaccinationDate.value = null;
    selectedNextDueDate.value = null;
    currentLocation.value = null;
  }

  @override
  void onClose() {
    animalIdController.dispose();
    breedController.dispose();
    colorController.dispose();
    weightController.dispose();
    batchNumberController.dispose();
    vaccinationDateController.dispose();
    nextDueDateController.dispose();
    addressController.dispose();
    veterinarianNameController.dispose();
    veterinarianLicenseController.dispose();
    notesController.dispose();
    costController.dispose();
    sideEffectsController.dispose();
    super.onClose();
  }
}
