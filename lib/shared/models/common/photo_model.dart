// Common photo model used across all modules for image attachments

class PhotoModel {
  final String id;
  final String filename;
  final String localPath;
  final String? remotePath;
  final String? url;
  final DateTime timestamp;
  final double? latitude;
  final double? longitude;
  final String? description;
  final String?
  category; // e.g., 'pickup', 'operation', 'release', 'bite_wound', etc.
  final int? fileSizeBytes;
  final String? mimeType;
  final bool isUploaded;
  final String? uploadedBy;

  PhotoModel({
    required this.id,
    required this.filename,
    required this.localPath,
    this.remotePath,
    this.url,
    required this.timestamp,
    this.latitude,
    this.longitude,
    this.description,
    this.category,
    this.fileSizeBytes,
    this.mimeType,
    this.isUploaded = false,
    this.uploadedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filename': filename,
      'localPath': localPath,
      'remotePath': remotePath,
      'url': url,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'category': category,
      'fileSizeBytes': fileSizeBytes,
      'mimeType': mimeType,
      'isUploaded': isUploaded,
      'uploadedBy': uploadedBy,
    };
  }

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['id'],
      filename: json['filename'],
      localPath: json['localPath'],
      remotePath: json['remotePath'],
      url: json['url'],
      timestamp: DateTime.parse(json['timestamp']),
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      description: json['description'],
      category: json['category'],
      fileSizeBytes: json['fileSizeBytes'],
      mimeType: json['mimeType'],
      isUploaded: json['isUploaded'] ?? false,
      uploadedBy: json['uploadedBy'],
    );
  }

  PhotoModel copyWith({
    String? id,
    String? filename,
    String? localPath,
    String? remotePath,
    String? url,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
    String? description,
    String? category,
    int? fileSizeBytes,
    String? mimeType,
    bool? isUploaded,
    String? uploadedBy,
  }) {
    return PhotoModel(
      id: id ?? this.id,
      filename: filename ?? this.filename,
      localPath: localPath ?? this.localPath,
      remotePath: remotePath ?? this.remotePath,
      url: url ?? this.url,
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      category: category ?? this.category,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      mimeType: mimeType ?? this.mimeType,
      isUploaded: isUploaded ?? this.isUploaded,
      uploadedBy: uploadedBy ?? this.uploadedBy,
    );
  }

  @override
  String toString() {
    return 'PhotoModel{id: $id, filename: $filename, category: $category, isUploaded: $isUploaded}';
  }

  // Helper methods
  bool get hasGpsCoordinates => latitude != null && longitude != null;

  String get displaySize {
    if (fileSizeBytes == null) return 'Unknown size';
    final kb = fileSizeBytes! / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }

  String get fileExtension {
    return filename.split('.').last.toLowerCase();
  }

  bool get isImage {
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageExtensions.contains(fileExtension);
  }
}
