import '../common/location_model.dart';
import '../common/animal_info.dart';
import '../common/photo_model.dart';

// Enums for quarantine data
enum QuarantineObservationStatus {
  aliveHealthy,
  sick,
  dead,
  escaped,
  notObserved,
}

enum QuarantineLocationType { home, facility, street }

enum QuarantineFinalOutcome {
  released,
  euthanized,
  naturalDeath,
  transferred,
  escaped,
}

enum AppetiteLevel { normal, reduced, loss, increased }

enum BehaviorType { normal, lethargic, aggressive, restless, depressed }

// Daily observation model
class DailyObservation {
  final String id;
  final DateTime date;
  final QuarantineObservationStatus status;
  final String? symptoms;
  final double? temperature;
  final AppetiteLevel appetite;
  final BehaviorType behavior;
  final String? notes;
  final String observedBy;
  final List<PhotoModel> photos;

  DailyObservation({
    required this.id,
    required this.date,
    required this.status,
    this.symptoms,
    this.temperature,
    required this.appetite,
    required this.behavior,
    this.notes,
    required this.observedBy,
    required this.photos,
  });

  factory DailyObservation.fromJson(Map<String, dynamic> json) {
    return DailyObservation(
      id: json['id'] ?? '',
      date: DateTime.parse(json['date']),
      status: _parseObservationStatus(json['status']),
      symptoms: json['symptoms'],
      temperature: json['temperature']?.toDouble(),
      appetite: _parseAppetite(json['appetite']),
      behavior: _parseBehavior(json['behavior']),
      notes: json['notes'],
      observedBy: json['observedBy'] ?? '',
      photos:
          (json['photos'] as List<dynamic>?)
              ?.map((photo) => PhotoModel.fromJson(photo))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'status': status.name,
      'symptoms': symptoms,
      'temperature': temperature,
      'appetite': appetite.name,
      'behavior': behavior.name,
      'notes': notes,
      'observedBy': observedBy,
      'photos': photos.map((photo) => photo.toJson()).toList(),
    };
  }

  static QuarantineObservationStatus _parseObservationStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'alive & healthy':
      case 'alive_healthy':
        return QuarantineObservationStatus.aliveHealthy;
      case 'sick':
        return QuarantineObservationStatus.sick;
      case 'dead':
        return QuarantineObservationStatus.dead;
      case 'escaped':
        return QuarantineObservationStatus.escaped;
      case 'not observed':
      case 'not_observed':
        return QuarantineObservationStatus.notObserved;
      default:
        return QuarantineObservationStatus.aliveHealthy;
    }
  }

  static AppetiteLevel _parseAppetite(String? appetite) {
    switch (appetite?.toLowerCase()) {
      case 'normal':
        return AppetiteLevel.normal;
      case 'reduced':
        return AppetiteLevel.reduced;
      case 'loss':
        return AppetiteLevel.loss;
      case 'increased':
        return AppetiteLevel.increased;
      default:
        return AppetiteLevel.normal;
    }
  }

  static BehaviorType _parseBehavior(String? behavior) {
    switch (behavior?.toLowerCase()) {
      case 'normal':
        return BehaviorType.normal;
      case 'lethargic':
        return BehaviorType.lethargic;
      case 'aggressive':
        return BehaviorType.aggressive;
      case 'restless':
        return BehaviorType.restless;
      case 'depressed':
        return BehaviorType.depressed;
      default:
        return BehaviorType.normal;
    }
  }

  // Helper methods
  String get statusDisplayName {
    switch (status) {
      case QuarantineObservationStatus.aliveHealthy:
        return 'Alive & Healthy';
      case QuarantineObservationStatus.sick:
        return 'Sick';
      case QuarantineObservationStatus.dead:
        return 'Dead';
      case QuarantineObservationStatus.escaped:
        return 'Escaped';
      case QuarantineObservationStatus.notObserved:
        return 'Not Observed';
    }
  }

  String get appetiteDisplayName {
    switch (appetite) {
      case AppetiteLevel.normal:
        return 'Normal';
      case AppetiteLevel.reduced:
        return 'Reduced';
      case AppetiteLevel.loss:
        return 'Loss';
      case AppetiteLevel.increased:
        return 'Increased';
    }
  }

  String get behaviorDisplayName {
    switch (behavior) {
      case BehaviorType.normal:
        return 'Normal';
      case BehaviorType.lethargic:
        return 'Lethargic';
      case BehaviorType.aggressive:
        return 'Aggressive';
      case BehaviorType.restless:
        return 'Restless';
      case BehaviorType.depressed:
        return 'Depressed';
    }
  }
}

// Quarantine location model
class QuarantineLocation {
  final QuarantineLocationType type;
  final String address;
  final LocationModel? gps;

  QuarantineLocation({required this.type, required this.address, this.gps});

  factory QuarantineLocation.fromJson(Map<String, dynamic> json) {
    return QuarantineLocation(
      type: _parseLocationType(json['type']),
      address: json['address'] ?? '',
      gps: json['gps'] != null ? LocationModel.fromJson(json['gps']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type.name, 'address': address, 'gps': gps?.toJson()};
  }

  static QuarantineLocationType _parseLocationType(String? type) {
    switch (type?.toLowerCase()) {
      case 'home':
        return QuarantineLocationType.home;
      case 'facility':
        return QuarantineLocationType.facility;
      case 'street':
        return QuarantineLocationType.street;
      default:
        return QuarantineLocationType.facility;
    }
  }

  String get typeDisplayName {
    switch (type) {
      case QuarantineLocationType.home:
        return 'Home';
      case QuarantineLocationType.facility:
        return 'Facility';
      case QuarantineLocationType.street:
        return 'Street';
    }
  }
}

// Owner details model for quarantine
class QuarantineOwnerDetails {
  final String? name;
  final String? contact;
  final String? address;
  final String? cooperationLevel;

  QuarantineOwnerDetails({
    this.name,
    this.contact,
    this.address,
    this.cooperationLevel,
  });

  factory QuarantineOwnerDetails.fromJson(Map<String, dynamic> json) {
    return QuarantineOwnerDetails(
      name: json['name'],
      contact: json['contact'],
      address: json['address'],
      cooperationLevel: json['cooperationLevel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contact': contact,
      'address': address,
      'cooperationLevel': cooperationLevel,
    };
  }
}

// Main quarantine record model
class QuarantineRecordModel {
  final String id;
  final String? biteCaseId;
  final AnimalInfo animalInfo;
  final DateTime startDate;
  final DateTime endDate;
  final QuarantineObservationStatus observationStatus;
  final QuarantineLocation quarantineLocation;
  final List<DailyObservation> dailyObservations;
  final QuarantineOwnerDetails? ownerDetails;
  final QuarantineFinalOutcome? finalOutcome;
  final String? finalOutcomeNotes;
  final DateTime? finalOutcomeDate;
  final String? notes;
  final DateTime createdAt;
  final String createdBy;
  final DateTime lastUpdated;

  QuarantineRecordModel({
    required this.id,
    this.biteCaseId,
    required this.animalInfo,
    required this.startDate,
    required this.endDate,
    required this.observationStatus,
    required this.quarantineLocation,
    required this.dailyObservations,
    this.ownerDetails,
    this.finalOutcome,
    this.finalOutcomeNotes,
    this.finalOutcomeDate,
    this.notes,
    required this.createdAt,
    required this.createdBy,
    required this.lastUpdated,
  });

  factory QuarantineRecordModel.fromJson(Map<String, dynamic> json) {
    return QuarantineRecordModel(
      id: json['id'] ?? '',
      biteCaseId: json['biteCaseId'],
      animalInfo: AnimalInfo.fromJson(json['animalInfo']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      observationStatus: DailyObservation._parseObservationStatus(
        json['observationStatus'],
      ),
      quarantineLocation: QuarantineLocation.fromJson(
        json['quarantineLocation'],
      ),
      dailyObservations:
          (json['dailyObservations'] as List<dynamic>?)
              ?.map((obs) => DailyObservation.fromJson(obs))
              .toList() ??
          [],
      ownerDetails: json['ownerDetails'] != null
          ? QuarantineOwnerDetails.fromJson(json['ownerDetails'])
          : null,
      finalOutcome: _parseFinalOutcome(json['finalOutcome']),
      finalOutcomeNotes: json['finalOutcomeNotes'],
      finalOutcomeDate: json['finalOutcomeDate'] != null
          ? DateTime.parse(json['finalOutcomeDate'])
          : null,
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: json['createdBy'] ?? '',
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'biteCaseId': biteCaseId,
      'animalInfo': animalInfo.toJson(),
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'observationStatus': observationStatus.name,
      'quarantineLocation': quarantineLocation.toJson(),
      'dailyObservations': dailyObservations
          .map((obs) => obs.toJson())
          .toList(),
      'ownerDetails': ownerDetails?.toJson(),
      'finalOutcome': finalOutcome?.name,
      'finalOutcomeNotes': finalOutcomeNotes,
      'finalOutcomeDate': finalOutcomeDate?.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  static QuarantineFinalOutcome? _parseFinalOutcome(String? outcome) {
    if (outcome == null) return null;

    switch (outcome.toLowerCase()) {
      case 'released':
        return QuarantineFinalOutcome.released;
      case 'euthanized':
        return QuarantineFinalOutcome.euthanized;
      case 'natural death':
      case 'naturaldeath':
        return QuarantineFinalOutcome.naturalDeath;
      case 'transferred':
        return QuarantineFinalOutcome.transferred;
      case 'escaped':
        return QuarantineFinalOutcome.escaped;
      default:
        return null;
    }
  }

  // Helper methods
  String get observationStatusDisplayName {
    switch (observationStatus) {
      case QuarantineObservationStatus.aliveHealthy:
        return 'Alive & Healthy';
      case QuarantineObservationStatus.sick:
        return 'Sick';
      case QuarantineObservationStatus.dead:
        return 'Dead';
      case QuarantineObservationStatus.escaped:
        return 'Escaped';
      case QuarantineObservationStatus.notObserved:
        return 'Not Observed';
    }
  }

  String? get finalOutcomeDisplayName {
    if (finalOutcome == null) return null;

    switch (finalOutcome!) {
      case QuarantineFinalOutcome.released:
        return 'Released';
      case QuarantineFinalOutcome.euthanized:
        return 'Euthanized';
      case QuarantineFinalOutcome.naturalDeath:
        return 'Natural Death';
      case QuarantineFinalOutcome.transferred:
        return 'Transferred';
      case QuarantineFinalOutcome.escaped:
        return 'Escaped';
    }
  }

  // Get current day in observation period (1-10)
  int get currentObservationDay {
    final now = DateTime.now();
    if (now.isBefore(startDate)) return 0;
    if (now.isAfter(endDate)) return 10;

    return now.difference(startDate).inDays + 1;
  }

  // Check if observation period is complete
  bool get isObservationComplete {
    return DateTime.now().isAfter(endDate) || finalOutcome != null;
  }

  // Get observation for specific day
  DailyObservation? getObservationForDay(int day) {
    try {
      return dailyObservations.firstWhere(
        (obs) => obs.date.difference(startDate).inDays + 1 == day,
      );
    } catch (e) {
      return null;
    }
  }

  // Get latest observation
  DailyObservation? get latestObservation {
    if (dailyObservations.isEmpty) return null;

    return dailyObservations.reduce(
      (current, next) => current.date.isAfter(next.date) ? current : next,
    );
  }

  // Check if animal needs urgent attention
  bool get needsUrgentAttention {
    final latest = latestObservation;
    if (latest == null) return false;

    return latest.status == QuarantineObservationStatus.sick ||
        latest.status == QuarantineObservationStatus.dead ||
        latest.behavior == BehaviorType.aggressive;
  }
}
