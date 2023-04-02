import 'package:educate_io/app/modules/chats/chat_messages/controllers/location_picker_controller.dart';
import 'package:educate_io/app/modules/teachers_nearby/components/map_switcher.dart';
import 'package:educate_io/app/services/geo_service.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class LocationPickerView extends GetView<LocationPickerController> {
  const LocationPickerView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LocationPickerController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leadingWidth: 70,
        toolbarHeight: 70,
        backgroundColor: Colors.transparent,
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

          return Stack(
            children: [
              MapSwitcher(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: snapshot.data ?? const LatLng(42.510578, 27.461014),
                    zoom: 16,
                  ),
                  onCameraMove: (position) =>
                      controller.updatePosition(position),
                  onMapCreated: (mapController) =>
                      controller.mapController = mapController,
                  zoomControlsEnabled: false,
                  mapType: MapType.hybrid,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomGesturesEnabled: true,
                  rotateGesturesEnabled: false,
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                ),
              ),
              const Center(
                child: Icon(
                  Icons.location_on,
                  size: 50,
                  color: Colors.red,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              onPressed: () => controller.centerCamera(),
              child: const Icon(Icons.navigation_rounded)),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
              heroTag: "sendButton",
              onPressed: () => controller.sendLocation(),
              child: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
