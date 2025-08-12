import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../../core/utils/app_logger.dart';

enum ConnectionStatus { online, offline, checking }

class ConnectivityService extends GetxService {
  static ConnectivityService get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Reactive variables
  final Rx<ConnectionStatus> connectionStatus = ConnectionStatus.checking.obs;
  final RxBool isOnline = false.obs;
  final RxString connectionType = 'none'.obs;
  final RxList<ConnectivityResult> activeConnections =
      <ConnectivityResult>[].obs;

  // Callback functions for status changes
  final List<VoidCallback> _onlineCallbacks = [];
  final List<VoidCallback> _offlineCallbacks = [];

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeConnectivity();
    _startListening();
  }

  @override
  Future<void> onClose() async {
    await _connectivitySubscription?.cancel();
    super.onClose();
  }

  /// Initialize connectivity service
  Future<void> _initializeConnectivity() async {
    try {
      // Check initial connection status
      final result = await _connectivity.checkConnectivity();
      await _updateConnectionStatus(result);

      AppLogger.i('Connectivity service initialized');
    } catch (e) {
      AppLogger.e('Error initializing connectivity service: $e');
      connectionStatus.value = ConnectionStatus.offline;
      isOnline.value = false;
    }
  }

  /// Start listening for connectivity changes
  void _startListening() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
      onError: (error) {
        AppLogger.e('Connectivity stream error: $error');
        connectionStatus.value = ConnectionStatus.offline;
        isOnline.value = false;
      },
    );
  }

  /// Update connection status based on connectivity result
  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    activeConnections.value = results;

    // Check if any connection is available
    final hasConnection = results.any(
      (result) => result != ConnectivityResult.none,
    );

    final wasOnline = isOnline.value;
    isOnline.value = hasConnection;

    if (hasConnection) {
      connectionStatus.value = ConnectionStatus.online;
      connectionType.value = _getConnectionType(results);

      // Trigger online callbacks if status changed
      if (!wasOnline) {
        _triggerOnlineCallbacks();
      }

      AppLogger.i('Connection available: ${connectionType.value}');
    } else {
      connectionStatus.value = ConnectionStatus.offline;
      connectionType.value = 'none';

      // Trigger offline callbacks if status changed
      if (wasOnline) {
        _triggerOfflineCallbacks();
      }

      AppLogger.i('No connection available');
    }
  }

  /// Get readable connection type from results
  String _getConnectionType(List<ConnectivityResult> results) {
    if (results.isEmpty) return 'none';

    final types = <String>[];
    for (final result in results) {
      switch (result) {
        case ConnectivityResult.wifi:
          types.add('WiFi');
          break;
        case ConnectivityResult.mobile:
          types.add('Mobile');
          break;
        case ConnectivityResult.ethernet:
          types.add('Ethernet');
          break;
        case ConnectivityResult.vpn:
          types.add('VPN');
          break;
        case ConnectivityResult.bluetooth:
          types.add('Bluetooth');
          break;
        case ConnectivityResult.other:
          types.add('Other');
          break;
        case ConnectivityResult.none:
          // Skip none results
          break;
      }
    }

    return types.isEmpty ? 'none' : types.join(', ');
  }

  /// Trigger online callbacks
  void _triggerOnlineCallbacks() {
    for (final callback in _onlineCallbacks) {
      try {
        callback();
      } catch (e) {
        AppLogger.e('Error in online callback: $e');
      }
    }
  }

  /// Trigger offline callbacks
  void _triggerOfflineCallbacks() {
    for (final callback in _offlineCallbacks) {
      try {
        callback();
      } catch (e) {
        AppLogger.e('Error in offline callback: $e');
      }
    }
  }

  /// Add callback for when device comes online
  void addOnlineCallback(VoidCallback callback) {
    _onlineCallbacks.add(callback);
  }

  /// Add callback for when device goes offline
  void addOfflineCallback(VoidCallback callback) {
    _offlineCallbacks.add(callback);
  }

  /// Remove online callback
  void removeOnlineCallback(VoidCallback callback) {
    _onlineCallbacks.remove(callback);
  }

  /// Remove offline callback
  void removeOfflineCallback(VoidCallback callback) {
    _offlineCallbacks.remove(callback);
  }

  /// Check if device has WiFi connection
  bool get hasWiFi => activeConnections.contains(ConnectivityResult.wifi);

  /// Check if device has mobile connection
  bool get hasMobile => activeConnections.contains(ConnectivityResult.mobile);

  /// Check if device has ethernet connection
  bool get hasEthernet =>
      activeConnections.contains(ConnectivityResult.ethernet);

  /// Check if connection is metered (mobile data)
  bool get isMeteredConnection => hasMobile && !hasWiFi && !hasEthernet;

  /// Check if connection is unmetered (WiFi/Ethernet)
  bool get isUnmeteredConnection => hasWiFi || hasEthernet;

  /// Get connection quality indicator
  String get connectionQuality {
    if (!isOnline.value) return 'No Connection';
    if (hasWiFi || hasEthernet) return 'Good';
    if (hasMobile) return 'Fair';
    return 'Unknown';
  }

  /// Manually refresh connection status
  Future<void> refreshConnectionStatus() async {
    try {
      connectionStatus.value = ConnectionStatus.checking;
      final result = await _connectivity.checkConnectivity();
      await _updateConnectionStatus(result);
    } catch (e) {
      AppLogger.e('Error refreshing connection status: $e');
      connectionStatus.value = ConnectionStatus.offline;
      isOnline.value = false;
    }
  }

  /// Wait for online connection (useful for sync operations)
  Future<void> waitForConnection({Duration? timeout}) async {
    if (isOnline.value) return;

    final completer = Completer<void>();
    late final VoidCallback callback;

    callback = () {
      removeOnlineCallback(callback);
      if (!completer.isCompleted) {
        completer.complete();
      }
    };

    addOnlineCallback(callback);

    if (timeout != null) {
      Future.delayed(timeout, () {
        removeOnlineCallback(callback);
        if (!completer.isCompleted) {
          completer.completeError(
            TimeoutException('Timeout waiting for connection', timeout),
          );
        }
      });
    }

    return completer.future;
  }

  /// Execute function when online, queue for later if offline
  Future<T?> executeWhenOnline<T>(
    Future<T> Function() function, {
    Duration? timeout,
  }) async {
    if (isOnline.value) {
      return await function();
    }

    // Wait for connection if offline
    try {
      await waitForConnection(timeout: timeout);
      return await function();
    } catch (e) {
      AppLogger.w('Could not execute function - no connection: $e');
      return null;
    }
  }

  /// Get network information for debugging
  Map<String, dynamic> getNetworkInfo() {
    return {
      'isOnline': isOnline.value,
      'connectionStatus': connectionStatus.value.toString(),
      'connectionType': connectionType.value,
      'activeConnections': activeConnections.map((c) => c.toString()).toList(),
      'hasWiFi': hasWiFi,
      'hasMobile': hasMobile,
      'hasEthernet': hasEthernet,
      'isMetered': isMeteredConnection,
      'quality': connectionQuality,
    };
  }
}
