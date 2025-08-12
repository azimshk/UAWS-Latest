import '../common/location_model.dart';

// GeoJSON geometry model
class GeoJSONGeometry {
  final String type;
  final List<List<List<double>>> coordinates;

  GeoJSONGeometry({required this.type, required this.coordinates});

  factory GeoJSONGeometry.fromJson(Map<String, dynamic> json) {
    return GeoJSONGeometry(
      type: json['type'] ?? 'Polygon',
      coordinates: (json['coordinates'] as List<dynamic>)
          .map(
            (coord) => (coord as List<dynamic>)
                .map(
                  (innerCoord) => (innerCoord as List<dynamic>)
                      .map((point) => (point as num).toDouble())
                      .toList(),
                )
                .toList(),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates};
  }
}

// Boundary data model for GeoJSON feature
class BoundaryData {
  final String type;
  final Map<String, dynamic> properties;
  final GeoJSONGeometry geometry;

  BoundaryData({
    required this.type,
    required this.properties,
    required this.geometry,
  });

  factory BoundaryData.fromJson(Map<String, dynamic> json) {
    return BoundaryData(
      type: json['type'] ?? 'Feature',
      properties: Map<String, dynamic>.from(json['properties'] ?? {}),
      geometry: GeoJSONGeometry.fromJson(json['geometry']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'properties': properties,
      'geometry': geometry.toJson(),
    };
  }
}

// Ward model
class WardModel {
  final String wardId;
  final String wardName;
  final String wardNumber;
  final String city;
  final String? area;
  final int? population;
  final String? color;
  final BoundaryData? boundaryData;
  final LocationModel? centroid;
  final String? notes;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? lastUpdated;

  WardModel({
    required this.wardId,
    required this.wardName,
    required this.wardNumber,
    required this.city,
    this.area,
    this.population,
    this.color,
    this.boundaryData,
    this.centroid,
    this.notes,
    required this.isActive,
    this.createdAt,
    this.lastUpdated,
  });

  factory WardModel.fromJson(Map<String, dynamic> json) {
    return WardModel(
      wardId: json['wardId'] ?? '',
      wardName: json['wardName'] ?? '',
      wardNumber: json['wardNumber'] ?? '',
      city: json['city'] ?? '',
      area: json['area'],
      population: json['population'],
      color: json['color'],
      boundaryData: json['boundaryData'] != null
          ? BoundaryData.fromJson(json['boundaryData'])
          : null,
      centroid: json['centroid'] != null
          ? LocationModel.fromJson(json['centroid'])
          : null,
      notes: json['notes'],
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wardId': wardId,
      'wardName': wardName,
      'wardNumber': wardNumber,
      'city': city,
      'area': area,
      'population': population,
      'color': color,
      'boundaryData': boundaryData?.toJson(),
      'centroid': centroid?.toJson(),
      'notes': notes,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  // Helper methods
  String get displayName => '$wardName (Ward $wardNumber)';

  String get fullDisplayName => '$wardName, $city (Ward $wardNumber)';

  // Get area in a readable format
  String get formattedArea {
    if (area == null) return 'Unknown';
    return area!;
  }

  // Get population density if both area and population are available
  double? get populationDensity {
    if (population == null || area == null) return null;

    // Extract numeric value from area string (e.g., "2.5 sq km" -> 2.5)
    final areaMatch = RegExp(r'(\d+\.?\d*)').firstMatch(area!);
    if (areaMatch == null) return null;

    final areaValue = double.tryParse(areaMatch.group(1)!);
    if (areaValue == null || areaValue == 0) return null;

    return population! / areaValue;
  }

  // Get formatted population density
  String get formattedPopulationDensity {
    final density = populationDensity;
    if (density == null) return 'Unknown';

    return '${density.toStringAsFixed(0)} people/sq km';
  }

  // Check if ward has complete geographic data
  bool get hasCompleteGeographicData {
    return boundaryData != null && centroid != null;
  }

  // Get ward status for UI
  String get statusDisplay {
    if (!isActive) return 'Inactive';
    if (!hasCompleteGeographicData) return 'Incomplete Data';
    return 'Active';
  }
}

// Ward boundary feature model (for standalone boundary data)
class WardBoundaryFeature {
  final String type;
  final Map<String, dynamic> properties;
  final GeoJSONGeometry geometry;

  WardBoundaryFeature({
    required this.type,
    required this.properties,
    required this.geometry,
  });

  factory WardBoundaryFeature.fromJson(Map<String, dynamic> json) {
    return WardBoundaryFeature(
      type: json['type'] ?? 'Feature',
      properties: Map<String, dynamic>.from(json['properties'] ?? {}),
      geometry: GeoJSONGeometry.fromJson(json['geometry']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'properties': properties,
      'geometry': geometry.toJson(),
    };
  }

  // Helper getters
  String? get ward => properties['ward'];
  String? get wardId => properties['wardId'];
}

// Ward boundaries collection model
class WardBoundariesCollection {
  final String type;
  final List<WardBoundaryFeature> features;

  WardBoundariesCollection({required this.type, required this.features});

  factory WardBoundariesCollection.fromJson(Map<String, dynamic> json) {
    return WardBoundariesCollection(
      type: json['type'] ?? 'FeatureCollection',
      features:
          (json['features'] as List<dynamic>?)
              ?.map((feature) => WardBoundaryFeature.fromJson(feature))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'features': features.map((feature) => feature.toJson()).toList(),
    };
  }

  // Helper methods
  WardBoundaryFeature? findByWardId(String wardId) {
    try {
      return features.firstWhere((feature) => feature.wardId == wardId);
    } catch (e) {
      return null;
    }
  }

  List<String> get allWardIds {
    return features
        .map((feature) => feature.wardId)
        .where((id) => id != null)
        .cast<String>()
        .toList();
  }

  List<String> get allWardNames {
    return features
        .map((feature) => feature.ward)
        .where((name) => name != null)
        .cast<String>()
        .toList();
  }
}
