import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../core/utils/app_logger.dart';
import '../../../shared/models/models.dart';

class VaccinationService {
  static List<VaccinationModel>? _vaccinations;

  // Load vaccination data from JSON
  static Future<void> loadVaccinationData() async {
    if (_vaccinations != null) return; // Already loaded

    try {
      final String response = await rootBundle.loadString(
        'dummyData/vaccinations.json',
      );
      final List<dynamic> data = json.decode(response);

      _vaccinations = data
          .map((json) => VaccinationModel.fromJson(json))
          .toList();

      AppLogger.i('Loaded ${_vaccinations!.length} vaccination records');
    } catch (e) {
      AppLogger.e('Error loading vaccination data: $e');
      _vaccinations = _generateDummyVaccinations();
    }
  }

  // Get all vaccinations
  static Future<List<VaccinationModel>> getAllVaccinations() async {
    await loadVaccinationData();
    return List.from(_vaccinations!);
  }

  // Get vaccinations by status
  static Future<List<VaccinationModel>> getVaccinationsByStatus(
    VaccinationStatus status,
  ) async {
    await loadVaccinationData();
    return _vaccinations!
        .where((vaccination) => vaccination.status == status)
        .toList();
  }

  // Get vaccinations by animal ID
  static Future<List<VaccinationModel>> getVaccinationsByAnimalId(
    String animalId,
  ) async {
    await loadVaccinationData();
    return _vaccinations!
        .where((vaccination) => vaccination.animalId == animalId)
        .toList();
  }

  // Get vaccinations by ward
  static Future<List<VaccinationModel>> getVaccinationsByWard(
    String wardId,
  ) async {
    await loadVaccinationData();
    return _vaccinations!
        .where((vaccination) => vaccination.wardId == wardId)
        .toList();
  }

  // Get vaccinations by date range
  static Future<List<VaccinationModel>> getVaccinationsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    await loadVaccinationData();
    return _vaccinations!.where((vaccination) {
      return vaccination.vaccinationDate.isAfter(startDate) &&
          vaccination.vaccinationDate.isBefore(endDate);
    }).toList();
  }

  // Get vaccinations by vaccine type
  static Future<List<VaccinationModel>> getVaccinationsByVaccineType(
    String vaccineType,
  ) async {
    await loadVaccinationData();
    return _vaccinations!
        .where((vaccination) => vaccination.vaccineType == vaccineType)
        .toList();
  }

  // Get overdue vaccinations
  static Future<List<VaccinationModel>> getOverdueVaccinations() async {
    await loadVaccinationData();
    final now = DateTime.now();
    return _vaccinations!.where((vaccination) {
      return vaccination.nextDueDate != null &&
          vaccination.nextDueDate!.isBefore(now) &&
          vaccination.status != VaccinationStatus.completed;
    }).toList();
  }

  // Get upcoming vaccinations (due in next 30 days)
  static Future<List<VaccinationModel>> getUpcomingVaccinations() async {
    await loadVaccinationData();
    final now = DateTime.now();
    final futureDate = now.add(const Duration(days: 30));

    return _vaccinations!.where((vaccination) {
      return vaccination.nextDueDate != null &&
          vaccination.nextDueDate!.isAfter(now) &&
          vaccination.nextDueDate!.isBefore(futureDate) &&
          vaccination.status != VaccinationStatus.completed;
    }).toList();
  }

  // Get vaccination by ID
  static Future<VaccinationModel?> getVaccinationById(String id) async {
    await loadVaccinationData();
    try {
      return _vaccinations!.firstWhere((vaccination) => vaccination.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add new vaccination
  static Future<bool> addVaccination(VaccinationModel vaccination) async {
    await loadVaccinationData();

    try {
      _vaccinations!.add(vaccination);
      AppLogger.i('Added new vaccination: ${vaccination.id}');
      return true;
    } catch (e) {
      AppLogger.e('Error adding vaccination: $e');
      return false;
    }
  }

  // Update vaccination
  static Future<bool> updateVaccination(
    VaccinationModel updatedVaccination,
  ) async {
    await loadVaccinationData();

    try {
      final index = _vaccinations!.indexWhere(
        (vaccination) => vaccination.id == updatedVaccination.id,
      );
      if (index != -1) {
        _vaccinations![index] = updatedVaccination;
        AppLogger.i('Updated vaccination: ${updatedVaccination.id}');
        return true;
      } else {
        AppLogger.w(
          'Vaccination not found for update: ${updatedVaccination.id}',
        );
        return false;
      }
    } catch (e) {
      AppLogger.e('Error updating vaccination: $e');
      return false;
    }
  }

  // Delete vaccination
  static Future<bool> deleteVaccination(String id) async {
    await loadVaccinationData();

    try {
      _vaccinations!.removeWhere((vaccination) => vaccination.id == id);
      AppLogger.i('Deleted vaccination: $id');
      return true;
    } catch (e) {
      AppLogger.e('Error deleting vaccination: $e');
      return false;
    }
  }

  // Search vaccinations
  static Future<List<VaccinationModel>> searchVaccinations(String query) async {
    await loadVaccinationData();

    if (query.isEmpty) return List.from(_vaccinations!);

    final searchQuery = query.toLowerCase();
    return _vaccinations!.where((vaccination) {
      return vaccination.animalId.toLowerCase().contains(searchQuery) ||
          vaccination.animalInfo.species.name.toLowerCase().contains(
            searchQuery,
          ) ||
          vaccination.vaccineType.toLowerCase().contains(searchQuery) ||
          vaccination.veterinarianName.toLowerCase().contains(searchQuery) ||
          vaccination.wardName.toLowerCase().contains(searchQuery) ||
          (vaccination.location.address?.toLowerCase().contains(searchQuery) ??
              false);
    }).toList();
  }

  // Get vaccination statistics
  static Future<Map<String, int>> getVaccinationStatistics() async {
    await loadVaccinationData();

    final stats = <String, int>{};
    stats['total'] = _vaccinations!.length;
    stats['completed'] = _vaccinations!
        .where((v) => v.status == VaccinationStatus.completed)
        .length;
    stats['scheduled'] = _vaccinations!
        .where((v) => v.status == VaccinationStatus.scheduled)
        .length;
    stats['inProgress'] = _vaccinations!
        .where((v) => v.status == VaccinationStatus.inProgress)
        .length;
    stats['cancelled'] = _vaccinations!
        .where((v) => v.status == VaccinationStatus.cancelled)
        .length;
    stats['pending'] = _vaccinations!
        .where((v) => v.status == VaccinationStatus.pending)
        .length;
    stats['overdue'] = (await getOverdueVaccinations()).length;
    stats['upcoming'] = (await getUpcomingVaccinations()).length;

    return stats;
  }

  // Generate dummy data if JSON loading fails
  static List<VaccinationModel> _generateDummyVaccinations() {
    AppLogger.i('Generating dummy vaccination data');

    final List<VaccinationModel> dummyVaccinations = [];
    final now = DateTime.now();

    // Create 50 dummy vaccination records
    for (int i = 1; i <= 50; i++) {
      final vaccination = VaccinationModel(
        id: 'vacc_$i',
        animalId: 'animal_$i',
        animalInfo: AnimalInfo(
          species: i % 2 == 0 ? AnimalSpecies.dog : AnimalSpecies.cat,
          sex: i % 2 == 0 ? AnimalSex.male : AnimalSex.female,
          age: AnimalAge.adult,
          color: i % 3 == 0
              ? 'Brown'
              : i % 3 == 1
              ? 'Black'
              : 'White',
          size: i % 2 == 0 ? AnimalSize.medium : AnimalSize.small,
          breed: i % 2 == 0 ? 'Indian Pariah' : 'Indian Cat',
          weight: (5 + (i % 20)).toDouble(),
          microchipNumber: 'MC${1000 + i}',
          healthCondition: 'Healthy',
          isPregnant: false,
          isVaccinated: true,
        ),
        location: LocationModel(
          lat: 18.5204 + (i * 0.001),
          lng: 73.8567 + (i * 0.001),
          address:
              'Ward ${(i % 15) + 1}, Area ${String.fromCharCode(65 + (i % 26))}, Pune',
          ward: 'Ward ${(i % 15) + 1}',
          zone: 'Zone ${String.fromCharCode(65 + (i % 5))}',
        ),
        vaccineType: _getVaccineTypeForIndex(i),
        batchNumber: 'BATCH${2024}${(i % 100).toString().padLeft(2, '0')}',
        vaccinationDate: now.subtract(Duration(days: i * 2)),
        nextDueDate: now.add(
          Duration(days: (365 - (i * 2))),
        ), // Next vaccination due
        veterinarianName: 'Dr. ${_getVeterinarianName(i)}',
        veterinarianLicense: 'VET${(10000 + i).toString()}',
        status: _getStatusForIndex(i),
        notes: i % 3 == 0 ? 'Animal was cooperative during vaccination' : null,
        beforePhotos: i % 4 == 0
            ? [
                PhotoModel(
                  id: 'before_$i',
                  filename: 'before_vaccination_$i.jpg',
                  localPath: 'assets/images/vaccination/before_$i.jpg',
                  url: 'assets/images/vaccination/before_$i.jpg',
                  description: 'Before vaccination photo',
                  category: 'before_vaccination',
                  timestamp: now.subtract(Duration(days: i * 2, hours: 1)),
                ),
              ]
            : [],
        afterPhotos: i % 3 == 0
            ? [
                PhotoModel(
                  id: 'after_$i',
                  filename: 'after_vaccination_$i.jpg',
                  localPath: 'assets/images/vaccination/after_$i.jpg',
                  url: 'assets/images/vaccination/after_$i.jpg',
                  description: 'After vaccination photo',
                  category: 'after_vaccination',
                  timestamp: now.subtract(Duration(days: i * 2)),
                ),
              ]
            : [],
        certificatePhotos: i % 2 == 0
            ? [
                PhotoModel(
                  id: 'cert_$i',
                  filename: 'vaccination_certificate_$i.jpg',
                  localPath: 'assets/images/vaccination/certificate_$i.jpg',
                  url: 'assets/images/vaccination/certificate_$i.jpg',
                  description: 'Vaccination certificate',
                  category: 'certificate',
                  timestamp: now.subtract(Duration(days: i * 2)),
                ),
              ]
            : [],
        reportedBy: 'field_user_${(i % 10) + 1}',
        verifiedBy: i % 3 == 0 ? 'supervisor_${(i % 5) + 1}' : null,
        createdAt: now.subtract(Duration(days: i * 2, hours: 2)),
        updatedAt: now.subtract(Duration(days: i * 2)),
        wardId: 'ward_${(i % 15) + 1}',
        wardName: 'Ward ${(i % 15) + 1}',
        cost: (500 + (i % 300)).toDouble(),
        sideEffects: i % 10 == 0 ? 'Mild lethargy for 24 hours' : null,
      );

      dummyVaccinations.add(vaccination);
    }

    return dummyVaccinations;
  }

  static String _getVaccineTypeForIndex(int index) {
    final types = [
      'Rabies',
      'DHPP',
      'Parvovirus',
      'Distemper',
      'Hepatitis',
      'Feline',
    ];
    return types[index % types.length];
  }

  static String _getVeterinarianName(int index) {
    final names = [
      'Sharma',
      'Patel',
      'Kumar',
      'Singh',
      'Gupta',
      'Mehta',
      'Shah',
      'Joshi',
    ];
    return names[index % names.length];
  }

  static VaccinationStatus _getStatusForIndex(int index) {
    final statuses = VaccinationStatus.values;
    return statuses[index % statuses.length];
  }

  // Refresh data (for pull-to-refresh functionality)
  static Future<void> refreshData() async {
    _vaccinations = null;
    await loadVaccinationData();
  }
}
