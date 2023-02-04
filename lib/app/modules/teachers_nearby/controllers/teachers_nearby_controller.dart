import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/details/views/details_view.dart';
import 'package:educate_io/app/modules/teachers_nearby/components/filter_bottom_sheet.dart';
import 'package:fast_image_resizer/fast_image_resizer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart'
    as places;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

import 'package:google_maps_webservice/geocoding.dart';

class TeachersNearbyController extends GetxController {
  late GoogleMapController mapController;

  final searchController = TextEditingController();

  final RxList<Marker> markers = <Marker>[].obs;

  final showControls = false.obs;

  @override
  void onClose() {
    mapController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    getLocations();
    super.onInit();
  }

  void configureMap(GoogleMapController controller) {
    showControls.value = true;
    mapController = controller;
  }

  Future<Marker> template(LatLng latlng, String docId) async {
    var imageRef =
        await FirebaseStorage.instance.ref("profile_pictures/").listAll();

    var imageBytes = await imageRef.items
        .where((element) => element.name.contains(docId))
        .first
        .getData();

    imageBytes ??= Uint8List(0);

    var doc =
        await FirebaseFirestore.instance.collection("users").doc(docId).get();

    var teacher = Teacher.fromMap(doc.data() ?? {});

    return Marker(
      markerId: MarkerId(latlng.toString()),
      position: latlng,
      flat: false,
      icon: await convertImageFileToCustomBitmapDescriptor(
        imageBytes,
        title: teacher.name,
        size: 150,
        titleBackgroundColor:
            Theme.of(Get.context!).colorScheme.primaryContainer,
        addBorder: true,
        borderColor: Theme.of(Get.context!).colorScheme.primaryContainer,
        borderSize: 20,
      ),
      onTap: () => showDetails(teacher),
      consumeTapEvents: false,
    );
  }

  Future<BitmapDescriptor> convertImageFileToCustomBitmapDescriptor(
      Uint8List imageUint8List,
      {int size = 150,
      bool addBorder = false,
      Color borderColor = Colors.white,
      double borderSize = 10,
      required String title,
      Color titleColor = Colors.white,
      Color titleBackgroundColor = Colors.black}) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    final double radius = size / 2;

    //make canvas clip path to prevent image drawing over the circle
    final Path clipPath = Path();
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        Radius.circular(100)));
    clipPath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, size * 8 / 10, size.toDouble(), size * 3 / 10),
        Radius.circular(100)));
    canvas.clipPath(clipPath);

    //paintImage
    final ui.Codec codec = await ui.instantiateImageCodec(imageUint8List);
    final ui.FrameInfo imageFI = await codec.getNextFrame();
    paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, size.toDouble(), size.toDouble()),
        image: imageFI.image);

    if (addBorder) {
      //draw Border
      paint..color = borderColor;
      paint..style = PaintingStyle.stroke;
      paint..strokeWidth = borderSize;
      canvas.drawCircle(Offset(radius, radius), radius, paint);
    }

    if (title != null) {
      if (title.split(" ").length > 1) {
        title = title.split(" ")[0];
      }
      // //draw Title background
      paint..color = titleBackgroundColor;
      paint..style = PaintingStyle.fill;
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(0, size * 8 / 10, size.toDouble(), size * 3 / 10),
              Radius.circular(100)),
          paint);

      //draw Title
      textPainter.text = TextSpan(
          text: title,
          style: TextStyle(
            fontSize: radius / 2.5,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ));
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(radius - textPainter.width / 2,
              size * 9.5 / 10 - textPainter.height / 2));
    }

    //convert canvas as PNG bytes
    final _image = await pictureRecorder
        .endRecording()
        .toImage(size, (size * 1.1).toInt());
    final data = await _image.toByteData(format: ui.ImageByteFormat.png);

    //convert PNG bytes as BitmapDescriptor
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  Future<void> showDetails(Teacher teacher) async {
    Get.to(
      DetailsView(),
      arguments: {"teacher": teacher},
      fullscreenDialog: true,
    );
  }

  Future<void> getLocations() async {
    var collection =
        await FirebaseFirestore.instance.collection("locations").get();

    for (var doc in collection.docs.where(
      (element) =>
          element.id != FirebaseAuth.instance.currentUser?.uid &&
          element.get("show") == true,
    )) {
      var value = doc.get("place") as GeoPoint;

      inspect(value);

      markers
          .add(await template(LatLng(value.latitude, value.longitude), doc.id));
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

  Future<void> search() async {
    print(searchController.text.trim());

    var geocoding =
        GoogleMapsGeocoding(apiKey: "AIzaSyBXQFGCIiVUpDMidzh8A_FhkD-9vVKqmfU");

    var request = await geocoding.searchByAddress(searchController.text.trim(),
        language: "bg");

    var place = request.results.first;
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(place.geometry.location.lat, place.geometry.location.lng),
        15,
      ),
    );
  }
}
