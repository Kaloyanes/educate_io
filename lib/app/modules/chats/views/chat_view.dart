import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/message_model.dart';
import 'package:educate_io/app/modules/chats/components/chat_message.dart';
import 'package:educate_io/app/modules/chats/controllers/chat_controller.dart';
import 'package:educate_io/app/modules/details/views/details_view.dart';
import 'package:educate_io/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
        title: GestureDetector(
          onTap: () => Get.to(
            () => const DetailsView(),
            arguments: {
              "teacher": Get.arguments["teacher"],
            },
          ),
          child: Row(
            children: [
              Hero(
                flightShuttleBuilder: (flightContext, animation,
                        flightDirection, fromHeroContext, toHeroContext) =>
                    fromHeroContext.widget,
                tag: controller.photoUrl,
                child: CircleAvatar(
                  foregroundImage: CachedNetworkImageProvider(
                      controller.photoUrl.toString()),
                  child: Text(controller.initials),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Hero(
                flightShuttleBuilder: (flightContext, animation,
                        flightDirection, fromHeroContext, toHeroContext) =>
                    fromHeroContext.widget,
                tag: controller.docId,
                child: Text(
                  controller.name,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return StreamBuilder(
                stream: controller.collectionStream.value,
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Container();
                  }

                  var lastDoc = snapshot.data!.docChanges.last;
                  var data = lastDoc.doc.data() ?? {};

                  data.addAll({"msgId": lastDoc.doc.id});
                  var message = Message.fromMap(data);

                  switch (lastDoc.type) {
                    case DocumentChangeType.added:
                      controller.messages.addIf(
                        !controller.messages.contains(message) &&
                            message.msgId != "example",
                        message,
                      );

                      break;

                    case DocumentChangeType.removed:
                      controller.messages.remove(message);
                      break;
                  }

                  return Obx(
                    () => CupertinoScrollbar(
                      child: ImplicitlyAnimatedList(
                        items: controller.messages.reversed.toList(),
                        reverse: true,
                        controller: controller.listController,
                        areItemsTheSame: (oldItem, newItem) =>
                            newItem.msgId == oldItem.msgId,
                        insertDuration: 350.ms,
                        removeDuration: 400.ms,
                        itemBuilder: (context, animation, item, i) =>
                            ChatMessage(
                          doc: controller.collection.doc(item.msgId),
                          message: item,
                          ownMessage: item.sender ==
                              FirebaseAuth.instance.currentUser!.uid,
                        )
                                .animate()
                                .slideX(
                                  begin: item.sender ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? 2
                                      : -2,
                                  end: 0,
                                  curve: Curves.easeOutQuad,
                                  duration: 300.ms,
                                )
                                .scaleXY(
                                  delay: 150.ms,
                                  begin: 1.5,
                                  end: 1,
                                  curve: Curves.easeOutExpo,
                                  duration: 400.ms,
                                )
                                .blurXY(
                                  begin: 4,
                                  end: 0,
                                  delay: 300.ms,
                                ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          BottomAppBar(
            clipBehavior: Clip.hardEdge,
            elevation: 1,
            height: MediaQuery.of(context).padding.bottom + 90,
            child: Container(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                      // onTap: () => Timer(
                      //   350.ms,
                      //   () => controller.listController.animateTo(
                      //     controller.listController.position.maxScrollExtent,
                      //     duration: const Duration(seconds: 1),
                      //     curve: Curves.easeOutExpo,
                      //   ),
                      // ),
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
