import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../shared/models/media/location_record.dart';
import '../../core/utils/app_logger.dart';
import '../storage/location_storage_service.dart';

class LocationService extends GetxService {
  static LocationService get instance => Get.find();

  final _uuid = const Uuid();

  StreamSubscription<Position>? _positionStream;
  Timer? _backgroundTimer;

  // Reactive variables
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxBool isTracking = false.obs;
  final RxBool isLocationEnabled = false.obs;
  final RxString locationError = ''.obs;
  final RxList<LocationRecord> locationHistory = <LocationRecord>[].obs;
  final RxDouble currentAccuracy = 0.0.obs;

  // Location settings
  final LocationSettings _locationSettings = Platform.isAndroid
      ? AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
          intervalDuration: const Duration(seconds: 10),
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText: "UAWS is tracking location for field operations",
            notificationTitle: "Location Tracking Active",
            enableWakeLock: true,
          ),
        )
      : AppleSettings(
          accuracy: LocationAccuracy.high,
          activityType: ActivityType.other,
          distanceFilter: 5,
          pauseLocationUpdatesAutomatically: true,
          showBackgroundLocationIndicator: false,
        );

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeLocationService();
  }

  @override
  Future<void> onClose() async {
    await stopLocationTracking();
    super.onClose();
  }

  /// Initialize location service
  Future<void> _initializeLocationService() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      isLocationEnabled.value = serviceEnabled;

      if (!serviceEnabled) {
        locationError.value = 'Location services are disabled';
        return;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationError.value = 'Location permissions are denied';
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        locationError.value = 'Location permissions are permanently denied';
        return;
      }

      // Try to get current position
      await _updateCurrentPosition();

      AppLogger.i('Location service initialized successfully');
    } catch (e) {
      AppLogger.e('Error initializing location service: $e');
      locationError.value = 'Failed to initialize location service: $e';
    }
  }

  /// Update current position
  Future<void> _updateCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
      currentPosition.value = position;
      currentAccuracy.value = position.accuracy;
      locationError.value = '';
    } catch (e) {
      AppLogger.w('Could not get current position: $e');
      locationError.value = 'Could not get location: $e';
    }
  }

  /// Check location permissions
  Future<bool> checkLocationPermissions() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        locationError.value = 'Location services are disabled';
        return false;
      }

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        locationError.value = 'Location permissions are permanently denied';
        return false;
      }

      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      AppLogger.e('Error checking location permissions: $e');
      locationError.value = 'Permission check failed: $e';
      return false;
    }
  }

  /// Get current position with high accuracy
  Future<Position?> getCurrentPosition({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration? timeLimit,
  }) async {
    try {
      if (!await checkLocationPermissions()) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: timeLimit ?? const Duration(seconds: 15),
      );

      currentPosition.value = position;
      currentAccuracy.value = position.accuracy;
      locationError.value = '';

      // Save to history
      await _saveLocationToHistory(position);

      return position;
    } catch (e) {
      AppLogger.e('Error getting current position: $e');
      locationError.value = 'Failed to get location: $e';
      return null;
    }
  }

  /// Start real-time location tracking
  Future<void> startLocationTracking({
    String? associatedRecordId,
    String? associatedRecordType,
  }) async {
    if (isTracking.value) {
      AppLogger.i('Location tracking already active');
      return;
    }

    if (!await checkLocationPermissions()) {
      return;
    }

    try {
      _positionStream =
          Geolocator.getPositionStream(
            locationSettings: _locationSettings,
          ).listen(
            (position) async {
              currentPosition.value = position;
              currentAccuracy.value = position.accuracy;
              locationError.value = '';

              // Save to history
              await _saveLocationToHistory(
                position,
                associatedRecordId: associatedRecordId,
                associatedRecordType: associatedRecordType,
              );

              AppLogger.i(
                'Location updated: ${position.latitude}, ${position.longitude} (±${position.accuracy}m)',
              );
            },
            onError: (error) {
              AppLogger.e('Location tracking error: $error');
              locationError.value = 'Tracking error: $error';
            },
          );

      isTracking.value = true;
      AppLogger.i('Location tracking started');
    } catch (e) {
      AppLogger.e('Error starting location tracking: $e');
      locationError.value = 'Failed to start tracking: $e';
    }
  }

  /// Stop location tracking
  Future<void> stopLocationTracking() async {
    await _positionStream?.cancel();
    _positionStream = null;
    isTracking.value = false;
    AppLogger.i('Location tracking stopped');
  }

  /// Save location to history
  Future<void> _saveLocationToHistory(
    Position position, {
    String? associatedRecordId,
    String? associatedRecordType,
  }) async {
    try {
      final locationRecord = LocationRecord.fromPosition(
        position,
        id: _uuid.v4(),
        associatedRecordId: associatedRecordId,
        associatedRecordType: associatedRecordType,
      );

      await LocationStorageService.instance.saveLocation(locationRecord);

      // Update observable list
      locationHistory.insert(0, locationRecord);

      // Keep only last 100 locations in memory
      if (locationHistory.length > 100) {
        locationHistory.removeRange(100, locationHistory.length);
      }
    } catch (e) {
      AppLogger.e('Error saving location to history: $e');
    }
  }

  /// Calculate distance between two positions
  double calculateDistance(Position pos1, Position pos2) {
    return Geolocator.distanceBetween(
      pos1.latitude,
      pos1.longitude,
      pos2.latitude,
      pos2.longitude,
    );
  }

  /// Calculate distance from current position to a point
  double? distanceFromCurrent(double latitude, double longitude) {
    final current = currentPosition.value;
    if (current == null) return null;

    return Geolocator.distanceBetween(
      current.latitude,
      current.longitude,
      latitude,
      longitude,
    );
  }

  /// Get location accuracy status
  String getAccuracyStatus() {
    final accuracy = currentAccuracy.value;
    if (accuracy <= 5) return 'Excellent';
    if (accuracy <= 10) return 'Good';
    if (accuracy <= 30) return 'Fair';
    return 'Poor';
  }

  /// Check if location is high accuracy
  bool get isHighAccuracy => currentAccuracy.value <= 10.0;

  /// Format position for display
  String formatPosition(Position? position) {
    if (position == null) return 'Unknown location';

    return '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
  }

  /// Get location history for a specific record
  Future<List<LocationRecord>> getLocationHistory({
    String? associatedRecordId,
    String? associatedRecordType,
    DateTime? since,
    int? limit,
  }) async {
    return await LocationStorageService.instance.getLocationHistory(
      associatedRecordId: associatedRecordId,
      associatedRecordType: associatedRecordType,
      since: since,
      limit: limit,
    );
  }

  /// Open device location settings
  Future<void> openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
    } catch (e) {
      AppLogger.e('Error opening location settings: $e');
    }
  }

  /// Open app settings for permissions
  Future<void> openAppSettings() async {
    try {
      await Geolocator.openAppSettings();
    } catch (e) {
      AppLogger.e('Error opening app settings: $e');
    }
  }

  /// Request background location permission (Android only)
  Future<bool> requestBackgroundLocationPermission() async {
    if (!Platform.isAndroid) return true;

    try {
      final status = await Permission.locationAlways.request();
      return status.isGranted;
    } catch (e) {
      AppLogger.e('Error requesting background location permission: $e');
      return false;
    }
  }

  /// Enable background location tracking for field operations
  Future<void> enableBackgroundTracking({
    String? associatedRecordId,
    String? associatedRecordType,
  }) async {
    if (!await requestBackgroundLocationPermission()) {
      locationError.value = 'Background location permission required';
      return;
    }

    // Start location tracking
    await startLocationTracking(
      associatedRecordId: associatedRecordId,
      associatedRecordType: associatedRecordType,
    );

    // Set up periodic location updates
    _backgroundTimer = Timer.periodic(const Duration(minutes: 1), (
      timer,
    ) async {
      if (!isTracking.value) {
        timer.cancel();
        return;
      }

      await _updateCurrentPosition();
    });

    AppLogger.i('Background location tracking enabled');
  }

  /// Disable background location tracking
  Future<void> disableBackgroundTracking() async {
    await stopLocationTracking();
    _backgroundTimer?.cancel();
    _backgroundTimer = null;
    AppLogger.i('Background location tracking disabled');
  }
}
