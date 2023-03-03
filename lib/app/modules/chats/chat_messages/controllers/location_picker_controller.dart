import 'package:educate_io/app/services/geo_service.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerController extends GetxController {
  late GoogleMapController mapController;

  final cameraPosition =
      const CameraPosition(target: LatLng(42.510578, 27.461014)).obs;

  Future<void> configureMap(GoogleMapController newMapController) async {
    mapController = newMapController;
    cameraPosition.value =
        CameraPosition(target: await GeoService.getLocation());
  }

  Future<void> centerCamera() async {
    await mapController.animateCamera(
        CameraUpdate.newLatLngZoom(await GeoService.getLocation(), 16));
  }

  void updatePosition(CameraPosition position) =>
      cameraPosition.value = position;

  void sendLocation() {
    Get.back(result: cameraPosition.value.target);
  }
}
