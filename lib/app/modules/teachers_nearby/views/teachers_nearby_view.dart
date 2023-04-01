import 'package:educate_io/app/modules/teachers_nearby/components/map_switcher.dart';
import 'package:educate_io/app/services/geo_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/teachers_nearby_controller.dart';

class TeachersNearbyView extends GetView<TeachersNearbyController> {
  const TeachersNearbyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MapSwitcher(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: TextField(
            controller: controller.searchController,
            decoration: InputDecoration(
              fillColor: Theme.of(context).colorScheme.primaryContainer,
              hintText: "Бургас",
              label: const Text("Място"),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            textInputAction: TextInputAction.search,
            onEditingComplete: () => controller.search(),
          ),
          actions: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(50),
              ),
              margin: const EdgeInsets.all(10),
              child: IconButton(
                onPressed: () => controller.search(),
                icon: const Icon(Icons.search),
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
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
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
        ),
        body: FutureBuilder(
          future: GeoService.getLocation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Obx(
              () => GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: snapshot.data ?? const LatLng(42.510578, 27.461014),
                  zoom: 16,
                ),
                zoomControlsEnabled: false,
                onMapCreated: (mapController) =>
                    controller.configureMap(mapController),
                mapType: MapType.hybrid,
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
          child: const Icon(Icons.navigation_rounded),
        ),
      ),
    );
  }
}
