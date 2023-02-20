import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/modules/chats/models/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage(
      {super.key,
      required this.message,
      required this.ownMessage,
      required this.doc});

  final Message message;
  final bool ownMessage;
  final DocumentReference doc;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: ownMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            useSafeArea: true,
            builder: (context) => Stack(
              fit: StackFit.loose,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: InteractiveViewer(
                    clipBehavior: Clip.none,
                    boundaryMargin: EdgeInsets.all(20),
                    maxScale: 5,
                    child: Expanded(
                      child: Hero(
                        tag:
                            "https://th.bing.com/th/id/R.f669c481ffe41136656ce832e1028f13?rik=EXK99P6fFCak2g&riu=http%3a%2f%2fwww.gwwoinc.com%2fuploads%2fattachments%2fcjzcz3xv81zur68uoso9c97ck-arundel-es-entrance-1.0.0.2000.1333.full.jpg&ehk=XRruf9ZyTYRGBEpFmwpOdT2R0pZ%2ftmSZ%2bwkrjtUt%2fFE%3d&risl=&pid=ImgRaw&r=0",
                        child: CachedNetworkImage(
                          height: Get.height,
                          width: Get.width,
                          imageBuilder: (context, imageProvider) => ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image(
                              image: imageProvider,
                            ),
                          ),
                          imageUrl:
                              "https://th.bing.com/th/id/R.f669c481ffe41136656ce832e1028f13?rik=EXK99P6fFCak2g&riu=http%3a%2f%2fwww.gwwoinc.com%2fuploads%2fattachments%2fcjzcz3xv81zur68uoso9c97ck-arundel-es-entrance-1.0.0.2000.1333.full.jpg&ehk=XRruf9ZyTYRGBEpFmwpOdT2R0pZ%2ftmSZ%2bwkrjtUt%2fFE%3d&risl=&pid=ImgRaw&r=0",
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  alignment: Alignment.topRight,
                  child: FloatingActionButton(
                    onPressed: () => Get.back(),
                    child: const Icon(Icons.close),
                  ),
                ),
              ],
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Hero(
            tag:
                "https://th.bing.com/th/id/R.f669c481ffe41136656ce832e1028f13?rik=EXK99P6fFCak2g&riu=http%3a%2f%2fwww.gwwoinc.com%2fuploads%2fattachments%2fcjzcz3xv81zur68uoso9c97ck-arundel-es-entrance-1.0.0.2000.1333.full.jpg&ehk=XRruf9ZyTYRGBEpFmwpOdT2R0pZ%2ftmSZ%2bwkrjtUt%2fFE%3d&risl=&pid=ImgRaw&r=0",
            child: CachedNetworkImage(
              width: 250,
              imageBuilder: (context, imageProvider) => ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: imageProvider,
                ),
              ),
              imageUrl:
                  "https://th.bing.com/th/id/R.f669c481ffe41136656ce832e1028f13?rik=EXK99P6fFCak2g&riu=http%3a%2f%2fwww.gwwoinc.com%2fuploads%2fattachments%2fcjzcz3xv81zur68uoso9c97ck-arundel-es-entrance-1.0.0.2000.1333.full.jpg&ehk=XRruf9ZyTYRGBEpFmwpOdT2R0pZ%2ftmSZ%2bwkrjtUt%2fFE%3d&risl=&pid=ImgRaw&r=0",
            ),
          ),
        ),
      ),
    );
  }
}
