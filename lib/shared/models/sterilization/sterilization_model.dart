import '../common/location_model.dart';
import '../common/animal_info.dart';

// Enum for sterilization stages
enum SterilizationStage { pickup, operation, release }

// Pickup stage model
class PickupStage {
  final DateTime timestamp;
  final String staffId;
  final String staffName;
  final LocationModel location;
  final List<String> photos;
  final String? notes;
  final bool isCompleted;

  PickupStage({
    required this.timestamp,
    required this.staffId,
    required this.staffName,
    required this.location,
    required this.photos,
    this.notes,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'staffId': staffId,
      'staffName': staffName,
      'location': location.toJson(),
      'photos': photos,
      'notes': notes,
      'isCompleted': isCompleted,
    };
  }

  factory PickupStage.fromJson(Map<String, dynamic> json) {
    return PickupStage(
      timestamp: DateTime.parse(json['timestamp']),
      staffId: json['staffId'],
      staffName: json['staffName'],
      location: LocationModel.fromJson(json['location']),
      photos: List<String>.from(json['photos'] ?? []),
      notes: json['notes'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

// Operation stage model
class OperationStage {
  final DateTime? timestamp;
  final String? veterinarianId;
  final String? veterinarianName;
  final String? procedureType;
  final String? operationNotes;
  final String? complications;
  final String? medicationGiven;
  final String? postOpCondition;
  final List<String> photos;
  final bool isCompleted;

  OperationStage({
    this.timestamp,
    this.veterinarianId,
    this.veterinarianName,
    this.procedureType,
    this.operationNotes,
    this.complications,
    this.medicationGiven,
    this.postOpCondition,
    this.photos = const [],
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp?.toIso8601String(),
      'veterinarianId': veterinarianId,
      'veterinarianName': veterinarianName,
      'procedureType': procedureType,
      'operationNotes': operationNotes,
      'complications': complications,
      'medicationGiven': medicationGiven,
      'postOpCondition': postOpCondition,
      'photos': photos,
      'isCompleted': isCompleted,
    };
  }

  factory OperationStage.fromJson(Map<String, dynamic> json) {
    return OperationStage(
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
      veterinarianId: json['veterinarianId'],
      veterinarianName: json['veterinarianName'],
      procedureType: json['procedureType'],
      operationNotes: json['operationNotes'],
      complications: json['complications'],
      medicationGiven: json['medicationGiven'],
      postOpCondition: json['postOpCondition'],
      photos: List<String>.from(json['photos'] ?? []),
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

// Release stage model
class ReleaseStage {
  final DateTime? timestamp;
  final String? staffId;
  final String? staffName;
  final LocationModel? location;
  final String? finalHealthStatus;
  final String? releaseNotes;
  final bool requiresFollowUp;
  final DateTime? followUpDate;
  final List<String> photos;
  final bool isCompleted;

  ReleaseStage({
    this.timestamp,
    this.staffId,
    this.staffName,
    this.location,
    this.finalHealthStatus,
    this.releaseNotes,
    this.requiresFollowUp = false,
    this.followUpDate,
    this.photos = const [],
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp?.toIso8601String(),
      'staffId': staffId,
      'staffName': staffName,
      'location': location?.toJson(),
      'finalHealthStatus': finalHealthStatus,
      'releaseNotes': releaseNotes,
      'requiresFollowUp': requiresFollowUp,
      'followUpDate': followUpDate?.toIso8601String(),
      'photos': photos,
      'isCompleted': isCompleted,
    };
  }

  factory ReleaseStage.fromJson(Map<String, dynamic> json) {
    return ReleaseStage(
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
      staffId: json['staffId'],
      staffName: json['staffName'],
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      finalHealthStatus: json['finalHealthStatus'],
      releaseNotes: json['releaseNotes'],
      requiresFollowUp: json['requiresFollowUp'] ?? false,
      followUpDate: json['followUpDate'] != null
          ? DateTime.parse(json['followUpDate'])
          : null,
      photos: List<String>.from(json['photos'] ?? []),
      isCompleted: json['isCompleted'] ?? false,
    );
  }
}

// Main sterilization model
class SterilizationModel {
  final String? id;
  final AnimalInfo animalInfo;
  final PickupStage pickupStage;
  final OperationStage operationStage;
  final ReleaseStage releaseStage;
  final SterilizationStage currentStage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String? updatedBy;
  final Map<String, dynamic>? metadata;

  SterilizationModel({
    this.id,
    required this.animalInfo,
    required this.pickupStage,
    required this.operationStage,
    required this.releaseStage,
    required this.currentStage,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.updatedBy,
    this.metadata,
  });

  // Computed properties
  bool get isPickupCompleted => pickupStage.isCompleted;
  bool get isOperationCompleted => operationStage.isCompleted;
  bool get isReleaseCompleted => releaseStage.isCompleted;
  bool get isFullyCompleted =>
      isPickupCompleted && isOperationCompleted && isReleaseCompleted;

  double get completionPercentage {
    int completedStages = 0;
    if (isPickupCompleted) completedStages++;
    if (isOperationCompleted) completedStages++;
    if (isReleaseCompleted) completedStages++;
    return completedStages / 3.0;
  }

  String get statusDescription {
    if (isFullyCompleted) return 'Completed';
    if (isOperationCompleted) return 'Ready for Release';
    if (isPickupCompleted) return 'Ready for Operation';
    return 'Pending Pickup';
  }

  // Create a copy with updated fields
  SterilizationModel copyWith({
    String? id,
    AnimalInfo? animalInfo,
    PickupStage? pickupStage,
    OperationStage? operationStage,
    ReleaseStage? releaseStage,
    SterilizationStage? currentStage,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
    String? updatedBy,
    Map<String, dynamic>? metadata,
  }) {
    return SterilizationModel(
      id: id ?? this.id,
      animalInfo: animalInfo ?? this.animalInfo,
      pickupStage: pickupStage ?? this.pickupStage,
      operationStage: operationStage ?? this.operationStage,
      releaseStage: releaseStage ?? this.releaseStage,
      currentStage: currentStage ?? this.currentStage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      metadata: metadata ?? this.metadata,
    );
  }

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'animalInfo': animalInfo.toJson(),
      'pickupStage': pickupStage.toJson(),
      'operationStage': operationStage.toJson(),
      'releaseStage': releaseStage.toJson(),
      'currentStage': currentStage.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'metadata': metadata,
    };
  }

  // Create from Firestore document
  factory SterilizationModel.fromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    return SterilizationModel(
      id: id,
      animalInfo: AnimalInfo.fromJson(data['animalInfo']),
      pickupStage: PickupStage.fromJson(data['pickupStage']),
      operationStage: OperationStage.fromJson(data['operationStage']),
      releaseStage: ReleaseStage.fromJson(data['releaseStage']),
      currentStage: SterilizationStage.values.firstWhere(
        (e) => e.name == data['currentStage'],
        orElse: () => SterilizationStage.pickup,
      ),
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
      createdBy: data['createdBy'],
      updatedBy: data['updatedBy'],
      metadata: data['metadata'],
    );
  }

  // Create from JSON (for dummy data)
  factory SterilizationModel.fromJson(Map<String, dynamic> json) {
    return SterilizationModel(
      id: json['id'],
      animalInfo: AnimalInfo.fromJson(json['animalInfo']),
      pickupStage: PickupStage.fromJson(json['pickupStage']),
      operationStage: OperationStage.fromJson(json['operationStage']),
      releaseStage: ReleaseStage.fromJson(json['releaseStage']),
      currentStage: SterilizationStage.values.firstWhere(
        (e) => e.name == json['currentStage'],
        orElse: () => SterilizationStage.pickup,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      metadata: json['metadata'],
    );
  }

  @override
  String toString() {
    return 'SterilizationModel{id: $id, tagNumber: ${animalInfo.tagNumber}, currentStage: $currentStage, completion: ${(completionPercentage * 100).toStringAsFixed(1)}%}';
  }
}
