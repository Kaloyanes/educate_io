import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/chats/bindings/chats_binding.dart';
import 'package:educate_io/app/modules/chats/controllers/chat_controller.dart';
import 'package:educate_io/app/modules/chats/views/chat_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
              return const CircularProgressIndicator();
            }

            var user = snapshot.data!.docs.where(
              (element) =>
                  element.id.contains(FirebaseAuth.instance.currentUser!.uid),
            );

            if (user.isEmpty) {
              return const Center(
                child: Text("Няма чатове"),
              );
            }

            return ListView.builder(
              itemCount: user.length,
              itemBuilder: (context, index) {
                var doc = user.elementAt(index);

                var ids = doc.id.split(".");

                var otherPersonids =
                    ids[0] == FirebaseAuth.instance.currentUser!.uid
                        ? ids[1]
                        : ids[0];

                return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(otherPersonids)
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var teacherData = snapshot.data!.data()!;
                    var teacher = Teacher.fromMap(teacherData);

                    return ListTile(
                      leading: Hero(
                        tag: teacher.photoUrl,
                        child: CircleAvatar(
                          foregroundImage:
                              CachedNetworkImageProvider(teacher.photoUrl),
                        ),
                      ),
                      title: Hero(
                        flightShuttleBuilder: (flightContext,
                                animation,
                                flightDirection,
                                fromHeroContext,
                                toHeroContext) =>
                            toHeroContext.widget,
                        tag: doc.id,
                        child: Text(
                          teacher.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      onTap: () async {
                        Get.to(
                          () => const ChatView(),
                          arguments: {"docId": doc.id, "teacher": teacher},
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ));
  }
}
