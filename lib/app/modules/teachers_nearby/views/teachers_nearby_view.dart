import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/teachers_nearby_controller.dart';

class TeachersNearbyView extends GetView<TeachersNearbyController> {
  const TeachersNearbyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Obx(
            () => TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                fillColor: Theme.of(context).colorScheme.primaryContainer,
                hintText: "Бургас",
                label: const Text("Място"),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              textInputAction: TextInputAction.search,
              onEditingComplete: () => controller.search(),
            )
                .animate(
                  delay: 300.ms,
                  target: controller.showControls.value ? 1 : 0,
                )
                .scaleXY(
                  curve: Curves.easeOutCubic,
                  duration: 400.ms,
                  delay: 250.ms,
                  begin: -2,
                  end: 1,
                )
                .slideY(
                  end: 0,
                  begin: -5,
                  curve: Curves.easeOutQuint,
                  duration: 400.ms,
                )
                .then()
                .blurXY(
                  begin: 3,
                  end: 0,
                  duration: 150.ms,
                  curve: Curves.easeOut,
                ),
          ),
          actions: [
            Obx(
              () => Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(50),
                ),
                margin: const EdgeInsets.all(10),
                child: IconButton(
                  onPressed: () => controller.search(),
                  icon: const Icon(Icons.search),
                ),
              )
                  .animate(
                    delay: 300.ms,
                    target: controller.showControls.value ? 1 : 0,
                  )
                  .scaleXY(
                    curve: Curves.easeOutCubic,
                    duration: 400.ms,
                    delay: 250.ms,
                    begin: -2,
                    end: 1,
                  )
                  .slideY(
                    end: 0,
                    begin: -5,
                    curve: Curves.easeOutQuint,
                    duration: 400.ms,
                  )
                  .then()
                  .blurXY(
                    begin: 3,
                    end: 0,
                    duration: 150.ms,
                    curve: Curves.easeOut,
                  ),
            ),
          ],

          backgroundColor: Colors.transparent,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
          ),
          leadingWidth: 70,
          toolbarHeight: 70,
          leading: Obx(
            () => Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(50),
              ),
              margin: const EdgeInsets.all(10),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),
            )
                .animate(
                  delay: 300.ms,
                  target: controller.showControls.value ? 1 : 0,
                )
                .scaleXY(
                  curve: Curves.easeOutCubic,
                  duration: 400.ms,
                  delay: 250.ms,
                  begin: -2,
                  end: 1,
                )
                .slideY(
                  end: 0,
                  begin: -5,
                  curve: Curves.easeOutQuint,
                  duration: 400.ms,
                )
                .then()
                .blurXY(
                  begin: 3,
                  end: 0,
                  duration: 150.ms,
                  curve: Curves.easeOut,
                ),
          ),
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
        floatingActionButton: Obx(
          () => FloatingActionButton(
                  onPressed: () => controller.centerCamera(),
                  child: const Icon(Icons.navigation_rounded))
              .animate(
                delay: 300.ms,
                target: controller.showControls.value ? 1 : 0,
              )
              .scaleXY(
                curve: Curves.easeOutCubic,
                duration: 400.ms,
                delay: 200.ms,
                begin: -2,
                end: 1,
              )
              .slideY(
                end: 0,
                begin: 5,
                curve: Curves.easeOutQuint,
                duration: 400.ms,
              )
              .then()
              .blurXY(
                begin: 3,
                end: 0,
                duration: 150.ms,
                curve: Curves.easeOut,
              ),
        ));
  }
}
