import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../services/location/location_service.dart';
import '../../../core/theme/app_theme.dart';

class LocationWidget extends StatelessWidget {
  final bool showAccuracy;
  final bool showAddress;
  final bool compact;
  final VoidCallback? onTap;

  const LocationWidget({
    super.key,
    this.showAccuracy = true,
    this.showAddress = false,
    this.compact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final locationService = LocationService.instance;

    return Obx(() {
      final position = locationService.currentPosition.value;
      final accuracy = locationService.currentAccuracy.value;
      final isTracking = locationService.isTracking.value;
      final error = locationService.locationError.value;

      if (error.isNotEmpty && position == null) {
        return _buildErrorWidget(error);
      }

      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: compact
              ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
              : const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getStatusColor(position, accuracy).withValues(alpha: 0.1),
            border: Border.all(
              color: _getStatusColor(position, accuracy),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: compact
              ? _buildCompactView(position, accuracy, isTracking)
              : _buildFullView(position, accuracy, isTracking),
        ),
      );
    });
  }

  Widget _buildCompactView(
    Position? position,
    double accuracy,
    bool isTracking,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _getLocationIcon(position, accuracy, isTracking),
          size: 16,
          color: _getStatusColor(position, accuracy),
        ),
        const SizedBox(width: 4),
        Text(
          _getStatusText(position, accuracy),
          style: TextStyle(
            fontSize: 12,
            color: _getStatusColor(position, accuracy),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFullView(Position? position, double accuracy, bool isTracking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              _getLocationIcon(position, accuracy, isTracking),
              size: 20,
              color: _getStatusColor(position, accuracy),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                position != null ? 'Location Available' : 'Getting Location...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(position, accuracy),
                ),
              ),
            ),
            if (isTracking)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'TRACKING',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        if (position != null) ...[
          const SizedBox(height: 8),
          Text(
            '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}',
            style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
          ),
          if (showAccuracy) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.my_location, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Accuracy: ±${accuracy.toStringAsFixed(0)}m (${_getAccuracyDescription(accuracy)})',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildErrorWidget(String error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        border: Border.all(color: Colors.red, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_off, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Location Error',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                Text(
                  error,
                  style: const TextStyle(fontSize: 12, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getLocationIcon(
    Position? position,
    double accuracy,
    bool isTracking,
  ) {
    if (position == null) return Icons.location_searching;
    if (isTracking) return Icons.gps_fixed;
    if (accuracy <= 10) return Icons.gps_fixed;
    if (accuracy <= 30) return Icons.gps_not_fixed;
    return Icons.location_on;
  }

  Color _getStatusColor(Position? position, double accuracy) {
    if (position == null) return Colors.orange;
    if (accuracy <= 10) return Colors.green;
    if (accuracy <= 30) return Colors.orange;
    return Colors.red;
  }

  String _getStatusText(Position? position, double accuracy) {
    if (position == null) return 'Searching...';
    return '±${accuracy.toStringAsFixed(0)}m';
  }

  String _getAccuracyDescription(double accuracy) {
    if (accuracy <= 5) return 'Excellent';
    if (accuracy <= 10) return 'Good';
    if (accuracy <= 30) return 'Fair';
    return 'Poor';
  }
}

class LocationControls extends StatelessWidget {
  final String? associatedRecordId;
  final String? associatedRecordType;

  const LocationControls({
    super.key,
    this.associatedRecordId,
    this.associatedRecordType,
  });

  @override
  Widget build(BuildContext context) {
    final locationService = LocationService.instance;

    return Obx(() {
      final isTracking = locationService.isTracking.value;
      final isOnline = locationService.isLocationEnabled.value;

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Location Tracking',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Location status widget
              LocationWidget(showAccuracy: true, compact: false),

              const SizedBox(height: 16),

              // Control buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isOnline
                          ? (isTracking
                                ? () => locationService.stopLocationTracking()
                                : () => locationService.startLocationTracking(
                                    associatedRecordId: associatedRecordId,
                                    associatedRecordType: associatedRecordType,
                                  ))
                          : null,
                      icon: Icon(isTracking ? Icons.stop : Icons.play_arrow),
                      label: Text(
                        isTracking ? 'Stop Tracking' : 'Start Tracking',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isTracking
                            ? Colors.red
                            : AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => locationService.getCurrentPosition(),
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh Location',
                  ),
                ],
              ),

              // Additional info
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      isTracking
                          ? 'Location is being tracked and saved for this record'
                          : 'Enable tracking to record location history',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

class LocationButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? label;
  final bool compact;

  const LocationButton({
    super.key,
    this.onPressed,
    this.label,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          onPressed ??
          () async {
            final locationService = LocationService.instance;

            if (!await locationService.checkLocationPermissions()) {
              Get.snackbar(
                'Permission Required',
                'Location permission is required',
                backgroundColor: Colors.orange,
                colorText: Colors.white,
              );
              return;
            }

            await locationService.getCurrentPosition();
          },
      child: compact
          ? LocationWidget(compact: true, onTap: onPressed)
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on, color: Colors.white),
                  if (label != null) ...[
                    const SizedBox(width: 8),
                    Text(label!, style: const TextStyle(color: Colors.white)),
                  ],
                ],
              ),
            ),
    );
  }
}
