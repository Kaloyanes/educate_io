import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var collection = FirebaseFirestore.instance
      .collection("chats")
      .doc(Get.arguments["docId"])
      .collection("messages");

  final collectionStream = const Stream.empty().obs;

  Object photoUrl = Get.arguments["photoUrl"];
  String docId = Get.arguments["docId"];
  String name = Get.arguments["name"];
  String initials = Get.arguments["initials"];

  var messagesCount = 0;

  @override
  void onInit() {
    _feedMessages();
    collectionStream.value = collection.orderBy("time").snapshots();
    Timer.periodic(NumDurationExtensions(60).seconds, (timer) {});
    super.onInit();
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

      msgs.addIf(!msgs.contains(msg), msg);
    }

    messages.addAll(msgs);
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

    // Timer(
    //   100.ms,
    //   () => listController.animateTo(
    //     listController.position.maxScrollExtent,
    //     duration: const Duration(seconds: 1),
    //     curve: Curves.easeOutExpo,
    //   ),
    // );

    listController.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOutExpo,
    );
  }
}
