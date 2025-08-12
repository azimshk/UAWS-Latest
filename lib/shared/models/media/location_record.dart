import 'package:hive/hive.dart';
import 'package:geolocator/geolocator.dart';

part 'location_record.g.dart';

@HiveType(typeId: 11)
class LocationRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double latitude;

  @HiveField(2)
  final double longitude;

  @HiveField(3)
  final double accuracy;

  @HiveField(4)
  final double? altitude;

  @HiveField(5)
  final double? heading;

  @HiveField(6)
  final double? speed;

  @HiveField(7)
  final DateTime timestamp;

  @HiveField(8)
  final String? address;

  @HiveField(9)
  final String? associatedRecordId;

  @HiveField(10)
  final String? associatedRecordType;

  @HiveField(11)
  final bool isSynced;

  @HiveField(12)
  final Map<String, dynamic>? metadata;

  LocationRecord({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    this.altitude,
    this.heading,
    this.speed,
    required this.timestamp,
    this.address,
    this.associatedRecordId,
    this.associatedRecordType,
    this.isSynced = false,
    this.metadata,
  });

  factory LocationRecord.fromPosition(
    Position position, {
    required String id,
    String? address,
    String? associatedRecordId,
    String? associatedRecordType,
    Map<String, dynamic>? metadata,
  }) {
    return LocationRecord(
      id: id,
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      altitude: position.altitude,
      heading: position.heading,
      speed: position.speed,
      timestamp: position.timestamp,
      address: address,
      associatedRecordId: associatedRecordId,
      associatedRecordType: associatedRecordType,
      metadata: metadata,
    );
  }

  factory LocationRecord.fromJson(Map<String, dynamic> json) {
    return LocationRecord(
      id: json['id'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      accuracy: json['accuracy'] as double,
      altitude: json['altitude']?.toDouble(),
      heading: json['heading']?.toDouble(),
      speed: json['speed']?.toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      address: json['address'] as String?,
      associatedRecordId: json['associatedRecordId'] as String?,
      associatedRecordType: json['associatedRecordType'] as String?,
      isSynced: json['isSynced'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'heading': heading,
      'speed': speed,
      'timestamp': timestamp.toIso8601String(),
      'address': address,
      'associatedRecordId': associatedRecordId,
      'associatedRecordType': associatedRecordType,
      'isSynced': isSynced,
      'metadata': metadata,
    };
  }

  LocationRecord copyWith({
    String? id,
    double? latitude,
    double? longitude,
    double? accuracy,
    double? altitude,
    double? heading,
    double? speed,
    DateTime? timestamp,
    String? address,
    String? associatedRecordId,
    String? associatedRecordType,
    bool? isSynced,
    Map<String, dynamic>? metadata,
  }) {
    return LocationRecord(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      heading: heading ?? this.heading,
      speed: speed ?? this.speed,
      timestamp: timestamp ?? this.timestamp,
      address: address ?? this.address,
      associatedRecordId: associatedRecordId ?? this.associatedRecordId,
      associatedRecordType: associatedRecordType ?? this.associatedRecordType,
      isSynced: isSynced ?? this.isSynced,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isHighAccuracy => accuracy <= 10.0;
  bool get isMediumAccuracy => accuracy <= 30.0;
  bool get isLowAccuracy => accuracy > 30.0;

  String get accuracyDescription {
    if (isHighAccuracy) return 'High';
    if (isMediumAccuracy) return 'Medium';
    return 'Low';
  }

  String get displayLocation {
    if (address != null && address!.isNotEmpty) {
      return address!;
    }
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }

  @override
  String toString() {
    return 'LocationRecord(id: $id, lat: $latitude, lng: $longitude, accuracy: ${accuracy}m)';
  }
}
