import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/chats/models/chat_model.dart';
import 'package:educate_io/app/modules/chats/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  @override
  void onClose() {
    messages.clear();
    super.onClose();
  }

  var collection = FirebaseFirestore.instance
      .collection("chats")
      .doc(Get.arguments["docId"])
      .collection("messages");

  Teacher teacher = Get.arguments["teacher"];

  @override
  void onInit() {
    _feedMessages();
    super.onInit();
  }

  Future<void> _feedMessages() async {
    var messageCollection =
        await collection.orderBy("time", descending: true).get();

    var msgs = <Message>[];

    for (var doc
        in messageCollection.docs.where((element) => element.id != "example")) {
      var data = doc.data();
      data.addAll({"msgId": doc.id});

      msgs.add(Message.fromMap(data));
    }

    messages.addAll(msgs);
  }

  var messages = <Message>[].obs;

  final listController = ScrollController(keepScrollOffset: true);
  final messageController = TextEditingController();

  Future<void> sendMessage() async {
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
  }

  void newMessage(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    var data = doc.data();

    if (doc.data().isEmpty) {
      return;
    }

    print("new message");

    data.addAll({"msgId": doc.id});

    var msg = Message.fromMap(data);

    if (msg != messages.last) {
      printInfo(info: "new message 100%");
      messages.add(msg);
    }
  }
}
