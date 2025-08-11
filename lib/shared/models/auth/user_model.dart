class UserModel {
  final String? id;
  final String username;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String role;
  final String layer;
  final String assignedCity;
  final List<String> assignedWard;
  final Map<String, dynamic> permissions;
  final DateTime? lastLogin;
  final bool isActive;
  final Map<String, dynamic>? metadata;

  UserModel({
    this.id,
    required this.username,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.role,
    required this.layer,
    required this.assignedCity,
    required this.assignedWard,
    required this.permissions,
    this.lastLogin,
    this.isActive = true,
    this.metadata,
  });

  // Convert from Firebase document
  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      displayName: data['displayName'],
      photoUrl: data['photoUrl'],
      role: data['role'] ?? 'field_staff',
      layer: data['layer'] ?? 'Layer1',
      assignedCity: data['assignedCity'] ?? '',
      assignedWard: List<String>.from(data['assignedWard'] ?? []),
      permissions: data['permissions'] ?? {},
      lastLogin: data['lastLogin']?.toDate(),
      isActive: data['isActive'] ?? true,
      metadata: data['metadata'],
    );
  }

  // Convert to Firebase document
  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role,
      'layer': layer,
      'assignedCity': assignedCity,
      'assignedWard': assignedWard,
      'permissions': permissions,
      'lastLogin': lastLogin,
      'isActive': isActive,
      'metadata': metadata,
    };
  }

  // Convert from JSON (for local storage or dummy data)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
      role: json['role'] ?? 'field_staff',
      layer: json['layer'] ?? 'Layer1',
      assignedCity: json['assignedCity'] ?? '',
      assignedWard: List<String>.from(json['assignedWard'] ?? []),
      permissions: json['permissions'] ?? {},
      lastLogin: json['lastLogin'] != null
          ? DateTime.parse(json['lastLogin'])
          : null,
      isActive: json['isActive'] ?? true,
      metadata: json['metadata'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'role': role,
      'layer': layer,
      'assignedCity': assignedCity,
      'assignedWard': assignedWard,
      'permissions': permissions,
      'lastLogin': lastLogin?.toIso8601String(),
      'isActive': isActive,
      'metadata': metadata,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? displayName,
    String? photoUrl,
    String? role,
    String? layer,
    String? assignedCity,
    List<String>? assignedWard,
    Map<String, dynamic>? permissions,
    DateTime? lastLogin,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      layer: layer ?? this.layer,
      assignedCity: assignedCity ?? this.assignedCity,
      assignedWard: assignedWard ?? this.assignedWard,
      permissions: permissions ?? this.permissions,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }

  // Helper methods for role checking
  bool get isAdmin => role == 'admin';
  bool get isSupervisor => role == 'ngo_supervisor';
  bool get isFieldStaff => role == 'field_staff';
  bool get isMunicipalOfficial => role == 'municipal_readonly';

  // Helper method to check permissions
  bool hasPermission(String module, String action) {
    try {
      return permissions[module]?[action] ?? false;
    } catch (e) {
      return false;
    }
  }
}
