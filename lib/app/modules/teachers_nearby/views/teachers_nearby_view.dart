import 'package:cached_network_image/cached_network_image.dart';
import 'package:educate_io/app/modules/teachers_nearby/components/filter_bottom_sheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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

          return GoogleMap(
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
            markers: controller.teachers
                .map(
                  (latlng) => Marker(
                    markerId: MarkerId(latlng.toString()),
                    position: latlng,
                    flat: false,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueMagenta),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.grey.shade800,
                        content: const Text(
                          "Учител",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    consumeTapEvents: false,
                  ),
                )
                .toSet(),
          );
        },
      ),
    );
  }
}
