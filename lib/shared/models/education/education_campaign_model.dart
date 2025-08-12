import '../common/location_model.dart';

// Enums for education campaign data
enum CampaignType {
  schoolVisit,
  workshop,
  streetPlay,
  hoarding,
  onlinePoster,
  radioAd,
  others,
}

// Materials used model
class MaterialsUsed {
  final bool video;
  final bool pdf;
  final bool hoardingPhotos;
  final bool audio;
  final String? others;

  MaterialsUsed({
    required this.video,
    required this.pdf,
    required this.hoardingPhotos,
    required this.audio,
    this.others,
  });

  factory MaterialsUsed.fromJson(Map<String, dynamic> json) {
    return MaterialsUsed(
      video: json['video'] ?? false,
      pdf: json['pdf'] ?? false,
      hoardingPhotos: json['hoardingPhotos'] ?? false,
      audio: json['audio'] ?? false,
      others: json['others'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'video': video,
      'pdf': pdf,
      'hoardingPhotos': hoardingPhotos,
      'audio': audio,
      'others': others,
    };
  }

  // Get list of materials used
  List<String> get usedMaterials {
    final materials = <String>[];
    if (video) materials.add('Video');
    if (pdf) materials.add('PDF');
    if (hoardingPhotos) materials.add('Hoarding Photos');
    if (audio) materials.add('Audio');
    if (others != null && others!.isNotEmpty) materials.add(others!);
    return materials;
  }
}

// Conducted by model
class ConductedBy {
  final String ngoName;
  final String? partnerName;
  final String? staffId;

  ConductedBy({required this.ngoName, this.partnerName, this.staffId});

  factory ConductedBy.fromJson(Map<String, dynamic> json) {
    return ConductedBy(
      ngoName: json['ngoName'] ?? '',
      partnerName: json['partnerName'],
      staffId: json['staffId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'ngoName': ngoName, 'partnerName': partnerName, 'staffId': staffId};
  }
}

// Main education campaign model
class EducationCampaignModel {
  final String id;
  final CampaignType campaignType;
  final LocationModel location;
  final DateTime eventDate;
  final MaterialsUsed materialsUsed;
  final int participantsReached;
  final List<String> photosProofs;
  final ConductedBy conductedBy;
  final String? description;
  final String? outcome;
  final String? notes;
  final double? budget;
  final String? targetAudience;
  final List<String>? keyTopics;
  final String? feedback;
  final int? rating; // 1-5 scale
  final DateTime createdAt;
  final String createdBy;
  final DateTime lastUpdated;

  EducationCampaignModel({
    required this.id,
    required this.campaignType,
    required this.location,
    required this.eventDate,
    required this.materialsUsed,
    required this.participantsReached,
    required this.photosProofs,
    required this.conductedBy,
    this.description,
    this.outcome,
    this.notes,
    this.budget,
    this.targetAudience,
    this.keyTopics,
    this.feedback,
    this.rating,
    required this.createdAt,
    required this.createdBy,
    required this.lastUpdated,
  });

  factory EducationCampaignModel.fromJson(Map<String, dynamic> json) {
    return EducationCampaignModel(
      id: json['id'] ?? '',
      campaignType: _parseCampaignType(json['campaignType']),
      location: LocationModel.fromJson(json['location']),
      eventDate: DateTime.parse(json['eventDate']),
      materialsUsed: MaterialsUsed.fromJson(json['materialsUsed']),
      participantsReached: json['participantsReached'] ?? 0,
      photosProofs: List<String>.from(json['photosProofs'] ?? []),
      conductedBy: ConductedBy.fromJson(json['conductedBy']),
      description: json['description'],
      outcome: json['outcome'],
      notes: json['notes'],
      budget: json['budget']?.toDouble(),
      targetAudience: json['targetAudience'],
      keyTopics: json['keyTopics'] != null
          ? List<String>.from(json['keyTopics'])
          : null,
      feedback: json['feedback'],
      rating: json['rating'],
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
      'campaignType': campaignType.name,
      'location': location.toJson(),
      'eventDate': eventDate.toIso8601String(),
      'materialsUsed': materialsUsed.toJson(),
      'participantsReached': participantsReached,
      'photosProofs': photosProofs,
      'conductedBy': conductedBy.toJson(),
      'description': description,
      'outcome': outcome,
      'notes': notes,
      'budget': budget,
      'targetAudience': targetAudience,
      'keyTopics': keyTopics,
      'feedback': feedback,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  static CampaignType _parseCampaignType(String? type) {
    switch (type?.toLowerCase()) {
      case 'school visit':
      case 'schoolvisit':
        return CampaignType.schoolVisit;
      case 'workshop':
        return CampaignType.workshop;
      case 'street play':
      case 'streetplay':
        return CampaignType.streetPlay;
      case 'hoarding':
        return CampaignType.hoarding;
      case 'online poster':
      case 'onlineposter':
        return CampaignType.onlinePoster;
      case 'radio ad':
      case 'radioad':
        return CampaignType.radioAd;
      case 'others':
        return CampaignType.others;
      default:
        return CampaignType.others;
    }
  }

  // Helper methods
  String get campaignTypeDisplayName {
    switch (campaignType) {
      case CampaignType.schoolVisit:
        return 'School Visit';
      case CampaignType.workshop:
        return 'Workshop';
      case CampaignType.streetPlay:
        return 'Street Play';
      case CampaignType.hoarding:
        return 'Hoarding';
      case CampaignType.onlinePoster:
        return 'Online Poster';
      case CampaignType.radioAd:
        return 'Radio Ad';
      case CampaignType.others:
        return 'Others';
    }
  }

  // Get campaign effectiveness score (0-100)
  int get effectivenessScore {
    int score = 0;

    // Base score from participants reached
    if (participantsReached > 100) {
      score += 30;
    } else if (participantsReached > 50) {
      score += 20;
    } else if (participantsReached > 20) {
      score += 10;
    }

    // Materials used variety
    final materialsCount = materialsUsed.usedMaterials.length;
    score += materialsCount * 5;

    // Rating if available
    if (rating != null) {
      score += rating! * 10;
    }

    // Photos as proof
    if (photosProofs.isNotEmpty) {
      score += 15;
    }

    // Outcome provided
    if (outcome != null && outcome!.isNotEmpty) {
      score += 10;
    }

    return score > 100 ? 100 : score;
  }

  // Check if campaign is recent (within last 30 days)
  bool get isRecent {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return eventDate.isAfter(thirtyDaysAgo);
  }

  // Get cost per participant if budget is available
  double? get costPerParticipant {
    if (budget == null || participantsReached == 0) return null;
    return budget! / participantsReached;
  }

  // Get campaign duration in hours (assuming full day if not specified)
  Duration get estimatedDuration {
    switch (campaignType) {
      case CampaignType.schoolVisit:
        return const Duration(hours: 2);
      case CampaignType.workshop:
        return const Duration(hours: 4);
      case CampaignType.streetPlay:
        return const Duration(hours: 1);
      case CampaignType.hoarding:
        return const Duration(minutes: 30); // Installation time
      case CampaignType.onlinePoster:
        return const Duration(minutes: 15); // Upload time
      case CampaignType.radioAd:
        return const Duration(minutes: 5); // Ad duration
      case CampaignType.others:
        return const Duration(hours: 2); // Default
    }
  }

  // Get impact level based on participants and materials
  String get impactLevel {
    final score = effectivenessScore;
    if (score >= 80) return 'High Impact';
    if (score >= 60) return 'Medium Impact';
    if (score >= 40) return 'Low Impact';
    return 'Minimal Impact';
  }

  // Check if documentation is complete
  bool get isDocumentationComplete {
    return photosProofs.isNotEmpty &&
        description != null &&
        description!.isNotEmpty &&
        outcome != null &&
        outcome!.isNotEmpty;
  }

  // Get summary for reports
  String get campaignSummary {
    return '$campaignTypeDisplayName in ${location.ward} - '
        '$participantsReached participants reached. '
        '$impactLevel.';
  }
}
