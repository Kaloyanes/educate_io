import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/chats/views/chat_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsController extends GetxController {
  final Teacher teacher = Get.arguments["teacher"];

  Future<void> favoriteTeacher(Teacher teacher) async {
    var doc = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);

    var teachers =
        await doc.get().then((value) => value.get("likedTeachers") as List);

    if (teachers.contains(teacher.uid)) {
      teachers.remove(teacher.uid);

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text("Премахнат учител от любими учители"),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      teachers.add(teacher.uid);
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(
          content: Text("Успешно добавен учител към любими учители"),
          duration: Duration(seconds: 2),
        ),
      );
    }

    doc.update({"likedTeachers": teachers});
  }

  void createChat() {
    var store = FirebaseFirestore.instance;
    var uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    if (uid.isEmpty) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          icon: Icon(Icons.warning),
          title: Text("Трябва да сте в акаунт за да можете да пишете на лично"),
          actions: [TextButton(onPressed: () => Get.back(), child: Text("Ок"))],
        ),
      );

      return;
    }

    if (teacher.uid! == uid) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          icon: Icon(Icons.warning),
          title: Text("Не можете да пишете на себе си"),
          actions: [TextButton(onPressed: () => Get.back(), child: Text("Ок"))],
        ),
      );

      return;
    }

    var chatDocId = uid + "." + teacher.uid!;

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
}
