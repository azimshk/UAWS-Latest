// Common location model for GPS coordinates used across all modules
class LocationModel {
  final double lat;
  final double lng;
  final String? address;
  final String? ward;
  final String? zone;

  LocationModel({
    required this.lat,
    required this.lng,
    this.address,
    this.ward,
    this.zone,
  });

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
      'address': address,
      'ward': ward,
      'zone': zone,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      address: json['address'],
      ward: json['ward'],
      zone: json['zone'],
    );
  }

  LocationModel copyWith({
    double? lat,
    double? lng,
    String? address,
    String? ward,
    String? zone,
  }) {
    return LocationModel(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      address: address ?? this.address,
      ward: ward ?? this.ward,
      zone: zone ?? this.zone,
    );
  }

  @override
  String toString() {
    return 'LocationModel{lat: $lat, lng: $lng, address: $address, ward: $ward, zone: $zone}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationModel &&
          runtimeType == other.runtimeType &&
          lat == other.lat &&
          lng == other.lng &&
          address == other.address &&
          ward == other.ward &&
          zone == other.zone;

  @override
  int get hashCode =>
      lat.hashCode ^
      lng.hashCode ^
      address.hashCode ^
      ward.hashCode ^
      zone.hashCode;
}
