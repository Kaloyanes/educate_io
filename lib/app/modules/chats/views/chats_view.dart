import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chats_controller.dart';

class ChatsView extends GetView<ChatsController> {
  const ChatsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Чатове'),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("chats").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.data == null) {
              return CircularProgressIndicator();
            }

            var user = snapshot.data!.docs.where(
              (element) =>
                  element.id.contains(FirebaseAuth.instance.currentUser!.uid),
            );

            if (user.isEmpty) {
              return Center(
                child: Text("Няма чатове"),
              );
            }

            return ListView.builder(
              itemCount: 15,
              itemBuilder: (context, index) {
                // var doc = user.elementAt(index);

                // var otherPersonId = doc.id.split(".");
                // (otherPersonId);

                return ListTile(
                  leading: CircleAvatar(child: Text("KS")),
                  title: Text("Kaloyan Stoyanov"),
                  onTap: () {},
                );
              },
            );
          },
        ));
  }
}
