import 'package:get/get.dart';
import '../../services/camera/camera_service.dart';
import '../../services/location/location_service.dart';
import '../../services/storage/photo_storage_service.dart';
import '../../services/storage/location_storage_service.dart';
import '../../services/sync/connectivity_service.dart';
import '../../shared/models/media/photo_model.dart';
import '../../shared/models/media/location_record.dart';

/// Utility class to integrate camera and GPS features with existing modules
class MediaIntegration {
  static MediaIntegration get instance => _instance;
  static final MediaIntegration _instance = MediaIntegration._internal();
  MediaIntegration._internal();

  /// Capture photo with location for any record type
  Future<PhotoModel?> capturePhotoForRecord({
    required String recordId,
    required String recordType,
    String? description,
    bool includeLocation = true,
    bool compressImage = true,
  }) async {
    try {
      final photo = await CameraService.instance.capturePhoto(
        description: description,
        associatedRecordId: recordId,
        associatedRecordType: recordType,
        includeLocation: includeLocation,
        compressImage: compressImage,
      );

      return photo;
    } catch (e) {
      Get.snackbar(
        'Camera Error',
        'Failed to capture photo: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  /// Get current location for any record
  Future<LocationRecord?> getCurrentLocationForRecord({
    required String recordId,
    required String recordType,
  }) async {
    try {
      final position = await LocationService.instance.getCurrentPosition();
      if (position == null) return null;

      final locationRecord = LocationRecord.fromPosition(
        position,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        associatedRecordId: recordId,
        associatedRecordType: recordType,
      );

      await LocationStorageService.instance.saveLocation(locationRecord);
      return locationRecord;
    } catch (e) {
      Get.snackbar(
        'Location Error',
        'Failed to get location: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  /// Start location tracking for field operations
  Future<void> startTrackingForRecord({
    required String recordId,
    required String recordType,
  }) async {
    await LocationService.instance.startLocationTracking(
      associatedRecordId: recordId,
      associatedRecordType: recordType,
    );
  }

  /// Stop location tracking
  Future<void> stopTracking() async {
    await LocationService.instance.stopLocationTracking();
  }

  /// Get all photos for a specific record
  Future<List<PhotoModel>> getPhotosForRecord(
    String recordId,
    String recordType,
  ) async {
    return await PhotoStorageService.instance.getPhotosByRecord(
      recordId,
      recordType,
    );
  }

  /// Get location history for a specific record
  Future<List<LocationRecord>> getLocationHistoryForRecord(
    String recordId,
    String recordType,
  ) async {
    return await LocationStorageService.instance.getLocationsByRecord(
      recordId,
      recordType,
    );
  }

  /// Check if camera and location permissions are granted
  Future<bool> checkPermissions() async {
    final cameraPermission = await CameraService.instance
        .checkCameraPermissions();
    final locationPermission = await LocationService.instance
        .checkLocationPermissions();

    return cameraPermission && locationPermission;
  }

  /// Get connectivity status
  bool get isOnline => ConnectivityService.instance.isOnline.value;

  /// Get storage statistics
  Future<Map<String, dynamic>> getStorageStatistics() async {
    final photoStats = await PhotoStorageService.instance.getStorageStats();
    final locationStats = await LocationStorageService.instance
        .getStorageStats();

    return {
      'photos': photoStats,
      'locations': locationStats,
      'connectivity': ConnectivityService.instance.getNetworkInfo(),
    };
  }
}
