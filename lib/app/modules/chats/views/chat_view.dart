import 'package:cached_network_image/cached_network_image.dart';
import 'package:educate_io/app/modules/chats/components/messages/chat_message.dart';
import 'package:educate_io/app/modules/chats/components/messages/date_time_message.dart';
import 'package:educate_io/app/modules/chats/components/messages/image_message.dart';
import 'package:educate_io/app/modules/chats/components/messages/location_message.dart';
import 'package:educate_io/app/modules/chats/controllers/chat_controller.dart';
import 'package:educate_io/app/modules/details/views/details_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
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
        key: controller.appBarKey,
        leadingWidth: 40,
        elevation: 1,
        title: GestureDetector(
          onTap: () => Get.to(
            () => const DetailsView(),
            arguments: {
              "teacher": Get.arguments["teacher"],
            },
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Hero(
                        transitionOnUserGestures: true,
                        tag: controller.teacher.photoUrl ?? controller.teacher,
                        child: CircleAvatar(
                          foregroundImage: CachedNetworkImageProvider(
                              controller.teacher.photoUrl ?? ""),
                          child: Text(controller.initials),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Hero(
                        transitionOnUserGestures: true,
                        flightShuttleBuilder: (flightContext,
                                animation,
                                flightDirection,
                                fromHeroContext,
                                toHeroContext) =>
                            AnimatedBuilder(
                          animation: animation,
                          child: toHeroContext.widget,
                          builder: (_, child) {
                            return DefaultTextStyle.merge(
                              child: child ?? const Text("maika ti"),
                              style: TextStyle.lerp(
                                DefaultTextStyle.of(toHeroContext).style,
                                DefaultTextStyle.of(fromHeroContext).style,
                                flightDirection == HeroFlightDirection.pop
                                    ? 1 - animation.value
                                    : animation.value,
                              ),
                            );
                          },
                        ),
                        tag: controller.docId,
                        child: Text(
                          controller.teacher.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (controller.teacher.phone != null)
                      IconButton(
                        onPressed: () => controller.call(),
                        icon: const Icon(Icons.call),
                      ),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: const Text(
                            "Изтрий чата",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          onTap: () => controller.deleteChat(),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => CupertinoScrollbar(
                controller: controller.listController,
                child: ListView.builder(
                  cacheExtent: 50000,
                  semanticChildCount: controller.messages.length,
                  dragStartBehavior: DragStartBehavior.down,
                  itemCount: controller.messages.length,
                  reverse: true,
                  controller: controller.listController,
                  itemBuilder: (context, i) {
                    var item = controller.messages.reversed.elementAt(i);
                    bool isOwnMessage =
                        item.sender == FirebaseAuth.instance.currentUser!.uid;

                    switch (item.type) {
                      case "location":
                        return LocationMessage(
                          ownMessage: isOwnMessage,
                          message: item,
                          doc: controller.collection.doc(item.msgId),
                        );

                      case "image":
                        return ImageMessage(
                          ownMessage: isOwnMessage,
                          message: item,
                          doc: controller.collection.doc(item.msgId),
                        );

                      case "time":
                        return DateTimeMessage(
                          ownMessage: isOwnMessage,
                          message: item,
                          doc: controller.collection.doc(item.msgId),
                          personName: controller.teacher.name,
                        );

                      default:
                        return ChatMessage(
                          ownMessage: isOwnMessage,
                          message: item,
                          doc: controller.collection.doc(item.msgId),
                        );
                    }
                  },
                ),
              ),
            ),
          ),
          BottomAppBar(
            elevation: 1,
            height: MediaQuery.of(context).padding.bottom + 90,
            child: Container(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PopupMenuButton(
                    onSelected: (value) {
                      switch (value) {
                        case 1:
                          controller.pickLocation();
                          break;

                        case 2:
                          controller.takePicture();
                          break;

                        case 3:
                          controller.pickTimeAndDate();
                          break;
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.location_on),
                            SizedBox(width: 10),
                            Text("Локация"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.image),
                            SizedBox(width: 10),
                            Text("Снимка"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Row(
                          children: [
                            Icon(Icons.access_time_filled),
                            SizedBox(width: 10),
                            Text("Време"),
                          ],
                        ),
                      ),
                    ],
                    enableFeedback: true,
                    icon: const Icon(
                      Icons.add,
                    ),
                    iconSize: 30,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextField(
                      autofocus: false,
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
                  const SizedBox(
                    width: 20,
                  ),
                  Hero(
                    transitionOnUserGestures: true,
                    tag: "sendButton",
                    child: IconButton(
                      onPressed: () => controller.sendMessage(),
                      icon: const Icon(
                        Icons.send,
                        size: 30,
                      ),
                    ),
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
