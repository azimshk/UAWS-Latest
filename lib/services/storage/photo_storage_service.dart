import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import '../../shared/models/media/photo_model.dart';
import '../../core/utils/app_logger.dart';

class PhotoStorageService extends GetxService {
  static PhotoStorageService get instance => Get.find();

  static const String _boxName = 'photos';
  Box<PhotoModel>? _photoBox;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeHive();
  }

  @override
  Future<void> onClose() async {
    await _photoBox?.close();
    super.onClose();
  }

  /// Initialize Hive database
  Future<void> _initializeHive() async {
    try {
      if (!Hive.isAdapterRegistered(10)) {
        Hive.registerAdapter(PhotoModelAdapter());
      }

      _photoBox = await Hive.openBox<PhotoModel>(_boxName);
      AppLogger.i('Photo storage service initialized');
    } catch (e) {
      AppLogger.e('Error initializing photo storage: $e');
    }
  }

  /// Save photo to local storage
  Future<void> savePhoto(PhotoModel photo) async {
    try {
      await _photoBox?.put(photo.id, photo);
      AppLogger.i('Photo saved to storage: ${photo.id}');
    } catch (e) {
      AppLogger.e('Error saving photo: $e');
      rethrow;
    }
  }

  /// Get photo by ID
  Future<PhotoModel?> getPhoto(String id) async {
    try {
      return _photoBox?.get(id);
    } catch (e) {
      AppLogger.e('Error getting photo: $e');
      return null;
    }
  }

  /// Get all photos
  Future<List<PhotoModel>> getAllPhotos() async {
    try {
      final photos = _photoBox?.values.toList() ?? [];
      // Sort by captured date, newest first
      photos.sort((a, b) => b.capturedAt.compareTo(a.capturedAt));
      return photos;
    } catch (e) {
      AppLogger.e('Error getting all photos: $e');
      return [];
    }
  }

  /// Get photos by associated record
  Future<List<PhotoModel>> getPhotosByRecord(
    String recordId,
    String recordType,
  ) async {
    try {
      final photos =
          _photoBox?.values
              .where(
                (photo) =>
                    photo.associatedRecordId == recordId &&
                    photo.associatedRecordType == recordType,
              )
              .toList() ??
          [];

      // Sort by captured date, newest first
      photos.sort((a, b) => b.capturedAt.compareTo(a.capturedAt));
      return photos;
    } catch (e) {
      AppLogger.e('Error getting photos by record: $e');
      return [];
    }
  }

  /// Get unsynced photos
  Future<List<PhotoModel>> getUnsyncedPhotos() async {
    try {
      final photos =
          _photoBox?.values.where((photo) => !photo.isSynced).toList() ?? [];

      // Sort by captured date, oldest first for syncing
      photos.sort((a, b) => a.capturedAt.compareTo(b.capturedAt));
      return photos;
    } catch (e) {
      AppLogger.e('Error getting unsynced photos: $e');
      return [];
    }
  }

  /// Update photo sync status
  Future<void> markPhotoAsSynced(String photoId, String? remotePath) async {
    try {
      final photo = await getPhoto(photoId);
      if (photo != null) {
        final updatedPhoto = photo.copyWith(
          isSynced: true,
          remotePath: remotePath,
        );
        await savePhoto(updatedPhoto);
        AppLogger.i('Photo marked as synced: $photoId');
      }
    } catch (e) {
      AppLogger.e('Error marking photo as synced: $e');
      rethrow;
    }
  }

  /// Delete photo
  Future<void> deletePhoto(String photoId) async {
    try {
      await _photoBox?.delete(photoId);
      AppLogger.i('Photo deleted from storage: $photoId');
    } catch (e) {
      AppLogger.e('Error deleting photo: $e');
      rethrow;
    }
  }

  /// Get photos by date range
  Future<List<PhotoModel>> getPhotosByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final photos =
          _photoBox?.values
              .where(
                (photo) =>
                    photo.capturedAt.isAfter(startDate) &&
                    photo.capturedAt.isBefore(endDate),
              )
              .toList() ??
          [];

      // Sort by captured date, newest first
      photos.sort((a, b) => b.capturedAt.compareTo(a.capturedAt));
      return photos;
    } catch (e) {
      AppLogger.e('Error getting photos by date range: $e');
      return [];
    }
  }

  /// Get photos with location
  Future<List<PhotoModel>> getPhotosWithLocation() async {
    try {
      final photos =
          _photoBox?.values.where((photo) => photo.hasLocation).toList() ?? [];

      // Sort by captured date, newest first
      photos.sort((a, b) => b.capturedAt.compareTo(a.capturedAt));
      return photos;
    } catch (e) {
      AppLogger.e('Error getting photos with location: $e');
      return [];
    }
  }

  /// Get storage statistics
  Future<Map<String, dynamic>> getStorageStats() async {
    try {
      final allPhotos = await getAllPhotos();
      final unsyncedPhotos = await getUnsyncedPhotos();
      final photosWithLocation = await getPhotosWithLocation();

      final totalSize = allPhotos.fold<int>(
        0,
        (sum, photo) => sum + photo.fileSize,
      );

      return {
        'totalPhotos': allPhotos.length,
        'unsyncedPhotos': unsyncedPhotos.length,
        'photosWithLocation': photosWithLocation.length,
        'totalSizeBytes': totalSize,
        'totalSizeMB': (totalSize / (1024 * 1024)).toStringAsFixed(2),
      };
    } catch (e) {
      AppLogger.e('Error getting storage stats: $e');
      return {};
    }
  }

  /// Clear all photos (use with caution)
  Future<void> clearAllPhotos() async {
    try {
      await _photoBox?.clear();
      AppLogger.i('All photos cleared from storage');
    } catch (e) {
      AppLogger.e('Error clearing all photos: $e');
      rethrow;
    }
  }

  /// Search photos by description
  Future<List<PhotoModel>> searchPhotos(String query) async {
    try {
      final searchTerm = query.toLowerCase();
      final photos =
          _photoBox?.values
              .where(
                (photo) =>
                    photo.description?.toLowerCase().contains(searchTerm) ==
                        true ||
                    photo.associatedRecordType?.toLowerCase().contains(
                          searchTerm,
                        ) ==
                        true,
              )
              .toList() ??
          [];

      // Sort by captured date, newest first
      photos.sort((a, b) => b.capturedAt.compareTo(a.capturedAt));
      return photos;
    } catch (e) {
      AppLogger.e('Error searching photos: $e');
      return [];
    }
  }
}
