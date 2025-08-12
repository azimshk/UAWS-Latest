import '../common/location_model.dart';
import '../common/animal_info.dart';
import '../common/photo_model.dart';

class VaccinationModel {
  final String id;
  final String animalId;
  final AnimalInfo animalInfo;
  final LocationModel location;
  final String vaccineType;
  final String batchNumber;
  final DateTime vaccinationDate;
  final DateTime? nextDueDate;
  final String veterinarianName;
  final String veterinarianLicense;
  final VaccinationStatus status;
  final String? notes;
  final List<PhotoModel> beforePhotos;
  final List<PhotoModel> afterPhotos;
  final List<PhotoModel> certificatePhotos;
  final String reportedBy;
  final String? verifiedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String wardId;
  final String wardName;
  final double? cost;
  final String? sideEffects;

  VaccinationModel({
    required this.id,
    required this.animalId,
    required this.animalInfo,
    required this.location,
    required this.vaccineType,
    required this.batchNumber,
    required this.vaccinationDate,
    this.nextDueDate,
    required this.veterinarianName,
    required this.veterinarianLicense,
    required this.status,
    this.notes,
    required this.beforePhotos,
    required this.afterPhotos,
    required this.certificatePhotos,
    required this.reportedBy,
    this.verifiedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.wardId,
    required this.wardName,
    this.cost,
    this.sideEffects,
  });

  factory VaccinationModel.fromJson(Map<String, dynamic> json) {
    return VaccinationModel(
      id: json['id'] ?? '',
      animalId:
          json['tagNumber'] ??
          json['animalId'] ??
          '', // Use tagNumber as animalId for dummy data
      animalInfo: AnimalInfo(
        species: _parseSpecies(json['species'] ?? 'dog'),
        sex: _parseSex(json['sex'] ?? 'unknown'),
        age: _parseAge(json['ageGroup'] ?? 'unknown'),
        color: json['identificationMarks'] ?? '',
        size: AnimalSize.medium, // Default size
        identificationMarks: json['identificationMarks'],
        tagNumber: json['tagNumber'],
        breed: json['breed'] ?? 'Mixed',
        weight: json['weight']?.toDouble(),
        isVaccinated: true, // Since this is a vaccination record
      ),
      location: LocationModel.fromJson(json['location'] ?? {}),
      vaccineType: json['vaccineType'] ?? '',
      batchNumber: json['batchNumber'] ?? '',
      vaccinationDate: DateTime.parse(
        json['vaccinationDate'] ?? DateTime.now().toIso8601String(),
      ),
      nextDueDate: json['nextDueDate'] != null
          ? DateTime.parse(json['nextDueDate'])
          : null,
      veterinarianName: json['veterinarianName'] ?? 'Dr. Unknown',
      veterinarianLicense:
          json['veterinarianLicense'] ?? json['veterinarianId'] ?? '',
      status:
          VaccinationStatus.completed, // Default to completed for dummy data
      notes: json['notes'],
      beforePhotos: [],
      afterPhotos: json['photoURL'] != null
          ? [
              PhotoModel(
                id: '${json['id']}_photo',
                filename: json['photoURL'],
                localPath: '',
                url: json['photoURL'],
                timestamp: DateTime.parse(
                  json['createdAt'] ?? DateTime.now().toIso8601String(),
                ),
                description: 'Vaccination Photo',
                category: 'vaccination',
                isUploaded: true,
              ),
            ]
          : [],
      certificatePhotos: [],
      reportedBy: json['createdBy'] ?? '',
      verifiedBy: json['verifiedBy'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ??
            json['createdAt'] ??
            DateTime.now().toIso8601String(),
      ),
      wardId: json['wardId'] ?? json['ward'] ?? '',
      wardName: json['wardName'] ?? json['ward'] ?? '',
      cost: json['cost']?.toDouble(),
      sideEffects: json['sideEffects'],
    );
  }

  // Helper methods to parse enum values from strings
  static AnimalSpecies _parseSpecies(String value) {
    return AnimalSpecies.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == value.toLowerCase(),
      orElse: () => AnimalSpecies.dog,
    );
  }

  static AnimalSex _parseSex(String value) {
    return AnimalSex.values.firstWhere(
      (e) => e.toString().split('.').last.toLowerCase() == value.toLowerCase(),
      orElse: () => AnimalSex.unknown,
    );
  }

  static AnimalAge _parseAge(String value) {
    switch (value.toLowerCase()) {
      case 'young':
      case 'puppy':
      case 'kitten':
        return AnimalAge.young;
      case 'adult':
        return AnimalAge.adult;
      case 'senior':
        return AnimalAge.senior;
      default:
        return AnimalAge.adult;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'animalId': animalId,
      'animalInfo': animalInfo.toJson(),
      'location': location.toJson(),
      'vaccineType': vaccineType,
      'batchNumber': batchNumber,
      'vaccinationDate': vaccinationDate.toIso8601String(),
      'nextDueDate': nextDueDate?.toIso8601String(),
      'veterinarianName': veterinarianName,
      'veterinarianLicense': veterinarianLicense,
      'status': status.name,
      'notes': notes,
      'beforePhotos': beforePhotos.map((photo) => photo.toJson()).toList(),
      'afterPhotos': afterPhotos.map((photo) => photo.toJson()).toList(),
      'certificatePhotos': certificatePhotos
          .map((photo) => photo.toJson())
          .toList(),
      'reportedBy': reportedBy,
      'verifiedBy': verifiedBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'wardId': wardId,
      'wardName': wardName,
      'cost': cost,
      'sideEffects': sideEffects,
    };
  }

  VaccinationModel copyWith({
    String? id,
    String? animalId,
    AnimalInfo? animalInfo,
    LocationModel? location,
    String? vaccineType,
    String? batchNumber,
    DateTime? vaccinationDate,
    DateTime? nextDueDate,
    String? veterinarianName,
    String? veterinarianLicense,
    VaccinationStatus? status,
    String? notes,
    List<PhotoModel>? beforePhotos,
    List<PhotoModel>? afterPhotos,
    List<PhotoModel>? certificatePhotos,
    String? reportedBy,
    String? verifiedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? wardId,
    String? wardName,
    double? cost,
    String? sideEffects,
  }) {
    return VaccinationModel(
      id: id ?? this.id,
      animalId: animalId ?? this.animalId,
      animalInfo: animalInfo ?? this.animalInfo,
      location: location ?? this.location,
      vaccineType: vaccineType ?? this.vaccineType,
      batchNumber: batchNumber ?? this.batchNumber,
      vaccinationDate: vaccinationDate ?? this.vaccinationDate,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      veterinarianName: veterinarianName ?? this.veterinarianName,
      veterinarianLicense: veterinarianLicense ?? this.veterinarianLicense,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      beforePhotos: beforePhotos ?? this.beforePhotos,
      afterPhotos: afterPhotos ?? this.afterPhotos,
      certificatePhotos: certificatePhotos ?? this.certificatePhotos,
      reportedBy: reportedBy ?? this.reportedBy,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      wardId: wardId ?? this.wardId,
      wardName: wardName ?? this.wardName,
      cost: cost ?? this.cost,
      sideEffects: sideEffects ?? this.sideEffects,
    );
  }

  // Helper methods
  bool get isCompleted => status == VaccinationStatus.completed;
  bool get isScheduled => status == VaccinationStatus.scheduled;
  bool get isInProgress => status == VaccinationStatus.inProgress;
  bool get isCancelled => status == VaccinationStatus.cancelled;
  bool get isPending => status == VaccinationStatus.pending;

  bool get hasBeforePhotos => beforePhotos.isNotEmpty;
  bool get hasAfterPhotos => afterPhotos.isNotEmpty;
  bool get hasCertificatePhotos => certificatePhotos.isNotEmpty;

  String get statusDisplayName {
    switch (status) {
      case VaccinationStatus.scheduled:
        return 'Scheduled';
      case VaccinationStatus.inProgress:
        return 'In Progress';
      case VaccinationStatus.completed:
        return 'Completed';
      case VaccinationStatus.cancelled:
        return 'Cancelled';
      case VaccinationStatus.pending:
        return 'Pending';
    }
  }

  bool get isDueForNextVaccination {
    if (nextDueDate == null) return false;
    return DateTime.now().isAfter(nextDueDate!);
  }

  int get daysUntilNextVaccination {
    if (nextDueDate == null) return -1;
    return nextDueDate!.difference(DateTime.now()).inDays;
  }
}

enum VaccinationStatus { scheduled, inProgress, completed, cancelled, pending }

// Vaccine types enum for consistency
enum VaccineType {
  rabies,
  dhpp, // Distemper, Hepatitis, Parvovirus, Parainfluenza
  parvo,
  distemper,
  hepatitis,
  parainfluenza,
  bordetella,
  lyme,
  feline,
  other,
}

extension VaccineTypeExtension on VaccineType {
  String get displayName {
    switch (this) {
      case VaccineType.rabies:
        return 'Rabies';
      case VaccineType.dhpp:
        return 'DHPP (4-in-1)';
      case VaccineType.parvo:
        return 'Parvovirus';
      case VaccineType.distemper:
        return 'Distemper';
      case VaccineType.hepatitis:
        return 'Hepatitis';
      case VaccineType.parainfluenza:
        return 'Parainfluenza';
      case VaccineType.bordetella:
        return 'Bordetella';
      case VaccineType.lyme:
        return 'Lyme Disease';
      case VaccineType.feline:
        return 'Feline Vaccines';
      case VaccineType.other:
        return 'Other';
    }
  }

  String get description {
    switch (this) {
      case VaccineType.rabies:
        return 'Protection against rabies virus';
      case VaccineType.dhpp:
        return 'Combined vaccine for multiple diseases';
      case VaccineType.parvo:
        return 'Protection against parvovirus';
      case VaccineType.distemper:
        return 'Protection against distemper virus';
      case VaccineType.hepatitis:
        return 'Protection against hepatitis virus';
      case VaccineType.parainfluenza:
        return 'Protection against parainfluenza virus';
      case VaccineType.bordetella:
        return 'Protection against kennel cough';
      case VaccineType.lyme:
        return 'Protection against Lyme disease';
      case VaccineType.feline:
        return 'Vaccines specific to cats';
      case VaccineType.other:
        return 'Other vaccination types';
    }
  }
}
