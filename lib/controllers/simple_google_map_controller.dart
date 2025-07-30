import 'dart:async';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SimpleMapController extends GetxController {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.0,
  );

  static const CameraPosition targetPosition = CameraPosition(
    target: LatLng(37.43296265331129, -122.08832357078792),
    zoom: 14.0,
    bearing: 192.0,
    tilt: 60,
  );

  void onMapCreated(GoogleMapController controller) {
    if (!_controller.isCompleted) {
      _controller.complete(controller);
    }
  }

  Future<void> goToLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(targetPosition));
  }

  @override
  void onClose() {
    // Clean up resources when controller is disposed
    super.onClose();
  }
}
