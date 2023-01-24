import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/teachers_nearby_controller.dart';

class TeachersNearbyView extends GetView<TeachersNearbyController> {
  TeachersNearbyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        leadingWidth: 70,
        toolbarHeight: 70,
        leading: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(50),
          ),
          margin: const EdgeInsets.all(10),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(50),
            ),
            margin: const EdgeInsets.all(10),
            child: IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => controller.showFilters(),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: controller.getLocation(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Obx(
            () => GoogleMap(
              initialCameraPosition: CameraPosition(
                target: snapshot.data ??
                    const LatLng(37.42796133580664, -122.085749655962),
                zoom: 16,
              ),
              zoomControlsEnabled: false,
              onMapCreated: (mapController) =>
                  controller.configureMap(mapController),
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomGesturesEnabled: true,
              rotateGesturesEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              markers: controller.markers.toSet(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => controller.centerCamera(),
          child: Icon(Icons.navigation_rounded)),
    );
  }
}
