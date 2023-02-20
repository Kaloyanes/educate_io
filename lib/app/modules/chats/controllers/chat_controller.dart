import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/chats/chat_messages/views/location_picker.dart';
import 'package:educate_io/app/modules/chats/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ChatController extends GetxController {
  var collection = FirebaseFirestore.instance
      .collection("chats")
      .doc(Get.arguments["docId"])
      .collection("messages");

  final GlobalKey appBarKey = GlobalKey();

  final editMode = false.obs;

  Teacher teacher = Get.arguments["teacher"];
  String docId = Get.arguments["docId"];
  String initials = Get.arguments["initials"];

  var messagesCount = 0;

  @override
  void onInit() {
    _feedMessages();
    collection.orderBy("time").snapshots().listen((event) => feed(event));
    super.onInit();
  }

  void feed(QuerySnapshot<Map<String, dynamic>> event) {
    var lastDoc = event.docChanges.last;
    var data = lastDoc.doc.data() ?? {};

    data.addAll({"msgId": lastDoc.doc.id});
    var message = Message.fromMap(data);

    switch (lastDoc.type) {
      case DocumentChangeType.added:
        messages.addIf(
          !messages.contains(message) && message.msgId != "example",
          message,
        );

        break;

      case DocumentChangeType.removed:
        messages.remove(message);
        break;

      case DocumentChangeType.modified:
        var messageIndex =
            messages.indexWhere((element) => element.msgId == lastDoc.doc.id);
        messages[messageIndex].copyWith(
            value: lastDoc.doc.get("value"), time: lastDoc.doc.get("time"));
        break;
    }
  }

  Future<void> _feedMessages() async {
    var messageCollection = await collection.orderBy("time").get();

    var msgs = <Message>[];
    var docs = messageCollection.docs;

    docs.removeWhere((element) => element.id == "example");
    docs.removeLast();

    for (var doc in docs) {
      var data = doc.data();
      data.addAll({"msgId": doc.id});

      var msg = Message.fromMap(data);

      messages.addIf(!msgs.contains(msg), msg);
    }

    // messages.addAll(msgs);
  }

  var messages = <Message>[].obs;

  final listController = ScrollController();
  final messageController = TextEditingController();

  Future<void> sendMessage() async {
    if (messagesCount++ >= 60) {
      showDialog(
          barrierDismissible: false,
          context: Get.context!,
          builder: (context) {
            FocusScope.of(context).unfocus();

            return AlertDialog(
              icon: const Icon(Icons.warning),
              title: const Text(
                "Намали малко скороста ве момче",
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Ок"),
                ),
              ],
            );
          });
      return;
    }

    FirebaseFirestore.instance
        .collection("chats")
        .doc(Get.arguments["docId"])
        .update({
      "lastMessage": Timestamp.now(),
    });

    var value = messageController.text;
    if (value.trim() == "") {
      return;
    }
    messageController.clear();

    collection.add({
      "sender": FirebaseAuth.instance.currentUser!.uid,
      "value": value.trim(),
      "time": Timestamp.fromDate(DateTime.now()),
    });

    listController.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOutExpo,
    );
  }

  Future<void> call() async => await launchUrlString("tel:${teacher.phone}");

  Future<void> pickLocation() async {
    var latlng = await Get.to<LatLng>(() => const LocationPickerView());

    if (latlng == null) return;
    var data = {
      "sender": FirebaseAuth.instance.currentUser!.uid,
      "value": GeoPoint(latlng.latitude, latlng.longitude),
      "time": Timestamp.now(),
      "type": "location",
    };

    var doc = await collection.add(data);

    data.addAll({"msgId": doc.id});

    var msg = Message.fromMap(data);
    messages.addIf(
      !messages.contains(msg) && msg.msgId != "example",
      msg,
    );

    listController.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOutExpo,
    );
  }

  void takePicture() {}

  void pickTimeAndDate() {}
}
