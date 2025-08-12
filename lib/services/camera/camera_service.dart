import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../shared/models/media/photo_model.dart';
import '../../core/utils/app_logger.dart';
import '../location/location_service.dart';
import '../storage/photo_storage_service.dart';

class CameraService extends GetxService {
  static CameraService get instance => Get.find();

  final _uuid = const Uuid();

  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  bool _isInitialized = false;

  // Reactive variables
  final RxBool isInitializing = false.obs;
  final RxBool isCameraReady = false.obs;
  final RxBool isCapturing = false.obs;
  final RxString currentError = ''.obs;

  List<CameraDescription> get cameras => _cameras;
  CameraController? get controller => _controller;
  bool get isInitialized => _isInitialized;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeCameras();
  }

  @override
  Future<void> onClose() async {
    await _disposeController();
    super.onClose();
  }

  /// Initialize available cameras
  Future<void> _initializeCameras() async {
    try {
      isInitializing.value = true;
      currentError.value = '';

      _cameras = await availableCameras();
      AppLogger.i('Found ${_cameras.length} cameras');

      if (_cameras.isNotEmpty) {
        await _initializeController(_cameras.first);
      }
    } catch (e) {
      AppLogger.e('Error initializing cameras: $e');
      currentError.value = 'Failed to initialize camera: $e';
    } finally {
      isInitializing.value = false;
    }
  }

  /// Initialize camera controller
  Future<void> _initializeController(CameraDescription camera) async {
    try {
      await _disposeController();

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
      _isInitialized = true;
      isCameraReady.value = true;
      AppLogger.i('Camera controller initialized successfully');
    } catch (e) {
      AppLogger.e('Error initializing camera controller: $e');
      currentError.value = 'Failed to initialize camera: $e';
      _isInitialized = false;
      isCameraReady.value = false;
    }
  }

  /// Dispose camera controller
  Future<void> _disposeController() async {
    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
      _isInitialized = false;
      isCameraReady.value = false;
    }
  }

  /// Switch to a different camera
  Future<void> switchCamera(CameraDescription camera) async {
    if (_cameras.contains(camera)) {
      await _initializeController(camera);
    }
  }

  /// Check camera permissions
  Future<bool> checkCameraPermissions() async {
    try {
      final cameraStatus = await Permission.camera.status;

      if (cameraStatus.isDenied) {
        final result = await Permission.camera.request();
        return result.isGranted;
      }

      return cameraStatus.isGranted;
    } catch (e) {
      AppLogger.e('Error checking camera permissions: $e');
      return false;
    }
  }

  /// Capture photo with GPS coordinates and metadata
  Future<PhotoModel?> capturePhoto({
    String? description,
    String? associatedRecordId,
    String? associatedRecordType,
    bool includeLocation = true,
    bool compressImage = true,
  }) async {
    if (!_isInitialized || _controller == null) {
      currentError.value = 'Camera not initialized';
      return null;
    }

    if (!await checkCameraPermissions()) {
      currentError.value = 'Camera permission denied';
      return null;
    }

    try {
      isCapturing.value = true;
      currentError.value = '';

      // Capture the image
      final XFile imageFile = await _controller!.takePicture();

      // Get current location if requested
      Position? position;
      if (includeLocation) {
        try {
          position = await LocationService.instance.getCurrentPosition();
        } catch (e) {
          AppLogger.w('Could not get location for photo: $e');
        }
      }

      // Generate unique ID for the photo
      final photoId = _uuid.v4();

      // Get app documents directory
      final directory = await getApplicationDocumentsDirectory();
      final photosDir = Directory('${directory.path}/photos');
      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }

      // Generate final filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final finalPath = '${photosDir.path}/${photoId}_$timestamp.jpg';

      File finalFile;

      if (compressImage) {
        // Compress the image
        final compressedFile = await _compressImage(
          File(imageFile.path),
          finalPath,
        );
        finalFile = compressedFile;
      } else {
        // Just move the file
        finalFile = await File(imageFile.path).copy(finalPath);
      }

      // Add GPS coordinates to EXIF data if available
      if (position != null) {
        await _addGpsToExif(finalFile, position);
      }

      // Get file size
      final fileSize = await finalFile.length();

      // Create PhotoModel
      final photo = PhotoModel(
        id: photoId,
        localPath: finalFile.path,
        latitude: position?.latitude,
        longitude: position?.longitude,
        capturedAt: DateTime.now(),
        fileSize: fileSize,
        mimeType: 'image/jpeg',
        isCompressed: compressImage,
        description: description,
        associatedRecordId: associatedRecordId,
        associatedRecordType: associatedRecordType,
        metadata: {
          'camera': _controller!.description.name,
          'resolution': _controller!.value.previewSize?.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        },
      );

      // Store in local database
      await PhotoStorageService.instance.savePhoto(photo);

      AppLogger.i('Photo captured successfully: $photoId');

      // Clean up temporary file
      try {
        await File(imageFile.path).delete();
      } catch (e) {
        AppLogger.w('Could not delete temporary file: $e');
      }

      return photo;
    } catch (e) {
      AppLogger.e('Error capturing photo: $e');
      currentError.value = 'Failed to capture photo: $e';
      return null;
    } finally {
      isCapturing.value = false;
    }
  }

  /// Compress image to reduce file size
  Future<File> _compressImage(File file, String targetPath) async {
    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 85,
        minWidth: 1024,
        minHeight: 1024,
        format: CompressFormat.jpeg,
      );

      if (result != null) {
        return File(result.path);
      } else {
        // If compression fails, just copy the original
        return await file.copy(targetPath);
      }
    } catch (e) {
      AppLogger.w('Image compression failed, using original: $e');
      return await file.copy(targetPath);
    }
  }

  /// Add GPS coordinates to EXIF data
  Future<void> _addGpsToExif(File imageFile, Position position) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final originalImage = img.decodeImage(bytes);

      if (originalImage == null) return;

      // For now, just re-encode the image without EXIF modifications
      // TODO: Implement proper GPS EXIF writing when needed
      final encodedImage = img.encodeJpg(originalImage);
      await imageFile.writeAsBytes(encodedImage);

      AppLogger.i('Image processed (GPS EXIF not yet implemented)');
    } catch (e) {
      AppLogger.w('Could not process image: $e');
    }
  }

  /// Get camera preview widget
  Widget getCameraPreview() {
    if (!_isInitialized || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return CameraPreview(_controller!);
  }

  /// Get capture button widget
  Widget getCaptureButton({VoidCallback? onPressed, double size = 70.0}) {
    return Obx(
      () => GestureDetector(
        onTap: isCapturing.value ? null : onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 3),
          ),
          child: isCapturing.value
              ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.black,
                  ),
                )
              : const Icon(Icons.camera_alt, color: Colors.black, size: 30),
        ),
      ),
    );
  }

  /// Get available cameras for switching
  List<CameraDescription> getAvailableCameras() {
    return _cameras;
  }

  /// Get front camera if available
  CameraDescription? getFrontCamera() {
    return _cameras
        .where((camera) => camera.lensDirection == CameraLensDirection.front)
        .firstOrNull;
  }

  /// Get back camera if available
  CameraDescription? getBackCamera() {
    return _cameras
        .where((camera) => camera.lensDirection == CameraLensDirection.back)
        .firstOrNull;
  }
}
