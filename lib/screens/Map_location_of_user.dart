import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:uaws/screens/simple_google_map.dart';

import 'current_location.dart';

class Map_location_of_user extends StatelessWidget {
  const Map_location_of_user({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("location"),
      ),
     body:
      Column(
        children: [
          ElevatedButton(onPressed: (){
            Get.to(() => const SimpleMapScreen());
          }, child: Text("simple Google Map")
          ),
          ElevatedButton(onPressed: (){
            Get.to(() => const CurrentLocationScreen());

          }, child: Text("My Current location")
          ),

        ],
      ),
    );
  }
}
