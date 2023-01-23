import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var collection = FirebaseFirestore.instance
      .collection("chats")
      .doc(Get.arguments["docId"])
      .collection("messages");

  late String photoUrl;
  late String docId;
  late String name;
  late String initials;

  @override
  void onInit() {
    _feedMessages();
    photoUrl = Get.arguments["photoUrl"];
    docId = Get.arguments["docId"];
    name = Get.arguments["name"];
    initials = Get.arguments["initials"];
    super.onInit();
  }

  Future<void> _feedMessages() async {
    var messageCollection = await collection.orderBy("time").get();

    var msgs = <Message>[];

    for (var doc
        in messageCollection.docs.where((element) => element.id != "example")) {
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
    FirebaseFirestore.instance
        .collection("chats")
        .doc(Get.arguments["docId"])
        .update({
      "lastMessage": Timestamp.now(),
    });

    var value = messageController.text;
    if (value.isEmpty) {
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
}
