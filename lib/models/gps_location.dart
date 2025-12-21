import 'package:hive/hive.dart';

part 'gps_location.g.dart';

@HiveType(typeId: 4)
class GpsLocation extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final double latitude;

  @HiveField(2)
  final double longitude;

  @HiveField(3)
  final double? accuracy;

  @HiveField(4)
  final double? altitude;

  @HiveField(5)
  final double? speed;

  @HiveField(6)
  final DateTime timestamp;

  @HiveField(7)
  final String providerType; // 'gps'

  @HiveField(8)
  final String? address;

  @HiveField(9)
  final bool isMocked;

  GpsLocation({
    this.id,
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.altitude,
    this.speed,
    required this.timestamp,
    this.providerType = 'gps',
    this.address,
    this.isMocked = false,
  });

  // Factory constructor from Position (geolocator)
  factory GpsLocation.fromPosition(dynamic position, {String? address}) {
    return GpsLocation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      altitude: position.altitude,
      speed: position.speed,
      timestamp: position.timestamp ?? DateTime.now(),
      providerType: 'gps',
      address: address,
      isMocked: position.isMocked ?? false,
    );
  }

  // Convert to Map for Supabase
  Map<String, dynamic> toSupabaseMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'speed': speed,
      'timestamp': timestamp.toIso8601String(),
      'provider_type': providerType,
      'address': address,
      'is_mocked': isMocked,
    };
  }

  // Convert from Map (Supabase)
  factory GpsLocation.fromSupabaseMap(Map<String, dynamic> map) {
    return GpsLocation(
      id: map['id']?.toString(),
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      accuracy: map['accuracy'] != null ? (map['accuracy'] as num).toDouble() : null,
      altitude: map['altitude'] != null ? (map['altitude'] as num).toDouble() : null,
      speed: map['speed'] != null ? (map['speed'] as num).toDouble() : null,
      timestamp: DateTime.parse(map['timestamp']),
      providerType: map['provider_type'] ?? 'gps',
      address: map['address'],
      isMocked: map['is_mocked'] ?? false,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'altitude': altitude,
      'speed': speed,
      'timestamp': timestamp.toIso8601String(),
      'providerType': providerType,
      'address': address,
      'isMocked': isMocked,
    };
  }

  // Convert from JSON
  factory GpsLocation.fromJson(Map<String, dynamic> json) {
    return GpsLocation(
      id: json['id']?.toString(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      accuracy: json['accuracy'] != null ? (json['accuracy'] as num).toDouble() : null,
      altitude: json['altitude'] != null ? (json['altitude'] as num).toDouble() : null,
      speed: json['speed'] != null ? (json['speed'] as num).toDouble() : null,
      timestamp: DateTime.parse(json['timestamp']),
      providerType: json['providerType'] ?? 'gps',
      address: json['address'],
      isMocked: json['isMocked'] ?? false,
    );
  }

  // Copy with method
  GpsLocation copyWith({
    String? id,
    double? latitude,
    double? longitude,
    double? accuracy,
    double? altitude,
    double? speed,
    DateTime? timestamp,
    String? providerType,
    String? address,
    bool? isMocked,
  }) {
    return GpsLocation(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      altitude: altitude ?? this.altitude,
      speed: speed ?? this.speed,
      timestamp: timestamp ?? this.timestamp,
      providerType: providerType ?? this.providerType,
      address: address ?? this.address,
      isMocked: isMocked ?? this.isMocked,
    );
  }

  @override
  String toString() {
    return 'GpsLocation(id: $id, lat: $latitude, lng: $longitude, accuracy: $accuracy m, altitude: $altitude m, speed: $speed m/s, time: $timestamp, provider: $providerType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GpsLocation &&
        other.id == id &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.accuracy == accuracy &&
        other.altitude == altitude &&
        other.speed == speed &&
        other.timestamp == timestamp &&
        other.providerType == providerType &&
        other.address == address &&
        other.isMocked == isMocked;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        accuracy.hashCode ^
        altitude.hashCode ^
        speed.hashCode ^
        timestamp.hashCode ^
        providerType.hashCode ^
        address.hashCode ^
        isMocked.hashCode;
  }
}
