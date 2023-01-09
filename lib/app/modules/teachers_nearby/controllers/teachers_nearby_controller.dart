import 'package:educate_io/app/modules/teachers_nearby/components/filter_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TeachersNearbyController extends GetxController {
  Set<LatLng> teachers = {
    LatLng(42.526659, 27.463060),
    LatLng(42.517423, 27.452975),
  };

  late GoogleMapController mapController;

  final isVisible = true.obs;

  @override
  void onClose() {
    isVisible.value = false;
    mapController.dispose();
    super.onClose();
  }

  void configureMap(GoogleMapController controller) {
    mapController = controller;
  }

  Future<LatLng> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    var position = await Geolocator.getCurrentPosition();
    return Future.value(LatLng(position.latitude, position.longitude));
  }

  void showFilters() {
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) => FilterBottomSheet(),
    );
  }
}
