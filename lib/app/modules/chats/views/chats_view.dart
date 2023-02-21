import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/chats/views/chat_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
          stream: FirebaseFirestore.instance
              .collection("chats")
              .orderBy("lastMessage", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data == null ||
                snapshot.connectionState == ConnectionState.waiting) {
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

            return ListView(
              children: [
                for (var i = 0; i < user.length; i++)
                  Builder(
                    builder: (context) {
                      var doc = user.elementAt(i);

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
                          if (snapshot.data == null ||
                              snapshot.connectionState ==
                                  ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          var personData = snapshot.data!.data() ?? {};

                          if (personData.isEmpty) {
                            return Container();
                          }

                          personData.addAll({"uid": otherPersonids});
                          String initials = "";

                          if (personData["photoUrl"] == null) {
                            personData["name"].split(' ').forEach((element) {
                              initials += element[0];
                            });
                          }

                          return ListTile(
                            leading: Hero(
                              tag: personData["photoUrl"] ?? personData,
                              child: CircleAvatar(
                                foregroundImage: CachedNetworkImageProvider(
                                    personData["photoUrl"] ?? ""),
                                child: Text(initials),
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
                                personData["name"] ?? "",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            onTap: () async {
                              Get.to(
                                () => const ChatView(),
                                arguments: {
                                  "teacher": Teacher.fromMap(personData),
                                  "docId": doc.id,
                                  "initials": initials,
                                },
                              );
                            },
                          );
                        },
                      );
                    },
                  )
              ]
                  .animate(
                    interval: 100.ms,
                  )
                  .slideX(
                    curve: Curves.easeOutQuint,
                    begin: 2,
                    duration: 1000.ms,
                  )
                  .blurX(
                    begin: 5,
                    end: 0,
                    // curve: Curves.easeInOutExpo,
                    curve: Curves.easeOutQuart,
                    duration: 600.ms,
                    delay: 200.ms,
                  ),
            );
          },
        ));
  }
}
