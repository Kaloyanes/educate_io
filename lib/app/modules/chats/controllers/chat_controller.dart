import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/message_model.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var collection = FirebaseFirestore.instance
      .collection("chats")
      .doc(Get.arguments["docId"])
      .collection("messages");

  @override
  void onInit() {
    _feedMessages();
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
    messages.removeAt(0);
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
      "value": value,
      "time": Timestamp.fromDate(DateTime.now()),
    });
    listController.animateTo(
      0,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOutExpo,
    );
  }
}
