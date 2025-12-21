import 'package:hive/hive.dart';

part 'network_location.g.dart';

@HiveType(typeId: 5)
class NetworkLocation extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final double latitude;

  @HiveField(2)
  final double longitude;

  @HiveField(3)
  final double? accuracy;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final String providerType; // 'network'

  @HiveField(6)
  final String? address;

  @HiveField(7)
  final bool isMocked;

  @HiveField(8)
  final String? networkProvider; // wifi, cellular, etc

  NetworkLocation({
    this.id,
    required this.latitude,
    required this.longitude,
    this.accuracy,
    required this.timestamp,
    this.providerType = 'network',
    this.address,
    this.isMocked = false,
    this.networkProvider,
  });

  // Factory constructor from Position (geolocator)
  factory NetworkLocation.fromPosition(dynamic position, {String? address, String? networkProvider}) {
    return NetworkLocation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      timestamp: position.timestamp ?? DateTime.now(),
      providerType: 'network',
      address: address,
      isMocked: position.isMocked ?? false,
      networkProvider: networkProvider,
    );
  }

  // Convert to Map for Supabase
  Map<String, dynamic> toSupabaseMap() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'timestamp': timestamp.toIso8601String(),
      'provider_type': providerType,
      'address': address,
      'is_mocked': isMocked,
      'network_provider': networkProvider,
    };
  }

  // Convert from Map (Supabase)
  factory NetworkLocation.fromSupabaseMap(Map<String, dynamic> map) {
    return NetworkLocation(
      id: map['id']?.toString(),
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      accuracy: map['accuracy'] != null ? (map['accuracy'] as num).toDouble() : null,
      timestamp: DateTime.parse(map['timestamp']),
      providerType: map['provider_type'] ?? 'network',
      address: map['address'],
      isMocked: map['is_mocked'] ?? false,
      networkProvider: map['network_provider'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'timestamp': timestamp.toIso8601String(),
      'providerType': providerType,
      'address': address,
      'isMocked': isMocked,
      'networkProvider': networkProvider,
    };
  }

  // Convert from JSON
  factory NetworkLocation.fromJson(Map<String, dynamic> json) {
    return NetworkLocation(
      id: json['id']?.toString(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      accuracy: json['accuracy'] != null ? (json['accuracy'] as num).toDouble() : null,
      timestamp: DateTime.parse(json['timestamp']),
      providerType: json['providerType'] ?? 'network',
      address: json['address'],
      isMocked: json['isMocked'] ?? false,
      networkProvider: json['networkProvider'],
    );
  }

  // Copy with method
  NetworkLocation copyWith({
    String? id,
    double? latitude,
    double? longitude,
    double? accuracy,
    DateTime? timestamp,
    String? providerType,
    String? address,
    bool? isMocked,
    String? networkProvider,
  }) {
    return NetworkLocation(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      timestamp: timestamp ?? this.timestamp,
      providerType: providerType ?? this.providerType,
      address: address ?? this.address,
      isMocked: isMocked ?? this.isMocked,
      networkProvider: networkProvider ?? this.networkProvider,
    );
  }

  @override
  String toString() {
    return 'NetworkLocation(id: $id, lat: $latitude, lng: $longitude, accuracy: $accuracy m, time: $timestamp, provider: $providerType, network: $networkProvider)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NetworkLocation &&
        other.id == id &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.accuracy == accuracy &&
        other.timestamp == timestamp &&
        other.providerType == providerType &&
        other.address == address &&
        other.isMocked == isMocked &&
        other.networkProvider == networkProvider;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        accuracy.hashCode ^
        timestamp.hashCode ^
        providerType.hashCode ^
        address.hashCode ^
        isMocked.hashCode ^
        networkProvider.hashCode;
  }
}
