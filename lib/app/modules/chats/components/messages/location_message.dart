import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/modules/chats/components/message_settings.dart';
import 'package:educate_io/app/modules/chats/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LocationMessage extends StatefulWidget {
  const LocationMessage(
      {super.key,
      required this.message,
      required this.ownMessage,
      required this.doc});

  final Message message;
  final bool ownMessage;
  final DocumentReference doc;

  @override
  State<LocationMessage> createState() => _LocationMessageState();
}

class _LocationMessageState extends State<LocationMessage> {
  Completer<LatLng> latLng = Completer();

  @override
  void initState() {
    super.initState();

    latLng.complete(
      LatLng((widget.message.value as GeoPoint).latitude,
          (widget.message.value as GeoPoint).longitude),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => showModalBottomSheet(
        context: context,
        builder: (context) => MessageSettings(doc: widget.doc),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: widget.ownMessage
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: latLng.future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  margin: const EdgeInsets.all(40),
                  child: const CircularProgressIndicator(),
                );
              }

              var locationData =
                  snapshot.data ?? const LatLng(42.510578, 27.461014);

              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                width: 250,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GoogleMap(
                    onTap: (argument) {
                      launchUrlString(
                        "geo:${locationData.latitude},${locationData.longitude}?q=${locationData.latitude},${locationData.longitude}(Meeting place)",
                      );
                    },
                    initialCameraPosition: CameraPosition(
                      target: locationData,
                      zoom: 15,
                    ),
                    onMapCreated: (controller) async =>
                        controller.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          zoom: 16,
                          target: locationData,
                        ),
                      ),
                    ),
                    liteModeEnabled: true,
                    zoomControlsEnabled: false,
                    mapType: MapType.hybrid,
                    mapToolbarEnabled: false,
                    markers: {
                      Marker(
                          markerId: const MarkerId("meeting"),
                          position: locationData),
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
