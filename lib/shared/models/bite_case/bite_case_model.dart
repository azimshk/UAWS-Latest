import '../common/location_model.dart';
import '../common/photo_model.dart';

// Enums for bite case data
enum BiteCaseSource { public, pmc, online }

enum BiteCaseSeverity { minor, major, severe }

enum BiteCaseStatus { open, underInvestigation, closed, referred }

enum BiteCasePriority { low, medium, high, critical }

enum AnimalOwnershipStatus { owned, stray, unknown }

enum AnimalVaccinationStatus { vaccinated, notVaccinated, unknown }

enum AnimalBehavior { friendly, aggressive, fearful, normal, unknown }

// Victim details model
class VictimDetails {
  final String name;
  final int age;
  final String gender;
  final String contact;
  final String address;

  VictimDetails({
    required this.name,
    required this.age,
    required this.gender,
    required this.contact,
    required this.address,
  });

  factory VictimDetails.fromJson(Map<String, dynamic> json) {
    return VictimDetails(
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      contact: json['contact'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'contact': contact,
      'address': address,
    };
  }
}

// Animal details for bite case
class BiteCaseAnimalDetails {
  final String species;
  final String sex;
  final String size;
  final String color;
  final AnimalBehavior behavior;
  final AnimalOwnershipStatus ownershipStatus;
  final AnimalVaccinationStatus vaccinationStatus;
  final String? ownerDetails;

  BiteCaseAnimalDetails({
    required this.species,
    required this.sex,
    required this.size,
    required this.color,
    required this.behavior,
    required this.ownershipStatus,
    required this.vaccinationStatus,
    this.ownerDetails,
  });

  factory BiteCaseAnimalDetails.fromJson(Map<String, dynamic> json) {
    return BiteCaseAnimalDetails(
      species: json['species'] ?? '',
      sex: json['sex'] ?? '',
      size: json['size'] ?? '',
      color: json['color'] ?? '',
      behavior: _parseBehavior(json['behavior']),
      ownershipStatus: _parseOwnershipStatus(json['ownershipStatus']),
      vaccinationStatus: _parseVaccinationStatus(json['vaccinationStatus']),
      ownerDetails: json['ownerDetails'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'species': species,
      'sex': sex,
      'size': size,
      'color': color,
      'behavior': behavior.name,
      'ownershipStatus': ownershipStatus.name,
      'vaccinationStatus': vaccinationStatus.name,
      'ownerDetails': ownerDetails,
    };
  }

  static AnimalBehavior _parseBehavior(String? behavior) {
    switch (behavior?.toLowerCase()) {
      case 'friendly':
        return AnimalBehavior.friendly;
      case 'aggressive':
        return AnimalBehavior.aggressive;
      case 'fearful':
        return AnimalBehavior.fearful;
      case 'normal':
        return AnimalBehavior.normal;
      default:
        return AnimalBehavior.unknown;
    }
  }

  static AnimalOwnershipStatus _parseOwnershipStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'owned':
        return AnimalOwnershipStatus.owned;
      case 'stray':
        return AnimalOwnershipStatus.stray;
      default:
        return AnimalOwnershipStatus.unknown;
    }
  }

  static AnimalVaccinationStatus _parseVaccinationStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'vaccinated':
        return AnimalVaccinationStatus.vaccinated;
      case 'not vaccinated':
      case 'notVaccinated':
        return AnimalVaccinationStatus.notVaccinated;
      default:
        return AnimalVaccinationStatus.unknown;
    }
  }
}

// Incident details model
class IncidentDetails {
  final String bodyPart;
  final BiteCaseSeverity severity;
  final String circumstances;
  final List<String> witnesses;

  IncidentDetails({
    required this.bodyPart,
    required this.severity,
    required this.circumstances,
    required this.witnesses,
  });

  factory IncidentDetails.fromJson(Map<String, dynamic> json) {
    return IncidentDetails(
      bodyPart: json['bodyPart'] ?? '',
      severity: _parseSeverity(json['severity']),
      circumstances: json['circumstances'] ?? '',
      witnesses: List<String>.from(json['witnesses'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bodyPart': bodyPart,
      'severity': severity.name,
      'circumstances': circumstances,
      'witnesses': witnesses,
    };
  }

  static BiteCaseSeverity _parseSeverity(String? severity) {
    switch (severity?.toLowerCase()) {
      case 'minor':
        return BiteCaseSeverity.minor;
      case 'major':
        return BiteCaseSeverity.major;
      case 'severe':
        return BiteCaseSeverity.severe;
      default:
        return BiteCaseSeverity.minor;
    }
  }
}

// Medical details model
class MedicalDetails {
  final bool firstAidGiven;
  final bool hospitalVisit;
  final String? hospitalName;
  final String? doctorName;
  final String? treatmentReceived;
  final String antiRabiesVaccineStatus;
  final DateTime? treatmentDate;
  final bool followUpRequired;
  final DateTime? nextAppointment;

  MedicalDetails({
    required this.firstAidGiven,
    required this.hospitalVisit,
    this.hospitalName,
    this.doctorName,
    this.treatmentReceived,
    required this.antiRabiesVaccineStatus,
    this.treatmentDate,
    required this.followUpRequired,
    this.nextAppointment,
  });

  factory MedicalDetails.fromJson(Map<String, dynamic> json) {
    return MedicalDetails(
      firstAidGiven: json['firstAidGiven'] ?? false,
      hospitalVisit: json['hospitalVisit'] ?? false,
      hospitalName: json['hospitalName'],
      doctorName: json['doctorName'],
      treatmentReceived: json['treatmentReceived'],
      antiRabiesVaccineStatus: json['antiRabiesVaccineStatus'] ?? '',
      treatmentDate: json['treatmentDate'] != null
          ? DateTime.parse(json['treatmentDate'])
          : null,
      followUpRequired: json['followUpRequired'] ?? false,
      nextAppointment: json['nextAppointment'] != null
          ? DateTime.parse(json['nextAppointment'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstAidGiven': firstAidGiven,
      'hospitalVisit': hospitalVisit,
      'hospitalName': hospitalName,
      'doctorName': doctorName,
      'treatmentReceived': treatmentReceived,
      'antiRabiesVaccineStatus': antiRabiesVaccineStatus,
      'treatmentDate': treatmentDate?.toIso8601String(),
      'followUpRequired': followUpRequired,
      'nextAppointment': nextAppointment?.toIso8601String(),
    };
  }
}

// Quarantine reference model
class QuarantineReference {
  final bool quarantineRequired;
  final String? quarantineId;

  QuarantineReference({required this.quarantineRequired, this.quarantineId});

  factory QuarantineReference.fromJson(Map<String, dynamic> json) {
    return QuarantineReference(
      quarantineRequired: json['quarantineRequired'] ?? false,
      quarantineId: json['quarantineId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quarantineRequired': quarantineRequired,
      'quarantineId': quarantineId,
    };
  }
}

// Main bite case model
class BiteCaseModel {
  final String id;
  final DateTime reportedDate;
  final DateTime incidentDate;
  final BiteCaseSource source;
  final LocationModel location;
  final VictimDetails victimDetails;
  final BiteCaseAnimalDetails animalDetails;
  final IncidentDetails incidentDetails;
  final MedicalDetails medicalDetails;
  final QuarantineReference quarantine;
  final String investigationStatus;
  final String? assignedOfficer;
  final BiteCasePriority priority;
  final BiteCaseStatus status;
  final String? notes;
  final List<PhotoModel> photos;
  final DateTime createdAt;
  final String createdBy;
  final DateTime lastUpdated;

  BiteCaseModel({
    required this.id,
    required this.reportedDate,
    required this.incidentDate,
    required this.source,
    required this.location,
    required this.victimDetails,
    required this.animalDetails,
    required this.incidentDetails,
    required this.medicalDetails,
    required this.quarantine,
    required this.investigationStatus,
    this.assignedOfficer,
    required this.priority,
    required this.status,
    this.notes,
    required this.photos,
    required this.createdAt,
    required this.createdBy,
    required this.lastUpdated,
  });

  factory BiteCaseModel.fromJson(Map<String, dynamic> json) {
    return BiteCaseModel(
      id: json['id'] ?? '',
      reportedDate: DateTime.parse(json['reportedDate']),
      incidentDate: DateTime.parse(json['incidentDate']),
      source: _parseSource(json['source']),
      location: LocationModel.fromJson(json['location']),
      victimDetails: VictimDetails.fromJson(json['victimDetails']),
      animalDetails: BiteCaseAnimalDetails.fromJson(json['animalDetails']),
      incidentDetails: IncidentDetails.fromJson(json['incidentDetails']),
      medicalDetails: MedicalDetails.fromJson(json['medicalDetails']),
      quarantine: QuarantineReference.fromJson(json['quarantine']),
      investigationStatus: json['investigationStatus'] ?? '',
      assignedOfficer: json['assignedOfficer'],
      priority: _parsePriority(json['priority']),
      status: _parseStatus(json['status']),
      notes: json['notes'],
      photos:
          (json['photos'] as List<dynamic>?)
              ?.map((photo) => PhotoModel.fromJson(photo))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: json['createdBy'] ?? '',
      lastUpdated: DateTime.parse(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reportedDate': reportedDate.toIso8601String(),
      'incidentDate': incidentDate.toIso8601String(),
      'source': source.name,
      'location': location.toJson(),
      'victimDetails': victimDetails.toJson(),
      'animalDetails': animalDetails.toJson(),
      'incidentDetails': incidentDetails.toJson(),
      'medicalDetails': medicalDetails.toJson(),
      'quarantine': quarantine.toJson(),
      'investigationStatus': investigationStatus,
      'assignedOfficer': assignedOfficer,
      'priority': priority.name,
      'status': status.name,
      'notes': notes,
      'photos': photos.map((photo) => photo.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  static BiteCaseSource _parseSource(String? source) {
    switch (source?.toLowerCase()) {
      case 'public':
        return BiteCaseSource.public;
      case 'pmc':
        return BiteCaseSource.pmc;
      case 'online':
        return BiteCaseSource.online;
      default:
        return BiteCaseSource.public;
    }
  }

  static BiteCasePriority _parsePriority(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'low':
        return BiteCasePriority.low;
      case 'medium':
        return BiteCasePriority.medium;
      case 'high':
        return BiteCasePriority.high;
      case 'critical':
        return BiteCasePriority.critical;
      default:
        return BiteCasePriority.medium;
    }
  }

  static BiteCaseStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'open':
        return BiteCaseStatus.open;
      case 'under investigation':
        return BiteCaseStatus.underInvestigation;
      case 'closed':
        return BiteCaseStatus.closed;
      case 'referred':
        return BiteCaseStatus.referred;
      default:
        return BiteCaseStatus.open;
    }
  }

  // Helper methods
  String get priorityDisplayName {
    switch (priority) {
      case BiteCasePriority.low:
        return 'Low';
      case BiteCasePriority.medium:
        return 'Medium';
      case BiteCasePriority.high:
        return 'High';
      case BiteCasePriority.critical:
        return 'Critical';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case BiteCaseStatus.open:
        return 'Open';
      case BiteCaseStatus.underInvestigation:
        return 'Under Investigation';
      case BiteCaseStatus.closed:
        return 'Closed';
      case BiteCaseStatus.referred:
        return 'Referred';
    }
  }

  String get sourceDisplayName {
    switch (source) {
      case BiteCaseSource.public:
        return 'Public';
      case BiteCaseSource.pmc:
        return 'PMC';
      case BiteCaseSource.online:
        return 'Online';
    }
  }
}
