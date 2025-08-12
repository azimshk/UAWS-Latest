import 'package:hive/hive.dart';

part 'photo_model.g.dart';

@HiveType(typeId: 10)
class PhotoModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String localPath;

  @HiveField(2)
  final String? remotePath;

  @HiveField(3)
  final double? latitude;

  @HiveField(4)
  final double? longitude;

  @HiveField(5)
  final DateTime capturedAt;

  @HiveField(6)
  final int fileSize;

  @HiveField(7)
  final String mimeType;

  @HiveField(8)
  final bool isCompressed;

  @HiveField(9)
  final String? description;

  @HiveField(10)
  final String? associatedRecordId;

  @HiveField(11)
  final String? associatedRecordType;

  @HiveField(12)
  final bool isSynced;

  @HiveField(13)
  final Map<String, dynamic>? metadata;

  PhotoModel({
    required this.id,
    required this.localPath,
    this.remotePath,
    this.latitude,
    this.longitude,
    required this.capturedAt,
    required this.fileSize,
    required this.mimeType,
    this.isCompressed = false,
    this.description,
    this.associatedRecordId,
    this.associatedRecordType,
    this.isSynced = false,
    this.metadata,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'] as String,
      localPath: json['localPath'] as String,
      remotePath: json['remotePath'] as String?,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      capturedAt: DateTime.parse(json['capturedAt'] as String),
      fileSize: json['fileSize'] as int,
      mimeType: json['mimeType'] as String,
      isCompressed: json['isCompressed'] as bool? ?? false,
      description: json['description'] as String?,
      associatedRecordId: json['associatedRecordId'] as String?,
      associatedRecordType: json['associatedRecordType'] as String?,
      isSynced: json['isSynced'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'localPath': localPath,
      'remotePath': remotePath,
      'latitude': latitude,
      'longitude': longitude,
      'capturedAt': capturedAt.toIso8601String(),
      'fileSize': fileSize,
      'mimeType': mimeType,
      'isCompressed': isCompressed,
      'description': description,
      'associatedRecordId': associatedRecordId,
      'associatedRecordType': associatedRecordType,
      'isSynced': isSynced,
      'metadata': metadata,
    };
  }

  PhotoModel copyWith({
    String? id,
    String? localPath,
    String? remotePath,
    double? latitude,
    double? longitude,
    DateTime? capturedAt,
    int? fileSize,
    String? mimeType,
    bool? isCompressed,
    String? description,
    String? associatedRecordId,
    String? associatedRecordType,
    bool? isSynced,
    Map<String, dynamic>? metadata,
  }) {
    return PhotoModel(
      id: id ?? this.id,
      localPath: localPath ?? this.localPath,
      remotePath: remotePath ?? this.remotePath,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      capturedAt: capturedAt ?? this.capturedAt,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      isCompressed: isCompressed ?? this.isCompressed,
      description: description ?? this.description,
      associatedRecordId: associatedRecordId ?? this.associatedRecordId,
      associatedRecordType: associatedRecordType ?? this.associatedRecordType,
      isSynced: isSynced ?? this.isSynced,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get hasLocation => latitude != null && longitude != null;

  String get displayName {
    if (description != null && description!.isNotEmpty) {
      return description!;
    }
    return 'Photo ${capturedAt.toString().substring(0, 19)}';
  }

  @override
  String toString() {
    return 'PhotoModel(id: $id, localPath: $localPath, hasLocation: $hasLocation, isSynced: $isSynced)';
  }
}
