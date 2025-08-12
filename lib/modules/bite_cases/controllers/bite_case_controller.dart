import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/models/models.dart';
import '../services/bite_case_service.dart';
import '../../auth/services/auth_service.dart';

class BiteCaseController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Observable lists
  final RxList<BiteCaseModel> _allBiteCases = <BiteCaseModel>[].obs;
  final RxList<BiteCaseModel> _filteredBiteCases = <BiteCaseModel>[].obs;

  // Loading states
  final RxBool _isLoading = false.obs;
  final RxBool _isRefreshing = false.obs;

  // Filter states
  final RxString _selectedStatus = ''.obs;
  final RxString _selectedPriority = ''.obs;
  final RxString _selectedWard = ''.obs;
  final RxString _searchQuery = ''.obs;

  // Form key and controllers for add/edit screens
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text controllers - Victim Details
  final TextEditingController victimNameController = TextEditingController();
  final TextEditingController victimAgeController = TextEditingController();
  final TextEditingController victimContactController = TextEditingController();
  final TextEditingController victimAddressController = TextEditingController();

  // Text controllers - Animal Details
  final TextEditingController animalSpeciesController = TextEditingController();
  final TextEditingController animalSexController = TextEditingController();
  final TextEditingController animalSizeController = TextEditingController();
  final TextEditingController animalColorController = TextEditingController();
  final TextEditingController animalOwnerDetailsController =
      TextEditingController();

  // Text controllers - Incident Details
  final TextEditingController bodyPartController = TextEditingController();
  final TextEditingController circumstancesController = TextEditingController();
  final TextEditingController witnessesController = TextEditingController();

  // Text controllers - Medical Details
  final TextEditingController hospitalNameController = TextEditingController();
  final TextEditingController doctorNameController = TextEditingController();
  final TextEditingController treatmentReceivedController =
      TextEditingController();
  final TextEditingController antiRabiesVaccineStatusController =
      TextEditingController();

  // Text controllers - Location and General
  final TextEditingController addressController = TextEditingController();
  final TextEditingController investigationStatusController =
      TextEditingController();
  final TextEditingController assignedOfficerController =
      TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // Form observables - Victim Details
  final Rx<String?> selectedVictimGender = Rx<String?>(null);

  // Form observables - Animal Details
  final Rx<AnimalBehavior?> selectedAnimalBehavior = Rx<AnimalBehavior?>(null);
  final Rx<AnimalOwnershipStatus?> selectedOwnershipStatus =
      Rx<AnimalOwnershipStatus?>(null);
  final Rx<AnimalVaccinationStatus?> selectedVaccinationStatus =
      Rx<AnimalVaccinationStatus?>(null);

  // Form observables - Incident Details
  final Rx<DateTime?> selectedIncidentDate = Rx<DateTime?>(null);
  final Rx<DateTime?> selectedReportedDate = Rx<DateTime?>(null);
  final Rx<BiteCaseSeverity?> selectedSeverity = Rx<BiteCaseSeverity?>(null);

  // Form observables - Medical Details
  final RxBool firstAidGiven = false.obs;
  final RxBool hospitalVisit = false.obs;
  final Rx<DateTime?> selectedTreatmentDate = Rx<DateTime?>(null);
  final RxBool followUpRequired = false.obs;
  final Rx<DateTime?> selectedNextAppointment = Rx<DateTime?>(null);

  // Form observables - Case Management
  final Rx<BiteCaseSource?> selectedSource = Rx<BiteCaseSource?>(null);
  final Rx<BiteCasePriority?> selectedBiteCasePriority = Rx<BiteCasePriority?>(
    null,
  );
  final Rx<BiteCaseStatus?> selectedBiteCaseStatus = Rx<BiteCaseStatus?>(null);
  final Rx<LocationModel?> currentLocation = Rx<LocationModel?>(null);

  // Quarantine observables
  final RxBool quarantineRequired = false.obs;
  final TextEditingController quarantineIdController = TextEditingController();

  // Getters
  List<BiteCaseModel> get allBiteCases => _allBiteCases;
  List<BiteCaseModel> get filteredBiteCases => _filteredBiteCases;
  bool get isLoading => _isLoading.value;
  bool get isRefreshing => _isRefreshing.value;
  String get selectedStatus => _selectedStatus.value;
  String get selectedPriority => _selectedPriority.value;
  String get selectedWard => _selectedWard.value;
  String get searchQuery => _searchQuery.value;

  @override
  void onInit() {
    super.onInit();
    initializeData();
    _setupSearchListener();
  }

  @override
  void onClose() {
    _disposeControllers();
    super.onClose();
  }

  void _disposeControllers() {
    victimNameController.dispose();
    victimAgeController.dispose();
    victimContactController.dispose();
    victimAddressController.dispose();
    animalSpeciesController.dispose();
    animalSexController.dispose();
    animalSizeController.dispose();
    animalColorController.dispose();
    animalOwnerDetailsController.dispose();
    bodyPartController.dispose();
    circumstancesController.dispose();
    witnessesController.dispose();
    hospitalNameController.dispose();
    doctorNameController.dispose();
    treatmentReceivedController.dispose();
    antiRabiesVaccineStatusController.dispose();
    addressController.dispose();
    investigationStatusController.dispose();
    assignedOfficerController.dispose();
    notesController.dispose();
    quarantineIdController.dispose();
  }

  void _setupSearchListener() {
    debounce(
      _searchQuery,
      (query) => _applyFilters(),
      time: const Duration(milliseconds: 300),
    );
  }

  // Initialize data
  Future<void> initializeData() async {
    await loadBiteCases();
  }

  // Load bite cases
  Future<void> loadBiteCases() async {
    try {
      _isLoading(true);
      final biteCases = await BiteCaseService.getAllBiteCases();
      _allBiteCases.assignAll(biteCases);
      _applyFilters();
      AppLogger.i('Loaded ${biteCases.length} bite cases');
    } catch (e) {
      AppLogger.e('Error loading bite cases: $e');
      Get.snackbar(
        'Error',
        'Failed to load bite cases. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading(false);
    }
  }

  // Refresh data
  Future<void> refreshBiteCases() async {
    try {
      _isRefreshing(true);
      BiteCaseService.clearCache();
      await loadBiteCases();
    } catch (e) {
      AppLogger.e('Error refreshing bite cases: $e');
      Get.snackbar(
        'Error',
        'Failed to refresh data. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isRefreshing(false);
    }
  }

  // Apply filters
  void _applyFilters() {
    List<BiteCaseModel> filtered = List.from(_allBiteCases);

    // Apply search filter
    if (_searchQuery.value.isNotEmpty) {
      final query = _searchQuery.value.toLowerCase();
      filtered = filtered.where((biteCase) {
        return biteCase.victimDetails.name.toLowerCase().contains(query) ||
            biteCase.location.address?.toLowerCase().contains(query) == true ||
            biteCase.location.ward?.toLowerCase().contains(query) == true ||
            biteCase.animalDetails.species.toLowerCase().contains(query) ||
            biteCase.id.toLowerCase().contains(query);
      }).toList();
    }

    // Apply status filter
    if (_selectedStatus.value.isNotEmpty) {
      final status = BiteCaseStatus.values.firstWhere(
        (s) => s.name == _selectedStatus.value,
        orElse: () => BiteCaseStatus.open,
      );
      filtered = filtered
          .where((biteCase) => biteCase.status == status)
          .toList();
    }

    // Apply priority filter
    if (_selectedPriority.value.isNotEmpty) {
      final priority = BiteCasePriority.values.firstWhere(
        (p) => p.name == _selectedPriority.value,
        orElse: () => BiteCasePriority.low,
      );
      filtered = filtered
          .where((biteCase) => biteCase.priority == priority)
          .toList();
    }

    // Apply ward filter
    if (_selectedWard.value.isNotEmpty) {
      filtered = filtered
          .where((biteCase) => biteCase.location.ward == _selectedWard.value)
          .toList();
    }

    _filteredBiteCases.assignAll(filtered);
  }

  // Search functionality
  void updateSearchQuery(String query) {
    _searchQuery.value = query;
  }

  // Filter methods
  void updateStatusFilter(String status) {
    _selectedStatus.value = status;
    _applyFilters();
  }

  void updatePriorityFilter(String priority) {
    _selectedPriority.value = priority;
    _applyFilters();
  }

  void updateWardFilter(String ward) {
    _selectedWard.value = ward;
    _applyFilters();
  }

  void clearFilters() {
    _selectedStatus.value = '';
    _selectedPriority.value = '';
    _selectedWard.value = '';
    _searchQuery.value = '';
    _applyFilters();
  }

  // Get bite case by ID
  Future<BiteCaseModel?> getBiteCaseById(String id) async {
    try {
      return await BiteCaseService.getBiteCaseById(id);
    } catch (e) {
      AppLogger.e('Error getting bite case by ID: $e');
      return null;
    }
  }

  // Add bite case
  Future<bool> addBiteCase() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    try {
      final biteCase = _buildBiteCaseFromForm();
      await BiteCaseService.addBiteCase(biteCase);

      Get.snackbar(
        'Success',
        'Bite case reported successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      clearForm();
      await loadBiteCases();
      return true;
    } catch (e) {
      AppLogger.e('Error adding bite case: $e');
      Get.snackbar(
        'Error',
        'An error occurred while reporting the bite case',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  // Update bite case
  Future<bool> updateBiteCase(String id) async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    try {
      final biteCase = _buildBiteCaseFromForm(id: id);
      await BiteCaseService.updateBiteCase(biteCase);

      Get.snackbar(
        'Success',
        'Bite case updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      await loadBiteCases();
      return true;
    } catch (e) {
      AppLogger.e('Error updating bite case: $e');
      Get.snackbar(
        'Error',
        'An error occurred while updating the bite case',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  // Delete bite case
  Future<bool> deleteBiteCase(String id) async {
    try {
      await BiteCaseService.deleteBiteCase(id);

      Get.snackbar(
        'Success',
        'Bite case deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      await loadBiteCases();
      return true;
    } catch (e) {
      AppLogger.e('Error deleting bite case: $e');
      Get.snackbar(
        'Error',
        'An error occurred while deleting the bite case',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  // Build BiteCaseModel from form
  BiteCaseModel _buildBiteCaseFromForm({String? id}) {
    final now = DateTime.now();

    return BiteCaseModel(
      id: id ?? 'bite-${now.millisecondsSinceEpoch}',
      reportedDate: selectedReportedDate.value ?? now,
      incidentDate: selectedIncidentDate.value ?? now,
      source: selectedSource.value ?? BiteCaseSource.public,
      location:
          currentLocation.value ??
          LocationModel(
            lat: 0.0,
            lng: 0.0,
            address: addressController.text,
            ward: _selectedWard.value,
          ),
      victimDetails: VictimDetails(
        name: victimNameController.text,
        age: int.tryParse(victimAgeController.text) ?? 0,
        gender: selectedVictimGender.value ?? '',
        contact: victimContactController.text,
        address: victimAddressController.text,
      ),
      animalDetails: BiteCaseAnimalDetails(
        species: animalSpeciesController.text,
        sex: animalSexController.text,
        size: animalSizeController.text,
        color: animalColorController.text,
        behavior: selectedAnimalBehavior.value ?? AnimalBehavior.unknown,
        ownershipStatus:
            selectedOwnershipStatus.value ?? AnimalOwnershipStatus.unknown,
        vaccinationStatus:
            selectedVaccinationStatus.value ?? AnimalVaccinationStatus.unknown,
        ownerDetails: animalOwnerDetailsController.text.isEmpty
            ? null
            : animalOwnerDetailsController.text,
      ),
      incidentDetails: IncidentDetails(
        bodyPart: bodyPartController.text,
        severity: selectedSeverity.value ?? BiteCaseSeverity.minor,
        circumstances: circumstancesController.text,
        witnesses: witnessesController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
      ),
      medicalDetails: MedicalDetails(
        firstAidGiven: firstAidGiven.value,
        hospitalVisit: hospitalVisit.value,
        hospitalName: hospitalNameController.text.isEmpty
            ? null
            : hospitalNameController.text,
        doctorName: doctorNameController.text.isEmpty
            ? null
            : doctorNameController.text,
        treatmentReceived: treatmentReceivedController.text.isEmpty
            ? null
            : treatmentReceivedController.text,
        antiRabiesVaccineStatus: antiRabiesVaccineStatusController.text,
        treatmentDate: selectedTreatmentDate.value,
        followUpRequired: followUpRequired.value,
        nextAppointment: selectedNextAppointment.value,
      ),
      quarantine: QuarantineReference(
        quarantineRequired: quarantineRequired.value,
        quarantineId: quarantineIdController.text.isEmpty
            ? null
            : quarantineIdController.text,
      ),
      investigationStatus: investigationStatusController.text,
      assignedOfficer: assignedOfficerController.text.isEmpty
          ? null
          : assignedOfficerController.text,
      priority: selectedBiteCasePriority.value ?? BiteCasePriority.medium,
      status: selectedBiteCaseStatus.value ?? BiteCaseStatus.open,
      notes: notesController.text.isEmpty ? null : notesController.text,
      photos: [], // TODO: Add photo handling
      createdAt: now,
      createdBy: _authService.currentUser?.id ?? 'unknown',
      lastUpdated: now,
    );
  }

  // Clear form
  void clearForm() {
    formKey.currentState?.reset();

    // Clear text controllers
    victimNameController.clear();
    victimAgeController.clear();
    victimContactController.clear();
    victimAddressController.clear();
    animalSpeciesController.clear();
    animalSexController.clear();
    animalSizeController.clear();
    animalColorController.clear();
    animalOwnerDetailsController.clear();
    bodyPartController.clear();
    circumstancesController.clear();
    witnessesController.clear();
    hospitalNameController.clear();
    doctorNameController.clear();
    treatmentReceivedController.clear();
    antiRabiesVaccineStatusController.clear();
    addressController.clear();
    investigationStatusController.clear();
    assignedOfficerController.clear();
    notesController.clear();
    quarantineIdController.clear();

    // Clear observables
    selectedVictimGender.value = null;
    selectedOwnershipStatus.value = null;
    selectedVaccinationStatus.value = null;
    selectedAnimalBehavior.value = null;
    selectedIncidentDate.value = null;
    selectedReportedDate.value = null;
    selectedSeverity.value = null;
    firstAidGiven.value = false;
    hospitalVisit.value = false;
    selectedTreatmentDate.value = null;
    followUpRequired.value = false;
    selectedNextAppointment.value = null;
    selectedSource.value = null;
    selectedBiteCasePriority.value = null;
    selectedBiteCaseStatus.value = null;
    currentLocation.value = null;
    quarantineRequired.value = false;
  }

  // Populate form with existing data
  void populateForm(BiteCaseModel biteCase) {
    // Victim details
    victimNameController.text = biteCase.victimDetails.name;
    victimAgeController.text = biteCase.victimDetails.age.toString();
    victimContactController.text = biteCase.victimDetails.contact;
    victimAddressController.text = biteCase.victimDetails.address;
    selectedVictimGender.value = biteCase.victimDetails.gender;

    // Animal details
    animalSpeciesController.text = biteCase.animalDetails.species;
    animalSexController.text = biteCase.animalDetails.sex;
    animalSizeController.text = biteCase.animalDetails.size;
    animalColorController.text = biteCase.animalDetails.color;
    selectedAnimalBehavior.value = biteCase.animalDetails.behavior;
    selectedOwnershipStatus.value = biteCase.animalDetails.ownershipStatus;
    selectedVaccinationStatus.value = biteCase.animalDetails.vaccinationStatus;

    if (biteCase.animalDetails.ownerDetails != null) {
      animalOwnerDetailsController.text = biteCase.animalDetails.ownerDetails!;
    }

    // Incident details
    bodyPartController.text = biteCase.incidentDetails.bodyPart;
    circumstancesController.text = biteCase.incidentDetails.circumstances;
    witnessesController.text = biteCase.incidentDetails.witnesses.join(', ');
    selectedIncidentDate.value = biteCase.incidentDate;
    selectedSeverity.value = biteCase.incidentDetails.severity;

    // Medical details
    firstAidGiven.value = biteCase.medicalDetails.firstAidGiven;
    hospitalVisit.value = biteCase.medicalDetails.hospitalVisit;
    hospitalNameController.text = biteCase.medicalDetails.hospitalName ?? '';
    doctorNameController.text = biteCase.medicalDetails.doctorName ?? '';
    treatmentReceivedController.text =
        biteCase.medicalDetails.treatmentReceived ?? '';
    antiRabiesVaccineStatusController.text =
        biteCase.medicalDetails.antiRabiesVaccineStatus;
    selectedTreatmentDate.value = biteCase.medicalDetails.treatmentDate;
    followUpRequired.value = biteCase.medicalDetails.followUpRequired;
    selectedNextAppointment.value = biteCase.medicalDetails.nextAppointment;

    // Location and general
    addressController.text = biteCase.location.address ?? '';
    investigationStatusController.text = biteCase.investigationStatus;
    assignedOfficerController.text = biteCase.assignedOfficer ?? '';
    notesController.text = biteCase.notes ?? '';

    // Case management
    selectedReportedDate.value = biteCase.reportedDate;
    selectedSource.value = biteCase.source;
    selectedBiteCasePriority.value = biteCase.priority;
    selectedBiteCaseStatus.value = biteCase.status;
    currentLocation.value = biteCase.location;
    _selectedWard.value = biteCase.location.ward ?? '';

    // Quarantine
    quarantineRequired.value = biteCase.quarantine.quarantineRequired;
    quarantineIdController.text = biteCase.quarantine.quarantineId ?? '';
  }

  // Get statistics
  Future<Map<String, int>> getStatistics() async {
    try {
      return await BiteCaseService.getBiteCaseStats();
    } catch (e) {
      AppLogger.e('Error getting statistics: $e');
      return {};
    }
  }

  // Get cases requiring follow-up
  Future<List<BiteCaseModel>> getCasesRequiringFollowUp() async {
    try {
      return await BiteCaseService.getCasesRequiringAttention();
    } catch (e) {
      AppLogger.e('Error getting cases requiring follow-up: $e');
      return [];
    }
  }

  // Get unique wards
  List<String> get availableWards {
    final wards = _allBiteCases
        .map((biteCase) => biteCase.location.ward)
        .where((ward) => ward != null)
        .cast<String>()
        .toSet()
        .toList();
    wards.sort();
    return wards;
  }

  // Get cases by ward for statistics
  Map<String, int> get casesByWard {
    final wardCounts = <String, int>{};
    for (final biteCase in _allBiteCases) {
      final ward = biteCase.location.ward ?? 'Unknown';
      wardCounts[ward] = (wardCounts[ward] ?? 0) + 1;
    }
    return wardCounts;
  }

  // Get priority cases count
  int get highPriorityCasesCount {
    return _allBiteCases
        .where(
          (biteCase) =>
              biteCase.priority == BiteCasePriority.high ||
              biteCase.priority == BiteCasePriority.critical,
        )
        .length;
  }

  // Get active cases count
  int get activeCasesCount {
    return _allBiteCases
        .where((biteCase) => biteCase.status != BiteCaseStatus.closed)
        .length;
  }
}
