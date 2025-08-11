import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../shared/controllers/simple_google_map_controller.dart';
// import '../controllers/simple_map_controller.dart';

class SimpleMapScreen extends StatelessWidget {
  const SimpleMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create controller instance using Get.put
    final SimpleMapController controller = Get.put(SimpleMapController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Google Map"),
        centerTitle: true,
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: GoogleMap(
        initialCameraPosition: SimpleMapController.initialPosition,
        mapType: MapType.normal,
        onMapCreated: controller.onMapCreated,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.goToLake,
        label: const Text("To the lake!"),
        icon: const Icon(Icons.directions_boat),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
    );
  }
}
