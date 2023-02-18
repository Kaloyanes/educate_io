import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/chats/views/chat_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsController extends GetxController {
  final Teacher teacher = Get.arguments["teacher"];

  Future<void> favoriteTeacher(Teacher teacher) async {
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    var teachers = List.castFrom<dynamic, String>(doc.get("likedTeachers"));

    if (teachers.contains(teacher.uid)) {
      teachers.remove(teacher.uid);

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text("Премахнат ментор от любими ментори"),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      teachers.add(teacher.uid!);
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text("Успешно добавен ментор към любими ментори"),
          duration: Duration(seconds: 2),
        ),
      );
    }

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"likedTeachers": teachers});
  }

  Future<void> createChat() async {
    var store = FirebaseFirestore.instance;
    var uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (uid.isEmpty) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning),
          title: const Text(
              "Трябва да сте в акаунт за да можете да пишете на лично"),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text("Ок"))
          ],
        ),
      );

      return;
    }

    if (teacher.uid! == uid) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning),
          title: const Text("Не можете да пишете на себе си"),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text("Ок"))
          ],
        ),
      );

      return;
    }

    var doc = await store.collection("chats").doc("$uid.${teacher.uid}").get();

    if (doc.exists) {
      Get.to(() => const ChatView(), arguments: {
        "docId": doc.id,
        "photoUrl": teacher.photoUrl,
        "name": teacher.name,
        "initials": "KS",
      });
    }

    var chatDocId = "$uid.${teacher.uid!}";

    var chatDoc = store.collection("chats").doc(chatDocId);

    chatDoc.set({"lastMessage": Timestamp.now(), "creator": uid});

    chatDoc.collection("messages").doc("example").set({
      "time": Timestamp.now(),
      "sender": "",
      "value": "",
    });

    Get.to(() => const ChatView(), arguments: {
      "docId": chatDocId,
      "initials": "KS",
      "photoUrl": teacher.photoUrl,
      "name": teacher.name,
    });
  }

  Future<void> callTeacher() async {
    Uri url = Uri.parse("tel:${teacher.phone}");

    await launchUrl(url);
  }

  Future report() async {
    final reportDetails = TextEditingController();

    var report = await showDialog<bool>(
          context: Get.context!,
          builder: (context) => AlertDialog(
            title: const Text("Докладвай"),
            content: TextField(
              controller: reportDetails,
              decoration: const InputDecoration(
                label: Text("Описание на доклада"),
              ),
            ),
            actions: [
              TextButton(
                child: const Text("Отказ"),
                onPressed: () => Get.back(result: false),
              ),
              TextButton(
                child: const Text("Докладвай"),
                onPressed: () => Get.back(result: true),
              )
            ],
          ),
        ) ??
        false;

    if (!report) return;

    await FirebaseFirestore.instance.collection("reports").doc().set({
      "reportedUid": teacher.uid,
      "reason": reportDetails.text.trim(),
      "sent": DateTime.now(),
      "reportedBy": (FirebaseAuth.instance.currentUser?.uid ?? "Anon")
    });

    ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
        content: Text("Благодарим ви, че правите ЕducateIO по-добро място")));
  }

  Future<void> launchEmail() async {
    var uri = Uri.parse("mailto:${teacher.email}");

    await launchUrl(uri);
  }
}
