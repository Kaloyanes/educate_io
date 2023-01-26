import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/modules/teachers_nearby/components/filter_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TeachersNearbyController extends GetxController {
  late GoogleMapController mapController;

  final RxList<Marker> markers = <Marker>[].obs;

  final isVisible = true.obs;

  @override
  void onClose() {
    isVisible.value = false;
    mapController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    getLocations();
    super.onInit();
  }

  void configureMap(GoogleMapController controller) =>
      mapController = controller;

  Marker template(LatLng latlng) {
    return Marker(
      markerId: MarkerId(latlng.toString()),
      position: latlng,
      flat: false,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      onTap: () => ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey.shade800,
          content: const Text(
            "Учител",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      consumeTapEvents: false,
    );
  }

  Future<void> getLocations() async {
    var collection =
        await FirebaseFirestore.instance.collection("locations").get();

    for (var doc in collection.docs) {
      var value = doc.get("place") as GeoPoint;
      if (doc.id == FirebaseAuth.instance.currentUser?.uid) continue;

      inspect(value);

      markers.add(template(LatLng(value.latitude, value.longitude)));
    }
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

  Future<void> centerCamera() async => await mapController
      .animateCamera(CameraUpdate.newLatLngZoom(await getLocation(), 16));

  void showFilters() {
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) => FilterBottomSheet(),
    );
  }
}
