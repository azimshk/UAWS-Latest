import '../common/location_model.dart';
import '../common/animal_info.dart';
import '../common/photo_model.dart';

// Enums for rabies case data
enum RabiesSuspicionLevel { low, medium, high }

enum RabiesTestResult { positive, negative, pending, inconclusive }

enum RabiesOutcomeStatus {
  underObservation,
  deceased,
  euthanized,
  released,
  escaped,
}

enum RabiesTestMethod {
  dfa, // Direct Fluorescent Antibody
  rt, // Rabies Test
  histopathology,
  immunohistochemistry,
  other,
}

// Clinical signs model
class ClinicalSigns {
  final List<String> behavioral;
  final List<String> neurological;
  final List<String> physical;
  final String? onset;
  final String? progression;

  ClinicalSigns({
    required this.behavioral,
    required this.neurological,
    required this.physical,
    this.onset,
    this.progression,
  });

  factory ClinicalSigns.fromJson(Map<String, dynamic> json) {
    return ClinicalSigns(
      behavioral: List<String>.from(json['behavioral'] ?? []),
      neurological: List<String>.from(json['neurological'] ?? []),
      physical: List<String>.from(json['physical'] ?? []),
      onset: json['onset'],
      progression: json['progression'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'behavioral': behavioral,
      'neurological': neurological,
      'physical': physical,
      'onset': onset,
      'progression': progression,
    };
  }

  // Get all clinical signs as a flat list
  List<String> get allSigns {
    return [...behavioral, ...neurological, ...physical];
  }

  // Check if any concerning signs are present
  bool get hasConcerningSigns {
    final concerningSigns = [
      'aggression',
      'excessive salivation',
      'paralysis',
      'seizures',
      'disorientation',
      'hydrophobia',
    ];

    return allSigns.any(
      (sign) => concerningSigns.any(
        (concerning) => sign.toLowerCase().contains(concerning.toLowerCase()),
      ),
    );
  }
}

// Lab sample model
class LabSample {
  final String sampleType;
  final DateTime collectionDate;
  final String labName;
  final RabiesTestMethod testMethod;
  final RabiesTestResult result;
  final DateTime? resultDate;
  final String? labReportNumber;
  final String? notes;

  LabSample({
    required this.sampleType,
    required this.collectionDate,
    required this.labName,
    required this.testMethod,
    required this.result,
    this.resultDate,
    this.labReportNumber,
    this.notes,
  });

  factory LabSample.fromJson(Map<String, dynamic> json) {
    return LabSample(
      sampleType: json['sampleType'] ?? '',
      collectionDate: DateTime.parse(json['collectionDate']),
      labName: json['labName'] ?? '',
      testMethod: _parseTestMethod(json['testMethod']),
      result: _parseTestResult(json['result']),
      resultDate: json['resultDate'] != null
          ? DateTime.parse(json['resultDate'])
          : null,
      labReportNumber: json['labReportNumber'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sampleType': sampleType,
      'collectionDate': collectionDate.toIso8601String(),
      'labName': labName,
      'testMethod': testMethod.name,
      'result': result.name,
      'resultDate': resultDate?.toIso8601String(),
      'labReportNumber': labReportNumber,
      'notes': notes,
    };
  }

  static RabiesTestMethod _parseTestMethod(String? method) {
    switch (method?.toLowerCase()) {
      case 'dfa':
        return RabiesTestMethod.dfa;
      case 'rt':
        return RabiesTestMethod.rt;
      case 'histopathology':
        return RabiesTestMethod.histopathology;
      case 'immunohistochemistry':
        return RabiesTestMethod.immunohistochemistry;
      default:
        return RabiesTestMethod.other;
    }
  }

  static RabiesTestResult _parseTestResult(String? result) {
    switch (result?.toLowerCase()) {
      case 'positive':
        return RabiesTestResult.positive;
      case 'negative':
        return RabiesTestResult.negative;
      case 'pending':
        return RabiesTestResult.pending;
      case 'inconclusive':
        return RabiesTestResult.inconclusive;
      default:
        return RabiesTestResult.pending;
    }
  }

  // Helper methods
  String get testMethodDisplayName {
    switch (testMethod) {
      case RabiesTestMethod.dfa:
        return 'Direct Fluorescent Antibody (DFA)';
      case RabiesTestMethod.rt:
        return 'Rabies Test (RT)';
      case RabiesTestMethod.histopathology:
        return 'Histopathology';
      case RabiesTestMethod.immunohistochemistry:
        return 'Immunohistochemistry';
      case RabiesTestMethod.other:
        return 'Other';
    }
  }

  String get resultDisplayName {
    switch (result) {
      case RabiesTestResult.positive:
        return 'Positive';
      case RabiesTestResult.negative:
        return 'Negative';
      case RabiesTestResult.pending:
        return 'Pending';
      case RabiesTestResult.inconclusive:
        return 'Inconclusive';
    }
  }
}

// Outcome model
class RabiesOutcome {
  final RabiesOutcomeStatus status;
  final DateTime date;
  final String? cause;
  final bool postMortemDone;
  final String? postMortemDetails;
  final String? disposalMethod;

  RabiesOutcome({
    required this.status,
    required this.date,
    this.cause,
    required this.postMortemDone,
    this.postMortemDetails,
    this.disposalMethod,
  });

  factory RabiesOutcome.fromJson(Map<String, dynamic> json) {
    return RabiesOutcome(
      status: _parseOutcomeStatus(json['status']),
      date: DateTime.parse(json['date']),
      cause: json['cause'],
      postMortemDone: json['postMortemDone'] ?? false,
      postMortemDetails: json['postMortemDetails'],
      disposalMethod: json['disposalMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'date': date.toIso8601String(),
      'cause': cause,
      'postMortemDone': postMortemDone,
      'postMortemDetails': postMortemDetails,
      'disposalMethod': disposalMethod,
    };
  }

  static RabiesOutcomeStatus _parseOutcomeStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'under observation':
      case 'underobservation':
        return RabiesOutcomeStatus.underObservation;
      case 'deceased':
        return RabiesOutcomeStatus.deceased;
      case 'euthanized':
        return RabiesOutcomeStatus.euthanized;
      case 'released':
        return RabiesOutcomeStatus.released;
      case 'escaped':
        return RabiesOutcomeStatus.escaped;
      default:
        return RabiesOutcomeStatus.underObservation;
    }
  }

  String get statusDisplayName {
    switch (status) {
      case RabiesOutcomeStatus.underObservation:
        return 'Under Observation';
      case RabiesOutcomeStatus.deceased:
        return 'Deceased';
      case RabiesOutcomeStatus.euthanized:
        return 'Euthanized';
      case RabiesOutcomeStatus.released:
        return 'Released';
      case RabiesOutcomeStatus.escaped:
        return 'Escaped';
    }
  }
}

// Public health measures model
class PublicHealthMeasures {
  final bool areaDisinfection;
  final bool contactTracing;
  final bool exposureAssessment;
  final bool communityAlert;
  final bool massVaccination;
  final bool quarantineArea;

  PublicHealthMeasures({
    required this.areaDisinfection,
    required this.contactTracing,
    required this.exposureAssessment,
    required this.communityAlert,
    required this.massVaccination,
    required this.quarantineArea,
  });

  factory PublicHealthMeasures.fromJson(Map<String, dynamic> json) {
    return PublicHealthMeasures(
      areaDisinfection: json['areaDisinfection'] ?? false,
      contactTracing: json['contactTracing'] ?? false,
      exposureAssessment: json['exposureAssessment'] ?? false,
      communityAlert: json['communityAlert'] ?? false,
      massVaccination: json['massVaccination'] ?? false,
      quarantineArea: json['quarantineArea'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'areaDisinfection': areaDisinfection,
      'contactTracing': contactTracing,
      'exposureAssessment': exposureAssessment,
      'communityAlert': communityAlert,
      'massVaccination': massVaccination,
      'quarantineArea': quarantineArea,
    };
  }

  // Get list of implemented measures
  List<String> get implementedMeasures {
    final measures = <String>[];
    if (areaDisinfection) measures.add('Area Disinfection');
    if (contactTracing) measures.add('Contact Tracing');
    if (exposureAssessment) measures.add('Exposure Assessment');
    if (communityAlert) measures.add('Community Alert');
    if (massVaccination) measures.add('Mass Vaccination');
    if (quarantineArea) measures.add('Quarantine Area');
    return measures;
  }

  // Calculate response score (0-100)
  int get responseScore {
    int score = 0;
    if (areaDisinfection) score += 15;
    if (contactTracing) score += 20;
    if (exposureAssessment) score += 20;
    if (communityAlert) score += 15;
    if (massVaccination) score += 15;
    if (quarantineArea) score += 15;
    return score;
  }
}

// Main rabies case model
class RabiesCaseModel {
  final String id;
  final String? relatedBiteCaseId;
  final String? relatedQuarantineId;
  final DateTime reportDate;
  final RabiesSuspicionLevel suspicionLevel;
  final AnimalInfo animalInfo;
  final LocationModel location;
  final ClinicalSigns clinicalSigns;
  final List<LabSample> labSamples;
  final RabiesOutcome outcome;
  final PublicHealthMeasures publicHealthMeasures;
  final String? reportedBy;
  final String? verifiedBy;
  final String? notes;
  final List<PhotoModel> photos;
  final List<String> videos;
  final DateTime? firstSeenDate;
  final bool sampleSent;
  final String? finalLabResult;
  final DateTime createdAt;
  final String createdBy;
  final DateTime lastUpdated;

  RabiesCaseModel({
    required this.id,
    this.relatedBiteCaseId,
    this.relatedQuarantineId,
    required this.reportDate,
    required this.suspicionLevel,
    required this.animalInfo,
    required this.location,
    required this.clinicalSigns,
    required this.labSamples,
    required this.outcome,
    required this.publicHealthMeasures,
    this.reportedBy,
    this.verifiedBy,
    this.notes,
    required this.photos,
    required this.videos,
    this.firstSeenDate,
    required this.sampleSent,
    this.finalLabResult,
    required this.createdAt,
    required this.createdBy,
    required this.lastUpdated,
  });

  factory RabiesCaseModel.fromJson(Map<String, dynamic> json) {
    return RabiesCaseModel(
      id: json['id'] ?? '',
      relatedBiteCaseId: json['relatedBiteCaseId'],
      relatedQuarantineId: json['relatedQuarantineId'],
      reportDate: DateTime.parse(json['reportDate']),
      suspicionLevel: _parseSuspicionLevel(json['suspicionLevel']),
      animalInfo: AnimalInfo.fromJson(json['animalInfo']),
      location: LocationModel.fromJson(json['location']),
      clinicalSigns: ClinicalSigns.fromJson(json['clinicalSigns']),
      labSamples:
          (json['labSamples'] as List<dynamic>?)
              ?.map((sample) => LabSample.fromJson(sample))
              .toList() ??
          [],
      outcome: RabiesOutcome.fromJson(json['outcome']),
      publicHealthMeasures: PublicHealthMeasures.fromJson(
        json['publicHealthMeasures'],
      ),
      reportedBy: json['reportedBy'],
      verifiedBy: json['verifiedBy'],
      notes: json['notes'],
      photos:
          (json['photos'] as List<dynamic>?)
              ?.map((photo) => PhotoModel.fromJson(photo))
              .toList() ??
          [],
      videos: List<String>.from(json['videos'] ?? []),
      firstSeenDate: json['firstSeenDate'] != null
          ? DateTime.parse(json['firstSeenDate'])
          : null,
      sampleSent: json['sampleSent'] ?? false,
      finalLabResult: json['finalLabResult'],
      createdAt: DateTime.parse(json['createdAt']),
      createdBy: json['createdBy'] ?? '',
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'relatedBiteCaseId': relatedBiteCaseId,
      'relatedQuarantineId': relatedQuarantineId,
      'reportDate': reportDate.toIso8601String(),
      'suspicionLevel': suspicionLevel.name,
      'animalInfo': animalInfo.toJson(),
      'location': location.toJson(),
      'clinicalSigns': clinicalSigns.toJson(),
      'labSamples': labSamples.map((sample) => sample.toJson()).toList(),
      'outcome': outcome.toJson(),
      'publicHealthMeasures': publicHealthMeasures.toJson(),
      'reportedBy': reportedBy,
      'verifiedBy': verifiedBy,
      'notes': notes,
      'photos': photos.map((photo) => photo.toJson()).toList(),
      'videos': videos,
      'firstSeenDate': firstSeenDate?.toIso8601String(),
      'sampleSent': sampleSent,
      'finalLabResult': finalLabResult,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  static RabiesSuspicionLevel _parseSuspicionLevel(String? level) {
    switch (level?.toLowerCase()) {
      case 'low':
        return RabiesSuspicionLevel.low;
      case 'medium':
        return RabiesSuspicionLevel.medium;
      case 'high':
        return RabiesSuspicionLevel.high;
      default:
        return RabiesSuspicionLevel.low;
    }
  }

  // Helper methods
  String get suspicionLevelDisplayName {
    switch (suspicionLevel) {
      case RabiesSuspicionLevel.low:
        return 'Low';
      case RabiesSuspicionLevel.medium:
        return 'Medium';
      case RabiesSuspicionLevel.high:
        return 'High';
    }
  }

  // Get latest lab result
  LabSample? get latestLabSample {
    if (labSamples.isEmpty) return null;

    return labSamples.reduce(
      (current, next) =>
          current.collectionDate.isAfter(next.collectionDate) ? current : next,
    );
  }

  // Check if case is confirmed positive
  bool get isConfirmedPositive {
    return labSamples.any(
          (sample) => sample.result == RabiesTestResult.positive,
        ) ||
        finalLabResult?.toLowerCase() == 'positive';
  }

  // Check if case needs urgent attention
  bool get needsUrgentAttention {
    return suspicionLevel == RabiesSuspicionLevel.high ||
        clinicalSigns.hasConcerningSigns ||
        isConfirmedPositive;
  }

  // Calculate risk score (0-100)
  int get riskScore {
    int score = 0;

    // Suspicion level
    switch (suspicionLevel) {
      case RabiesSuspicionLevel.low:
        score += 20;
        break;
      case RabiesSuspicionLevel.medium:
        score += 50;
        break;
      case RabiesSuspicionLevel.high:
        score += 80;
        break;
    }

    // Clinical signs
    if (clinicalSigns.hasConcerningSigns) score += 20;

    // Lab results
    if (isConfirmedPositive) score = 100;

    return score > 100 ? 100 : score;
  }

  // Get case status summary
  String get statusSummary {
    if (isConfirmedPositive) return 'Confirmed Positive';
    if (needsUrgentAttention) return 'High Risk - Urgent';
    if (sampleSent &&
        labSamples.any((s) => s.result == RabiesTestResult.pending)) {
      return 'Lab Results Pending';
    }
    return 'Under Surveillance';
  }

  // Check if documentation is complete
  bool get isDocumentationComplete {
    return photos.isNotEmpty &&
        notes != null &&
        notes!.isNotEmpty &&
        sampleSent &&
        labSamples.isNotEmpty;
  }
}
