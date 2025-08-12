import 'dart:async';
import 'package:get/get.dart';
import 'package:workmanager/workmanager.dart';
import '../../core/utils/app_logger.dart';
import '../storage/photo_storage_service.dart';
import '../storage/location_storage_service.dart';
import 'connectivity_service.dart';

// Background task identifiers
const String _photoSyncTask = 'photo_sync_task';
const String _locationSyncTask = 'location_sync_task';
const String _generalSyncTask = 'general_sync_task';

class SyncService extends GetxService {
  static SyncService get instance => Get.find();

  Timer? _periodicSyncTimer;
  bool _isInitialized = false;

  // Reactive variables
  final RxBool isSyncing = false.obs;
  final RxBool autoSyncEnabled = true.obs;
  final RxString lastSyncTime = ''.obs;
  final RxString syncError = ''.obs;
  final RxInt pendingPhotos = 0.obs;
  final RxInt pendingLocations = 0.obs;
  final RxDouble syncProgress = 0.0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeSyncService();
  }

  @override
  Future<void> onClose() async {
    await _cleanup();
    super.onClose();
  }

  /// Initialize sync service and background workers
  Future<void> _initializeSyncService() async {
    try {
      // Initialize Workmanager for background tasks
      await Workmanager().initialize(
        _callbackDispatcher,
        isInDebugMode: false, // Set to false in production
      );

      // Set up connectivity listener for auto-sync
      ConnectivityService.instance.addOnlineCallback(_onConnectionRestored);

      // Start periodic sync check
      _startPeriodicSync();

      // Update pending counts
      await _updatePendingCounts();

      _isInitialized = true;
      AppLogger.i('Sync service initialized successfully');
    } catch (e) {
      AppLogger.e('Error initializing sync service: $e');
      syncError.value = 'Failed to initialize sync: $e';
    }
  }

  /// Clean up resources
  Future<void> _cleanup() async {
    _periodicSyncTimer?.cancel();
    _periodicSyncTimer = null;

    ConnectivityService.instance.removeOnlineCallback(_onConnectionRestored);

    // Cancel all background tasks
    await Workmanager().cancelAll();
  }

  /// Start periodic sync check (every 15 minutes)
  void _startPeriodicSync() {
    _periodicSyncTimer = Timer.periodic(
      const Duration(minutes: 15),
      (_) => _scheduleSyncIfNeeded(),
    );
  }

  /// Called when connection is restored
  void _onConnectionRestored() {
    if (autoSyncEnabled.value) {
      _scheduleSyncIfNeeded();
    }
  }

  /// Schedule sync if needed and connection is available
  Future<void> _scheduleSyncIfNeeded() async {
    if (!_isInitialized || isSyncing.value) return;

    if (!ConnectivityService.instance.isOnline.value) {
      AppLogger.d('Skipping sync - no connection');
      return;
    }

    await _updatePendingCounts();

    if (pendingPhotos.value > 0 || pendingLocations.value > 0) {
      await syncNow();
    }
  }

  /// Update pending sync counts
  Future<void> _updatePendingCounts() async {
    try {
      final unsyncedPhotos = await PhotoStorageService.instance
          .getUnsyncedPhotos();
      final unsyncedLocations = await LocationStorageService.instance
          .getUnsyncedLocations();

      pendingPhotos.value = unsyncedPhotos.length;
      pendingLocations.value = unsyncedLocations.length;
    } catch (e) {
      AppLogger.e('Error updating pending counts: $e');
    }
  }

  /// Perform immediate sync
  Future<void> syncNow({bool force = false}) async {
    if (isSyncing.value && !force) {
      AppLogger.d('Sync already in progress');
      return;
    }

    if (!ConnectivityService.instance.isOnline.value) {
      syncError.value = 'No internet connection available';
      AppLogger.w('Cannot sync - no connection');
      return;
    }

    try {
      isSyncing.value = true;
      syncError.value = '';
      syncProgress.value = 0.0;

      AppLogger.i('Starting manual sync');

      // Sync photos first
      await _syncPhotos();
      syncProgress.value = 0.5;

      // Then sync locations
      await _syncLocations();
      syncProgress.value = 1.0;

      // Update counts
      await _updatePendingCounts();

      lastSyncTime.value = DateTime.now().toIso8601String();
      AppLogger.i('Manual sync completed successfully');
    } catch (e) {
      AppLogger.e('Error during manual sync: $e');
      syncError.value = 'Sync failed: $e';
    } finally {
      isSyncing.value = false;
      syncProgress.value = 0.0;
    }
  }

  /// Sync photos to remote storage
  Future<void> _syncPhotos() async {
    try {
      final unsyncedPhotos = await PhotoStorageService.instance
          .getUnsyncedPhotos();

      if (unsyncedPhotos.isEmpty) {
        AppLogger.d('No photos to sync');
        return;
      }

      AppLogger.i('Syncing ${unsyncedPhotos.length} photos');

      for (int i = 0; i < unsyncedPhotos.length; i++) {
        final photo = unsyncedPhotos[i];

        try {
          // TODO: Upload photo to Firebase Storage
          // For now, just mark as synced after a delay to simulate upload
          await Future.delayed(const Duration(milliseconds: 500));

          await PhotoStorageService.instance.markPhotoAsSynced(
            photo.id,
            'firebase://photos/${photo.id}.jpg', // Simulated remote path
          );

          AppLogger.d('Photo synced: ${photo.id}');
        } catch (e) {
          AppLogger.e('Failed to sync photo ${photo.id}: $e');
          // Continue with other photos
        }

        // Update progress
        final progress = (i + 1) / unsyncedPhotos.length * 0.5;
        syncProgress.value = progress;
      }
    } catch (e) {
      AppLogger.e('Error syncing photos: $e');
      throw Exception('Photo sync failed: $e');
    }
  }

  /// Sync locations to remote storage
  Future<void> _syncLocations() async {
    try {
      final unsyncedLocations = await LocationStorageService.instance
          .getUnsyncedLocations();

      if (unsyncedLocations.isEmpty) {
        AppLogger.d('No locations to sync');
        return;
      }

      AppLogger.i('Syncing ${unsyncedLocations.length} locations');

      for (int i = 0; i < unsyncedLocations.length; i++) {
        final location = unsyncedLocations[i];

        try {
          // TODO: Upload location to Firebase Firestore
          // For now, just mark as synced after a delay to simulate upload
          await Future.delayed(const Duration(milliseconds: 200));

          await LocationStorageService.instance.markLocationAsSynced(
            location.id,
          );

          AppLogger.d('Location synced: ${location.id}');
        } catch (e) {
          AppLogger.e('Failed to sync location ${location.id}: $e');
          // Continue with other locations
        }

        // Update progress
        final progress = 0.5 + ((i + 1) / unsyncedLocations.length * 0.5);
        syncProgress.value = progress;
      }
    } catch (e) {
      AppLogger.e('Error syncing locations: $e');
      throw Exception('Location sync failed: $e');
    }
  }

  /// Enable automatic sync
  void enableAutoSync() {
    autoSyncEnabled.value = true;
    _scheduleSyncIfNeeded();
    AppLogger.i('Auto-sync enabled');
  }

  /// Disable automatic sync
  void disableAutoSync() {
    autoSyncEnabled.value = false;
    AppLogger.i('Auto-sync disabled');
  }

  /// Schedule background sync (when app is not active)
  Future<void> scheduleBackgroundSync() async {
    try {
      // Cancel existing tasks
      await Workmanager().cancelByUniqueName(_generalSyncTask);

      // Schedule new background sync
      await Workmanager().registerPeriodicTask(
        _generalSyncTask,
        _generalSyncTask,
        frequency: const Duration(hours: 1), // Minimum is 15 minutes
        constraints: Constraints(
          networkType: NetworkType.connected,
          requiresBatteryNotLow: true,
        ),
      );

      AppLogger.i('Background sync scheduled');
    } catch (e) {
      AppLogger.e('Error scheduling background sync: $e');
    }
  }

  /// Cancel background sync
  Future<void> cancelBackgroundSync() async {
    try {
      await Workmanager().cancelByUniqueName(_generalSyncTask);
      AppLogger.i('Background sync cancelled');
    } catch (e) {
      AppLogger.e('Error cancelling background sync: $e');
    }
  }

  /// Get sync status information
  Map<String, dynamic> getSyncStatus() {
    return {
      'isSyncing': isSyncing.value,
      'autoSyncEnabled': autoSyncEnabled.value,
      'lastSyncTime': lastSyncTime.value,
      'syncError': syncError.value,
      'pendingPhotos': pendingPhotos.value,
      'pendingLocations': pendingLocations.value,
      'syncProgress': syncProgress.value,
      'isOnline': ConnectivityService.instance.isOnline.value,
      'connectionType': ConnectivityService.instance.connectionType.value,
    };
  }

  /// Force sync of specific record type
  Future<void> syncRecord({
    required String recordId,
    required String recordType,
  }) async {
    try {
      AppLogger.i('Syncing specific record: $recordType/$recordId');

      // Sync photos for this record
      final recordPhotos = await PhotoStorageService.instance.getPhotosByRecord(
        recordId,
        recordType,
      );

      for (final photo in recordPhotos.where((p) => !p.isSynced)) {
        // TODO: Upload specific photo
        await PhotoStorageService.instance.markPhotoAsSynced(
          photo.id,
          'firebase://photos/${photo.id}.jpg',
        );
      }

      // Sync locations for this record
      final recordLocations = await LocationStorageService.instance
          .getLocationsByRecord(recordId, recordType);

      for (final location in recordLocations.where((l) => !l.isSynced)) {
        // TODO: Upload specific location
        await LocationStorageService.instance.markLocationAsSynced(location.id);
      }

      AppLogger.i('Record sync completed: $recordType/$recordId');
    } catch (e) {
      AppLogger.e('Error syncing record: $e');
      throw Exception('Record sync failed: $e');
    }
  }
}

/// Background task callback dispatcher
@pragma('vm:entry-point')
void _callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      AppLogger.i('Executing background task: $task');

      switch (task) {
        case _photoSyncTask:
        case _locationSyncTask:
        case _generalSyncTask:
          // Perform background sync
          // Note: In background tasks, we need to initialize services
          // TODO: Implement background sync logic
          AppLogger.i('Background sync task completed');
          break;
        default:
          AppLogger.w('Unknown background task: $task');
      }

      return Future.value(true);
    } catch (e) {
      AppLogger.e('Background task error: $e');
      return Future.value(false);
    }
  });
}
