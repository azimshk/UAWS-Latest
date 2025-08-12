import 'dart:math' as math;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import '../../shared/models/media/location_record.dart';
import '../../core/utils/app_logger.dart';

class LocationStorageService extends GetxService {
  static LocationStorageService get instance => Get.find();

  static const String _boxName = 'locations';
  Box<LocationRecord>? _locationBox;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeHive();
  }

  @override
  Future<void> onClose() async {
    await _locationBox?.close();
    super.onClose();
  }

  /// Initialize Hive database
  Future<void> _initializeHive() async {
    try {
      if (!Hive.isAdapterRegistered(11)) {
        Hive.registerAdapter(LocationRecordAdapter());
      }

      _locationBox = await Hive.openBox<LocationRecord>(_boxName);
      AppLogger.i('Location storage service initialized');
    } catch (e) {
      AppLogger.e('Error initializing location storage: $e');
    }
  }

  /// Save location to local storage
  Future<void> saveLocation(LocationRecord location) async {
    try {
      await _locationBox?.put(location.id, location);
      AppLogger.i('Location saved to storage: ${location.id}');
    } catch (e) {
      AppLogger.e('Error saving location: $e');
      rethrow;
    }
  }

  /// Get location by ID
  Future<LocationRecord?> getLocation(String id) async {
    try {
      return _locationBox?.get(id);
    } catch (e) {
      AppLogger.e('Error getting location: $e');
      return null;
    }
  }

  /// Get all locations
  Future<List<LocationRecord>> getAllLocations() async {
    try {
      final locations = _locationBox?.values.toList() ?? [];
      // Sort by timestamp, newest first
      locations.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return locations;
    } catch (e) {
      AppLogger.e('Error getting all locations: $e');
      return [];
    }
  }

  /// Get location history with optional filters
  Future<List<LocationRecord>> getLocationHistory({
    String? associatedRecordId,
    String? associatedRecordType,
    DateTime? since,
    int? limit,
  }) async {
    try {
      var locations = _locationBox?.values.toList() ?? [];

      // Apply filters
      if (associatedRecordId != null) {
        locations = locations
            .where((loc) => loc.associatedRecordId == associatedRecordId)
            .toList();
      }

      if (associatedRecordType != null) {
        locations = locations
            .where((loc) => loc.associatedRecordType == associatedRecordType)
            .toList();
      }

      if (since != null) {
        locations = locations
            .where((loc) => loc.timestamp.isAfter(since))
            .toList();
      }

      // Sort by timestamp, newest first
      locations.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      // Apply limit
      if (limit != null && locations.length > limit) {
        locations = locations.take(limit).toList();
      }

      return locations;
    } catch (e) {
      AppLogger.e('Error getting location history: $e');
      return [];
    }
  }

  /// Get locations by associated record
  Future<List<LocationRecord>> getLocationsByRecord(
    String recordId,
    String recordType,
  ) async {
    try {
      final locations =
          _locationBox?.values
              .where(
                (location) =>
                    location.associatedRecordId == recordId &&
                    location.associatedRecordType == recordType,
              )
              .toList() ??
          [];

      // Sort by timestamp, newest first
      locations.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return locations;
    } catch (e) {
      AppLogger.e('Error getting locations by record: $e');
      return [];
    }
  }

  /// Get unsynced locations
  Future<List<LocationRecord>> getUnsyncedLocations() async {
    try {
      final locations =
          _locationBox?.values
              .where((location) => !location.isSynced)
              .toList() ??
          [];

      // Sort by timestamp, oldest first for syncing
      locations.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return locations;
    } catch (e) {
      AppLogger.e('Error getting unsynced locations: $e');
      return [];
    }
  }

  /// Update location sync status
  Future<void> markLocationAsSynced(String locationId) async {
    try {
      final location = await getLocation(locationId);
      if (location != null) {
        final updatedLocation = location.copyWith(isSynced: true);
        await saveLocation(updatedLocation);
        AppLogger.i('Location marked as synced: $locationId');
      }
    } catch (e) {
      AppLogger.e('Error marking location as synced: $e');
      rethrow;
    }
  }

  /// Delete location
  Future<void> deleteLocation(String locationId) async {
    try {
      await _locationBox?.delete(locationId);
      AppLogger.i('Location deleted from storage: $locationId');
    } catch (e) {
      AppLogger.e('Error deleting location: $e');
      rethrow;
    }
  }

  /// Get locations by date range
  Future<List<LocationRecord>> getLocationsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final locations =
          _locationBox?.values
              .where(
                (location) =>
                    location.timestamp.isAfter(startDate) &&
                    location.timestamp.isBefore(endDate),
              )
              .toList() ??
          [];

      // Sort by timestamp, newest first
      locations.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return locations;
    } catch (e) {
      AppLogger.e('Error getting locations by date range: $e');
      return [];
    }
  }

  /// Get high accuracy locations only
  Future<List<LocationRecord>> getHighAccuracyLocations() async {
    try {
      final locations =
          _locationBox?.values
              .where((location) => location.isHighAccuracy)
              .toList() ??
          [];

      // Sort by timestamp, newest first
      locations.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return locations;
    } catch (e) {
      AppLogger.e('Error getting high accuracy locations: $e');
      return [];
    }
  }

  /// Get storage statistics
  Future<Map<String, dynamic>> getStorageStats() async {
    try {
      final allLocations = await getAllLocations();
      final unsyncedLocations = await getUnsyncedLocations();
      final highAccuracyLocations = await getHighAccuracyLocations();

      final averageAccuracy = allLocations.isNotEmpty
          ? allLocations.map((loc) => loc.accuracy).reduce((a, b) => a + b) /
                allLocations.length
          : 0.0;

      return {
        'totalLocations': allLocations.length,
        'unsyncedLocations': unsyncedLocations.length,
        'highAccuracyLocations': highAccuracyLocations.length,
        'averageAccuracy': averageAccuracy.toStringAsFixed(2),
        'oldestRecord': allLocations.isNotEmpty
            ? allLocations.last.timestamp.toIso8601String()
            : null,
        'newestRecord': allLocations.isNotEmpty
            ? allLocations.first.timestamp.toIso8601String()
            : null,
      };
    } catch (e) {
      AppLogger.e('Error getting storage stats: $e');
      return {};
    }
  }

  /// Clear old locations (keep only recent ones)
  Future<void> clearOldLocations({Duration? keepDuration}) async {
    try {
      final cutoffDate = DateTime.now().subtract(
        keepDuration ?? const Duration(days: 30),
      );
      final allLocations = await getAllLocations();

      int deletedCount = 0;
      for (final location in allLocations) {
        if (location.timestamp.isBefore(cutoffDate)) {
          await deleteLocation(location.id);
          deletedCount++;
        }
      }

      AppLogger.i('Cleared $deletedCount old location records');
    } catch (e) {
      AppLogger.e('Error clearing old locations: $e');
      rethrow;
    }
  }

  /// Clear all locations (use with caution)
  Future<void> clearAllLocations() async {
    try {
      await _locationBox?.clear();
      AppLogger.i('All locations cleared from storage');
    } catch (e) {
      AppLogger.e('Error clearing all locations: $e');
      rethrow;
    }
  }

  /// Get locations within a radius of a point
  Future<List<LocationRecord>> getLocationsNearPoint({
    required double latitude,
    required double longitude,
    required double radiusMeters,
  }) async {
    try {
      final allLocations = await getAllLocations();
      final nearbyLocations = <LocationRecord>[];

      for (final location in allLocations) {
        final distance = _calculateDistance(
          latitude,
          longitude,
          location.latitude,
          location.longitude,
        );

        if (distance <= radiusMeters) {
          nearbyLocations.add(location);
        }
      }

      // Sort by distance (closest first)
      nearbyLocations.sort((a, b) {
        final distanceA = _calculateDistance(
          latitude,
          longitude,
          a.latitude,
          a.longitude,
        );
        final distanceB = _calculateDistance(
          latitude,
          longitude,
          b.latitude,
          b.longitude,
        );
        return distanceA.compareTo(distanceB);
      });

      return nearbyLocations;
    } catch (e) {
      AppLogger.e('Error getting nearby locations: $e');
      return [];
    }
  }

  /// Calculate distance between two points using Haversine formula
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000; // Earth's radius in meters

    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (math.pi / 180);
  }
}
