import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/chats/components/chat_message.dart';
import 'package:educate_io/app/modules/chats/controllers/chat_controller.dart';
import 'package:educate_io/app/modules/chats/models/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(
      () => ChatController(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Hero(
              tag: controller.teacher.photoUrl,
              child: CircleAvatar(
                foregroundImage:
                    CachedNetworkImageProvider(controller.teacher.photoUrl),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Hero(
              flightShuttleBuilder: (flightContext, animation, flightDirection,
                      fromHeroContext, toHeroContext) =>
                  fromHeroContext.widget,
              tag: Get.arguments["docId"],
              child: Text(
                controller.teacher.name,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: controller.collection.orderBy("time").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }
                var doc = snapshot.data!.docs.last;

                var data = doc.data();

                if (doc.data().isEmpty || doc.id == "example") {
                  return Container();
                }

                print("new message");

                data.addAll({"msgId": doc.id});

                var msg = Message.fromMap(data);

                if (controller.messages.isEmpty ||
                    msg != controller.messages.last) {
                  printInfo(info: "new message 100%");
                  controller.messages.add(msg);
                }

                return Obx(
                  () => CupertinoScrollbar(
                    child: ListView.builder(
                      reverse: true,
                      controller: controller.listController,
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        var item =
                            controller.messages.reversed.elementAt(index);

                        return ChatMessage(
                          message: item,
                          ownMessage: item.sender ==
                              FirebaseAuth.instance.currentUser!.uid,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          BottomAppBar(
            clipBehavior: Clip.hardEdge,
            elevation: 1,
            height: 120,
            child: Container(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => controller.sendMessage(),
                    icon: const Icon(Icons.camera_alt),
                  ),
                  Flexible(
                    flex: 1,
                    fit: FlexFit.loose,
                    child: TextField(
                      controller: controller.messageController,
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                      textInputAction: TextInputAction.send,
                      textAlignVertical: TextAlignVertical.top,
                      onSubmitted: (value) => controller.sendMessage(),
                      expands: true,
                      maxLines: null,
                      minLines: null,
                    ),
                  ),
                  IconButton(
                    onPressed: () => controller.sendMessage(),
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
