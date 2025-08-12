import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/camera/camera_service.dart';
import '../../../services/location/location_service.dart';
import '../../../shared/models/media/photo_model.dart';
import '../../../core/theme/app_theme.dart';

class CameraScreen extends StatefulWidget {
  final String? associatedRecordId;
  final String? associatedRecordType;
  final Function(PhotoModel)? onPhotoTaken;
  final bool includeLocation;
  final bool compressImage;
  final String? initialDescription;

  const CameraScreen({
    super.key,
    this.associatedRecordId,
    this.associatedRecordType,
    this.onPhotoTaken,
    this.includeLocation = true,
    this.compressImage = true,
    this.initialDescription,
  });

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  final CameraService _cameraService = CameraService.instance;
  final LocationService _locationService = LocationService.instance;
  final TextEditingController _descriptionController = TextEditingController();

  bool _showDescription = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _descriptionController.text = widget.initialDescription ?? '';
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraController = _cameraService.controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize camera when app is resumed
      _cameraService.onInit();
    }
  }

  Future<void> _capturePhoto() async {
    try {
      final photo = await _cameraService.capturePhoto(
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        associatedRecordId: widget.associatedRecordId,
        associatedRecordType: widget.associatedRecordType,
        includeLocation: widget.includeLocation,
        compressImage: widget.compressImage,
      );

      if (photo != null) {
        // Show success message
        Get.snackbar(
          'Photo Captured',
          'Photo saved successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Call callback if provided
        widget.onPhotoTaken?.call(photo);

        // Return to previous screen
        Get.back(result: photo);
      } else {
        Get.snackbar(
          'Error',
          'Failed to capture photo',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to capture photo: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _switchCamera() async {
    final availableCameras = _cameraService.getAvailableCameras();
    if (availableCameras.length > 1) {
      final currentCamera = _cameraService.controller?.description;
      final nextCamera = availableCameras.firstWhere(
        (camera) => camera != currentCamera,
        orElse: () => availableCameras.first,
      );
      await _cameraService.switchCamera(nextCamera);
    }
  }

  Widget _buildCameraPreview() {
    return Obx(() {
      if (_cameraService.isInitializing.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_cameraService.currentError.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Camera Error',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                _cameraService.currentError.value,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _cameraService.onInit(),
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (!_cameraService.isCameraReady.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return _cameraService.getCameraPreview();
    });
  }

  Widget _buildLocationStatus() {
    return Obx(() {
      final locationService = _locationService;
      final currentPosition = locationService.currentPosition.value;
      final accuracy = locationService.currentAccuracy.value;

      if (!widget.includeLocation) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              locationService.isHighAccuracy
                  ? Icons.gps_fixed
                  : Icons.gps_not_fixed,
              color: locationService.isHighAccuracy
                  ? Colors.green
                  : Colors.orange,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              currentPosition != null
                  ? 'GPS: ±${accuracy.toStringAsFixed(0)}m'
                  : 'No GPS',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildDescriptionPanel() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _showDescription ? 120 : 0,
      child: Container(
        color: Colors.black54,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Add photo description...',
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview
            Positioned.fill(child: _buildCameraPreview()),

            // Top controls
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close button
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  // Location status
                  _buildLocationStatus(),

                  // Switch camera button
                  IconButton(
                    onPressed: _switchCamera,
                    icon: const Icon(
                      Icons.flip_camera_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),

            // Description panel
            Positioned(
              top: 70,
              left: 0,
              right: 0,
              child: _buildDescriptionPanel(),
            ),

            // Bottom controls
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Description toggle button
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showDescription = !_showDescription;
                      });
                    },
                    icon: Icon(
                      _showDescription
                          ? Icons.keyboard_hide
                          : Icons.description,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  // Capture button
                  Obx(
                    () => _cameraService.getCaptureButton(
                      onPressed: _capturePhoto,
                      size: 80,
                    ),
                  ),

                  // Gallery button (placeholder)
                  IconButton(
                    onPressed: () {
                      // TODO: Open gallery/photo list
                      Get.snackbar(
                        'Info',
                        'Photo gallery not implemented yet',
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                      );
                    },
                    icon: const Icon(
                      Icons.photo_library,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),

            // Loading overlay
            Obx(() {
              if (_cameraService.isCapturing.value) {
                return Container(
                  color: Colors.black54,
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 16),
                        Text(
                          'Capturing photo...',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}

/// Helper widget to easily open camera from anywhere
class CameraButton extends StatelessWidget {
  final String? associatedRecordId;
  final String? associatedRecordType;
  final Function(PhotoModel)? onPhotoTaken;
  final bool includeLocation;
  final bool compressImage;
  final String? initialDescription;
  final Widget? child;
  final String? label;

  const CameraButton({
    super.key,
    this.associatedRecordId,
    this.associatedRecordType,
    this.onPhotoTaken,
    this.includeLocation = true,
    this.compressImage = true,
    this.initialDescription,
    this.child,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Check camera permissions first
        final cameraService = CameraService.instance;
        if (!await cameraService.checkCameraPermissions()) {
          Get.snackbar(
            'Permission Required',
            'Camera permission is required to take photos',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }

        // Navigate to camera screen
        final result = await Get.to<PhotoModel>(
          () => CameraScreen(
            associatedRecordId: associatedRecordId,
            associatedRecordType: associatedRecordType,
            onPhotoTaken: onPhotoTaken,
            includeLocation: includeLocation,
            compressImage: compressImage,
            initialDescription: initialDescription,
          ),
        );

        if (result != null && onPhotoTaken != null) {
          onPhotoTaken!(result);
        }
      },
      child:
          child ??
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.camera_alt, color: Colors.white),
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
