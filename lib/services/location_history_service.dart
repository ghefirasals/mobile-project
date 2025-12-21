import 'package:hive/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/gps_location.dart';
import '../models/network_location.dart';

/// Service untuk mengelola location history
/// Menyimpan ke local (Hive) dan remote (Supabase)
class LocationHistoryService {
  static final LocationHistoryService _instance =
      LocationHistoryService._internal();
  factory LocationHistoryService() => _instance;
  LocationHistoryService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;
  
  // Hive boxes
  Box<GpsLocation>? _gpsBox;
  Box<NetworkLocation>? _networkBox;

  // Initialize boxes
  Future<void> init() async {
    _gpsBox = await Hive.openBox<GpsLocation>('gps_locations');
    _networkBox = await Hive.openBox<NetworkLocation>('network_locations');
  }

  // ========== GPS Location Methods ==========

  /// Save GPS location to local storage
  Future<void> saveGpsLocationLocal(GpsLocation location) async {
    try {
      await _gpsBox?.put(location.id ?? location.timestamp.toString(), location);
    } catch (e) {
      print('Error saving GPS location locally: $e');
      rethrow;
    }
  }

  /// Save GPS location to Supabase
  Future<void> saveGpsLocationRemote(GpsLocation location) async {
    try {
      await _supabase.from('gps_locations').insert(location.toSupabaseMap());
    } catch (e) {
      print('Error saving GPS location remotely: $e');
      rethrow;
    }
  }

  /// Save GPS location to both local and remote
  Future<void> saveGpsLocation(GpsLocation location, {bool syncToRemote = true}) async {
    await saveGpsLocationLocal(location);
    if (syncToRemote) {
      try {
        await saveGpsLocationRemote(location);
      } catch (e) {
        print('Failed to sync GPS location to remote, will keep in local: $e');
      }
    }
  }

  /// Get all GPS locations from local storage
  List<GpsLocation> getGpsLocationsLocal() {
    try {
      return _gpsBox?.values.toList() ?? [];
    } catch (e) {
      print('Error getting GPS locations locally: $e');
      return [];
    }
  }

  /// Get GPS locations from Supabase with pagination
  Future<List<GpsLocation>> getGpsLocationsRemote({
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('gps_locations')
          .select()
          .order('timestamp', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) => GpsLocation.fromSupabaseMap(json))
          .toList();
    } catch (e) {
      print('Error getting GPS locations remotely: $e');
      return [];
    }
  }

  /// Get GPS location history within a date range
  Future<List<GpsLocation>> getGpsLocationsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    bool fromRemote = false,
  }) async {
    if (fromRemote) {
      try {
        final response = await _supabase
            .from('gps_locations')
            .select()
            .gte('timestamp', startDate.toIso8601String())
            .lte('timestamp', endDate.toIso8601String())
            .order('timestamp', ascending: false);

        return (response as List)
            .map((json) => GpsLocation.fromSupabaseMap(json))
            .toList();
      } catch (e) {
        print('Error getting GPS locations by date range: $e');
        return [];
      }
    } else {
      return getGpsLocationsLocal()
          .where((loc) =>
              loc.timestamp.isAfter(startDate) &&
              loc.timestamp.isBefore(endDate))
          .toList();
    }
  }

  /// Delete GPS location from local storage
  Future<void> deleteGpsLocationLocal(String id) async {
    try {
      await _gpsBox?.delete(id);
    } catch (e) {
      print('Error deleting GPS location locally: $e');
      rethrow;
    }
  }

  /// Clear all GPS locations from local storage
  Future<void> clearGpsLocationsLocal() async {
    try {
      await _gpsBox?.clear();
    } catch (e) {
      print('Error clearing GPS locations locally: $e');
      rethrow;
    }
  }

  // ========== Network Location Methods ==========

  /// Save Network location to local storage
  Future<void> saveNetworkLocationLocal(NetworkLocation location) async {
    try {
      await _networkBox?.put(location.id ?? location.timestamp.toString(), location);
    } catch (e) {
      print('Error saving Network location locally: $e');
      rethrow;
    }
  }

  /// Save Network location to Supabase
  Future<void> saveNetworkLocationRemote(NetworkLocation location) async {
    try {
      await _supabase.from('network_locations').insert(location.toSupabaseMap());
    } catch (e) {
      print('Error saving Network location remotely: $e');
      rethrow;
    }
  }

  /// Save Network location to both local and remote
  Future<void> saveNetworkLocation(NetworkLocation location, {bool syncToRemote = true}) async {
    await saveNetworkLocationLocal(location);
    if (syncToRemote) {
      try {
        await saveNetworkLocationRemote(location);
      } catch (e) {
        print('Failed to sync Network location to remote, will keep in local: $e');
      }
    }
  }

  /// Get all Network locations from local storage
  List<NetworkLocation> getNetworkLocationsLocal() {
    try {
      return _networkBox?.values.toList() ?? [];
    } catch (e) {
      print('Error getting Network locations locally: $e');
      return [];
    }
  }

  /// Get Network locations from Supabase with pagination
  Future<List<NetworkLocation>> getNetworkLocationsRemote({
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('network_locations')
          .select()
          .order('timestamp', ascending: false)
          .range(offset, offset + limit - 1);

      return (response as List)
          .map((json) => NetworkLocation.fromSupabaseMap(json))
          .toList();
    } catch (e) {
      print('Error getting Network locations remotely: $e');
      return [];
    }
  }

  /// Get Network location history within a date range
  Future<List<NetworkLocation>> getNetworkLocationsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    bool fromRemote = false,
  }) async {
    if (fromRemote) {
      try {
        final response = await _supabase
            .from('network_locations')
            .select()
            .gte('timestamp', startDate.toIso8601String())
            .lte('timestamp', endDate.toIso8601String())
            .order('timestamp', ascending: false);

        return (response as List)
            .map((json) => NetworkLocation.fromSupabaseMap(json))
            .toList();
      } catch (e) {
        print('Error getting Network locations by date range: $e');
        return [];
      }
    } else {
      return getNetworkLocationsLocal()
          .where((loc) =>
              loc.timestamp.isAfter(startDate) &&
              loc.timestamp.isBefore(endDate))
          .toList();
    }
  }

  /// Delete Network location from local storage
  Future<void> deleteNetworkLocationLocal(String id) async {
    try {
      await _networkBox?.delete(id);
    } catch (e) {
      print('Error deleting Network location locally: $e');
      rethrow;
    }
  }

  /// Clear all Network locations from local storage
  Future<void> clearNetworkLocationsLocal() async {
    try {
      await _networkBox?.clear();
    } catch (e) {
      print('Error clearing Network locations locally: $e');
      rethrow;
    }
  }

  // ========== Sync Methods ==========

  /// Sync local GPS locations to remote (batch upload)
  Future<int> syncGpsLocationsToRemote() async {
    try {
      final localLocations = getGpsLocationsLocal();
      int synced = 0;

      for (final location in localLocations) {
        try {
          await saveGpsLocationRemote(location);
          synced++;
        } catch (e) {
          print('Error syncing GPS location ${location.id}: $e');
        }
      }

      return synced;
    } catch (e) {
      print('Error syncing GPS locations: $e');
      return 0;
    }
  }

  /// Sync local Network locations to remote (batch upload)
  Future<int> syncNetworkLocationsToRemote() async {
    try {
      final localLocations = getNetworkLocationsLocal();
      int synced = 0;

      for (final location in localLocations) {
        try {
          await saveNetworkLocationRemote(location);
          synced++;
        } catch (e) {
          print('Error syncing Network location ${location.id}: $e');
        }
      }

      return synced;
    } catch (e) {
      print('Error syncing Network locations: $e');
      return 0;
    }
  }

  /// Get total count of GPS locations
  int getGpsLocationCount() {
    return _gpsBox?.length ?? 0;
  }

  /// Get total count of Network locations
  int getNetworkLocationCount() {
    return _networkBox?.length ?? 0;
  }
}
