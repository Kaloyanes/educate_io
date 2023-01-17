import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:educate_io/app/modules/chats/components/chat_message.dart';
import 'package:educate_io/app/modules/chats/controllers/chat_controller.dart';
import 'package:educate_io/app/models/message_model.dart';
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
        leadingWidth: 40,
        title: Row(
          children: [
            Hero(
              flightShuttleBuilder: (flightContext, animation, flightDirection,
                      fromHeroContext, toHeroContext) =>
                  fromHeroContext.widget,
              tag: (Get.arguments["docId"] as String).substring(10),
              child: CircleAvatar(
                foregroundImage:
                    CachedNetworkImageProvider(Get.arguments["photoUrl"] ?? ""),
                child: Text(Get.arguments["initials"]),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Hero(
              flightShuttleBuilder: (flightContext, animation, flightDirection,
                      fromHeroContext, toHeroContext) =>
                  fromHeroContext.widget,
              tag: Get.arguments["docId"],
              child: Text(
                Get.arguments["name"],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: controller.collection.orderBy("time").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                controller.messages.removeWhere((element) =>
                    element.msgId == snapshot.data!.docChanges.first.doc.id);

                var doc = snapshot.data!.docs.last;
                var data = doc.data();

                if (data.isEmpty || doc.id == "example") {
                  return Container();
                }

                data.addAll({"msgId": doc.id});

                var msg = Message.fromMap(data);

                controller.messages.addIf(
                  !controller.messages.contains(msg),
                  msg,
                );

                return Obx(
                  () => CupertinoScrollbar(
                    thicknessWhileDragging: 5,
                    controller: controller.listController,
                    child: ListView.builder(
                      reverse: true,
                      controller: controller.listController,
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) {
                        var item =
                            controller.messages.reversed.elementAt(index);
                        bool isMessageMine = item.sender ==
                            FirebaseAuth.instance.currentUser!.uid;

                        return ChatMessage(
                          doc: controller.collection.doc(item.msgId),
                          message: item,
                          ownMessage: isMessageMine,
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
