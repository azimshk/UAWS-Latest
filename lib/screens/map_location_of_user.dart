import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uaws/screens/simple_google_map.dart';

import 'current_location.dart';

class MapLocationOfUser extends StatelessWidget {
  const MapLocationOfUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("location")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Get.to(() => const SimpleMapScreen());
            },
            child: Text("simple Google Map"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(() => const CurrentLocationScreen());
            },
            child: Text("My Current location"),
          ),
        ],
      ),
    );
  }
}
