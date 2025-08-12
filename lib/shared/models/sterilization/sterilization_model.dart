import '../common/location_model.dart';
import '../common/animal_info.dart';

// Enum for sterilization stages
enum SterilizationStage { pickup, operation, release }

// Enum for operation status
enum OperationStatus { operated, notOperated, postponed }

// Enum for release status
enum ReleaseStatus { released, death, postponed }

// Pickup stage model
class PickupStage {
  final DateTime dateTime;
  final String? photoURL;
  final LocationModel gps;
  final String pickedBy;

  PickupStage({
    required this.dateTime,
    this.photoURL,
    required this.gps,
    required this.pickedBy,
  });

  factory PickupStage.fromJson(Map<String, dynamic> json) {
    return PickupStage(
      dateTime: DateTime.parse(json['dateTime']),
      photoURL: json['photoURL'],
      gps: LocationModel.fromJson(json['gps']),
      pickedBy: json['pickedBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'photoURL': photoURL,
      'gps': gps.toJson(),
      'pickedBy': pickedBy,
    };
  }

  // Backward compatibility
  bool get isCompleted => true; // Pickup is always completed if record exists
  String get staffName => pickedBy;
  String get staffId =>
      pickedBy; // Assuming staff ID is same as name for backward compatibility
}

// Complications model
class Complications {
  final bool exists;
  final String? remarks;

  Complications({required this.exists, this.remarks});

  factory Complications.fromJson(Map<String, dynamic> json) {
    return Complications(
      exists: json['exists'] ?? false,
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'exists': exists, 'remarks': remarks};
  }
}

// Operation stage model
class OperationStage {
  final OperationStatus status;
  final DateTime? date;
  final String? surgeonId;
  final String? photoURL;
  final Complications complications;

  OperationStage({
    this.status = OperationStatus.notOperated,
    this.date,
    this.surgeonId,
    this.photoURL,
    Complications? complications,
  }) : complications = complications ?? Complications(exists: false);

  // Named constructor for completed operation
  OperationStage.completed({
    required this.date,
    required this.surgeonId,
    this.photoURL,
    Complications? complications,
  }) : status = OperationStatus.operated,
       complications = complications ?? Complications(exists: false);

  factory OperationStage.fromJson(Map<String, dynamic> json) {
    return OperationStage(
      status: _parseOperationStatus(json['status']),
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      surgeonId: json['surgeonId'],
      photoURL: json['photoURL'],
      complications: Complications.fromJson(
        json['complications'] ?? {'exists': false},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'date': date?.toIso8601String(),
      'surgeonId': surgeonId,
      'photoURL': photoURL,
      'complications': complications.toJson(),
    };
  }

  static OperationStatus _parseOperationStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'operated':
        return OperationStatus.operated;
      case 'not operated':
      case 'notOperated':
        return OperationStatus.notOperated;
      case 'postponed':
        return OperationStatus.postponed;
      default:
        return OperationStatus.notOperated;
    }
  }

  String get statusDisplayName {
    switch (status) {
      case OperationStatus.operated:
        return 'Operated';
      case OperationStatus.notOperated:
        return 'Not Operated';
      case OperationStatus.postponed:
        return 'Postponed';
    }
  }

  // Backward compatibility
  bool get isCompleted => status == OperationStatus.operated;
  String? get veterinarianName => surgeonId;
  String? get veterinarianId => surgeonId;
}

// Release stage model
class ReleaseStage {
  final DateTime? date;
  final String? releasedBy;
  final String? photoURL;
  final ReleaseStatus status;
  final String? notes;
  final LocationModel? gps;

  ReleaseStage({
    this.date,
    this.releasedBy,
    this.photoURL,
    this.status = ReleaseStatus.postponed,
    this.notes,
    this.gps,
  });

  // Named constructor for completed release
  ReleaseStage.completed({
    required this.date,
    required this.releasedBy,
    this.photoURL,
    this.notes,
    this.gps,
  }) : status = ReleaseStatus.released;

  factory ReleaseStage.fromJson(Map<String, dynamic> json) {
    return ReleaseStage(
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      releasedBy: json['releasedBy'],
      photoURL: json['photoURL'],
      status: _parseReleaseStatus(json['status']),
      notes: json['notes'],
      gps: json['gps'] != null ? LocationModel.fromJson(json['gps']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date?.toIso8601String(),
      'releasedBy': releasedBy,
      'photoURL': photoURL,
      'status': status.name,
      'notes': notes,
      'gps': gps?.toJson(),
    };
  }

  static ReleaseStatus _parseReleaseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'released':
        return ReleaseStatus.released;
      case 'death':
        return ReleaseStatus.death;
      case 'postponed':
        return ReleaseStatus.postponed;
      default:
        return ReleaseStatus.postponed;
    }
  }

  String get statusDisplayName {
    switch (status) {
      case ReleaseStatus.released:
        return 'Released';
      case ReleaseStatus.death:
        return 'Death';
      case ReleaseStatus.postponed:
        return 'Postponed';
    }
  }

  // Backward compatibility
  bool get isCompleted => status == ReleaseStatus.released;
  String? get staffName => releasedBy;
  String? get staffId => releasedBy;
}

// Main sterilization model
class SterilizationModel {
  final String id;
  final String species;
  final String sex;
  final String ageGroup;
  final String ward;
  final String? zone;
  final String tagNumber;
  final String? cageNumber;
  final String? identificationMarks;
  final PickupStage pickup;
  final OperationStage? operation;
  final ReleaseStage? release;
  final DateTime createdAt;
  final String createdBy;

  SterilizationModel({
    required this.id,
    required this.species,
    required this.sex,
    required this.ageGroup,
    required this.ward,
    this.zone,
    required this.tagNumber,
    this.cageNumber,
    this.identificationMarks,
    required this.pickup,
    this.operation,
    this.release,
    required this.createdAt,
    required this.createdBy,
  });

  // Alternative constructor for backward compatibility
  SterilizationModel.withAnimalInfo({
    String? id,
    required AnimalInfo animalInfo,
    required PickupStage pickupStage,
    OperationStage? operationStage,
    ReleaseStage? releaseStage,
    SterilizationStage? currentStage, // ignored, computed
    DateTime? createdAt,
    DateTime? updatedAt, // ignored, not stored
    required this.createdBy,
    String? ward,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       species = animalInfo.species.name,
       sex = animalInfo.sex.name,
       ageGroup = animalInfo.age.name,
       ward = ward ?? 'Unknown',
       zone = null,
       tagNumber = animalInfo.tagNumber ?? '',
       cageNumber = animalInfo.cageNumber,
       identificationMarks = animalInfo.identificationMarks,
       pickup = pickupStage,
       operation = operationStage,
       release = releaseStage,
       createdAt = createdAt ?? DateTime.now();

  factory SterilizationModel.fromJson(Map<String, dynamic> json) {
    return SterilizationModel(
      id: json['id'] ?? '',
      species: json['species'] ?? '',
      sex: json['sex'] ?? '',
      ageGroup: json['ageGroup'] ?? '',
      ward: json['ward'] ?? '',
      zone: json['zone'],
      tagNumber: json['tagNumber'] ?? '',
      cageNumber: json['cageNumber'],
      identificationMarks: json['identificationMarks'],
      pickup: PickupStage.fromJson(json['pickup']),
      operation: json['operation'] != null
          ? OperationStage.fromJson(json['operation'])
          : null,
      release: json['release'] != null
          ? ReleaseStage.fromJson(json['release'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: json['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'species': species,
      'sex': sex,
      'ageGroup': ageGroup,
      'ward': ward,
      'zone': zone,
      'tagNumber': tagNumber,
      'cageNumber': cageNumber,
      'identificationMarks': identificationMarks,
      'pickup': pickup.toJson(),
      'operation': operation?.toJson(),
      'release': release?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }

  // Backward compatibility getters
  PickupStage get pickupStage => pickup;
  OperationStage? get operationStage => operation;
  ReleaseStage? get releaseStage => release;

  // Helper methods
  SterilizationStage get currentStage {
    if (release != null) return SterilizationStage.release;
    if (operation != null) return SterilizationStage.operation;
    return SterilizationStage.pickup;
  }

  bool get isCompleted {
    return release != null && release!.status == ReleaseStatus.released;
  }

  // Backward compatibility for stage completion checks
  bool get isPickupCompleted =>
      true; // Pickup always completed if record exists
  bool get isOperationCompleted =>
      operation?.status == OperationStatus.operated;
  bool get isReleaseCompleted => release?.status == ReleaseStatus.released;
  bool get isFullyCompleted => isCompleted;

  // Completion percentage (0.0 - 1.0)
  double get completionPercentage {
    if (release != null) return 1.0;
    if (operation != null) return 0.66;
    return 0.33;
  }

  // Status description for UI
  String get statusDescription {
    return statusSummary;
  }

  bool get hasComplications {
    return operation?.complications.exists ?? false;
  }

  String get statusSummary {
    if (isCompleted) return 'Completed - Released';
    if (release?.status == ReleaseStatus.death) return 'Death During Care';
    if (operation?.status == OperationStatus.operated) {
      return 'Post-Operation Care';
    }
    if (operation?.status == OperationStatus.notOperated) {
      return 'Operation Pending';
    }
    return 'Pickup Completed';
  }

  Duration? get totalCareTime {
    if (release?.date == null) return null;
    return release!.date!.difference(pickup.dateTime);
  }

  // Get animal info from sterilization data
  AnimalInfo get animalInfo {
    return AnimalInfo(
      species: _parseSpecies(species),
      sex: _parseSex(sex),
      age: _parseAge(ageGroup),
      color: identificationMarks ?? '',
      size: AnimalSize.medium, // Default
      identificationMarks: identificationMarks,
      tagNumber: tagNumber,
      cageNumber: cageNumber,
    );
  }

  // Helper methods for parsing
  static AnimalSpecies _parseSpecies(String? value) {
    if (value == null) return AnimalSpecies.other;

    final stringValue = value.toString().toLowerCase();
    switch (stringValue) {
      case 'dog':
        return AnimalSpecies.dog;
      case 'cat':
        return AnimalSpecies.cat;
      default:
        return AnimalSpecies.other;
    }
  }

  static AnimalSex _parseSex(String? value) {
    if (value == null) return AnimalSex.unknown;

    final stringValue = value.toString().toLowerCase();
    switch (stringValue) {
      case 'male':
        return AnimalSex.male;
      case 'female':
        return AnimalSex.female;
      default:
        return AnimalSex.unknown;
    }
  }

  static AnimalAge _parseAge(String? value) {
    if (value == null) return AnimalAge.unknown;

    final stringValue = value.toString().toLowerCase();
    if (stringValue.contains('puppy') || stringValue.contains('kitten')) {
      return AnimalAge.puppy;
    } else if (stringValue.contains('young')) {
      return AnimalAge.young;
    } else if (stringValue.contains('adult')) {
      return AnimalAge.adult;
    } else if (stringValue.contains('senior')) {
      return AnimalAge.senior;
    }

    return AnimalAge.unknown;
  }

  // Check if ready for next stage
  bool get canProceedToOperation {
    return operation == null && pickup.dateTime.isBefore(DateTime.now());
  }

  bool get canProceedToRelease {
    return operation?.status == OperationStatus.operated && release == null;
  }

  // Get progress percentage (0-100)
  int get progressPercentage {
    if (release != null) return 100;
    if (operation != null) return 66;
    return 33;
  }

  // Copy with method for immutable updates
  SterilizationModel copyWith({
    String? id,
    String? species,
    String? sex,
    String? ageGroup,
    String? ward,
    String? zone,
    String? tagNumber,
    String? cageNumber,
    String? identificationMarks,
    PickupStage? pickup,
    PickupStage? pickupStage,
    OperationStage? operation,
    OperationStage? operationStage,
    ReleaseStage? release,
    ReleaseStage? releaseStage,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    SterilizationStage? currentStage,
    AnimalInfo? animalInfo,
  }) {
    return SterilizationModel(
      id: id ?? this.id,
      species: species ?? this.species,
      sex: sex ?? this.sex,
      ageGroup: ageGroup ?? this.ageGroup,
      ward: ward ?? this.ward,
      zone: zone ?? this.zone,
      tagNumber: tagNumber ?? this.tagNumber,
      cageNumber: cageNumber ?? this.cageNumber,
      identificationMarks: identificationMarks ?? this.identificationMarks,
      pickup: pickupStage ?? pickup ?? this.pickup,
      operation: operationStage ?? operation ?? this.operation,
      release: releaseStage ?? release ?? this.release,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
