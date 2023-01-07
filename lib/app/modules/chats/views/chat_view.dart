import 'package:cached_network_image/cached_network_image.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/chats/controllers/chat_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ChatView extends GetView<ChatController> {
  const ChatView(this.teacher, {Key? key}) : super(key: key);

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ChatController());

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Hero(
              tag: teacher.photoUrl,
              child: CircleAvatar(
                foregroundImage: CachedNetworkImageProvider(teacher.photoUrl),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Hero(
              flightShuttleBuilder: (flightContext, animation, flightDirection,
                      fromHeroContext, toHeroContext) =>
                  fromHeroContext.widget,
              tag: teacher.uid ?? "teacher-name",
              child: Text(
                teacher.name,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                controller: controller.listController,
                itemCount: 100,
                itemBuilder: (context, index) {
                  return Text("$index");
                }),
          ),
          BottomAppBar(
            clipBehavior: Clip.hardEdge,
            elevation: 1,
            height: 90 + MediaQuery.of(context).padding.bottom,
            child: Container(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: TextField(
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(5)),
                      textInputAction: TextInputAction.send,
                      textAlignVertical: TextAlignVertical.center,
                      onTap: () {},
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
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
