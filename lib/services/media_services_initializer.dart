import 'package:get/get.dart';
import '../services/camera/camera_service.dart';
import '../services/location/location_service.dart';
import '../services/storage/photo_storage_service.dart';
import '../services/storage/location_storage_service.dart';
import '../services/sync/connectivity_service.dart';
import '../services/sync/sync_service.dart';
import '../core/utils/app_logger.dart';

class MediaServicesInitializer {
  static bool _isInitialized = false;

  /// Initialize all media-related services
  static Future<void> initializeServices() async {
    if (_isInitialized) {
      AppLogger.i('Media services already initialized');
      return;
    }

    try {
      AppLogger.i('Initializing media services...');

      // Initialize Hive for local storage
      await _initializeHive();

      // Register all services with GetX
      await _registerServices();

      // Initialize services in proper order
      await _initializeServicesInOrder();

      _isInitialized = true;
      AppLogger.i('All media services initialized successfully');
    } catch (e) {
      AppLogger.e('Error initializing media services: $e');
      rethrow;
    }
  }

  /// Initialize Hive database
  static Future<void> _initializeHive() async {
    try {
      // Hive is already initialized in main.dart, just ensure it's ready
      AppLogger.i('Hive database ready for media services');
    } catch (e) {
      AppLogger.e('Error initializing Hive for media services: $e');
      rethrow;
    }
  }

  /// Register all services with GetX dependency injection
  static Future<void> _registerServices() async {
    try {
      // Storage services (register first as they're dependencies)
      Get.put<PhotoStorageService>(PhotoStorageService(), permanent: true);
      Get.put<LocationStorageService>(
        LocationStorageService(),
        permanent: true,
      );

      // Connectivity service
      Get.put<ConnectivityService>(ConnectivityService(), permanent: true);

      // Location service
      Get.put<LocationService>(LocationService(), permanent: true);

      // Camera service
      Get.put<CameraService>(CameraService(), permanent: true);

      // Sync service (register last as it depends on others)
      Get.put<SyncService>(SyncService(), permanent: true);

      AppLogger.i('All media services registered with GetX');
    } catch (e) {
      AppLogger.e('Error registering media services: $e');
      rethrow;
    }
  }

  /// Initialize services in proper dependency order
  static Future<void> _initializeServicesInOrder() async {
    try {
      // 1. Initialize storage services first
      AppLogger.i('Initializing storage services...');
      await PhotoStorageService.instance.onInit();
      await LocationStorageService.instance.onInit();

      // 2. Initialize connectivity service
      AppLogger.i('Initializing connectivity service...');
      await ConnectivityService.instance.onInit();

      // 3. Initialize location service
      AppLogger.i('Initializing location service...');
      await LocationService.instance.onInit();

      // 4. Initialize camera service
      AppLogger.i('Initializing camera service...');
      await CameraService.instance.onInit();

      // 5. Initialize sync service last
      AppLogger.i('Initializing sync service...');
      await SyncService.instance.onInit();

      AppLogger.i('All services initialized in proper order');
    } catch (e) {
      AppLogger.e('Error initializing services in order: $e');
      rethrow;
    }
  }

  /// Check if services are initialized
  static bool get isInitialized => _isInitialized;

  /// Get service status for debugging
  static Map<String, dynamic> getServiceStatus() {
    return {
      'initialized': _isInitialized,
      'photoStorage': Get.isRegistered<PhotoStorageService>(),
      'locationStorage': Get.isRegistered<LocationStorageService>(),
      'connectivity': Get.isRegistered<ConnectivityService>(),
      'location': Get.isRegistered<LocationService>(),
      'camera': Get.isRegistered<CameraService>(),
      'sync': Get.isRegistered<SyncService>(),
    };
  }

  /// Cleanup all services (for app shutdown)
  static Future<void> cleanup() async {
    try {
      AppLogger.i('Cleaning up media services...');

      if (Get.isRegistered<SyncService>()) {
        await SyncService.instance.onClose();
      }

      if (Get.isRegistered<CameraService>()) {
        await CameraService.instance.onClose();
      }

      if (Get.isRegistered<LocationService>()) {
        await LocationService.instance.onClose();
      }

      if (Get.isRegistered<ConnectivityService>()) {
        await ConnectivityService.instance.onClose();
      }

      if (Get.isRegistered<LocationStorageService>()) {
        await LocationStorageService.instance.onClose();
      }

      if (Get.isRegistered<PhotoStorageService>()) {
        await PhotoStorageService.instance.onClose();
      }

      _isInitialized = false;
      AppLogger.i('Media services cleanup completed');
    } catch (e) {
      AppLogger.e('Error during media services cleanup: $e');
    }
  }

  /// Restart all services (useful for error recovery)
  static Future<void> restartServices() async {
    try {
      AppLogger.i('Restarting media services...');
      await cleanup();
      await initializeServices();
      AppLogger.i('Media services restarted successfully');
    } catch (e) {
      AppLogger.e('Error restarting media services: $e');
      rethrow;
    }
  }

  /// Test all services to ensure they're working
  static Future<Map<String, bool>> testServices() async {
    final results = <String, bool>{};

    try {
      // Test connectivity service
      try {
        await ConnectivityService.instance.refreshConnectionStatus();
        results['connectivity'] = true;
      } catch (e) {
        AppLogger.e('Connectivity service test failed: $e');
        results['connectivity'] = false;
      }

      // Test location service
      try {
        await LocationService.instance.checkLocationPermissions();
        results['location'] = true;
      } catch (e) {
        AppLogger.e('Location service test failed: $e');
        results['location'] = false;
      }

      // Test camera service
      try {
        await CameraService.instance.checkCameraPermissions();
        results['camera'] = true;
      } catch (e) {
        AppLogger.e('Camera service test failed: $e');
        results['camera'] = false;
      }

      // Test storage services
      try {
        await PhotoStorageService.instance.getStorageStats();
        await LocationStorageService.instance.getStorageStats();
        results['storage'] = true;
      } catch (e) {
        AppLogger.e('Storage services test failed: $e');
        results['storage'] = false;
      }

      // Test sync service
      try {
        SyncService.instance.getSyncStatus();
        results['sync'] = true;
      } catch (e) {
        AppLogger.e('Sync service test failed: $e');
        results['sync'] = false;
      }
    } catch (e) {
      AppLogger.e('Error testing services: $e');
    }

    return results;
  }
}
