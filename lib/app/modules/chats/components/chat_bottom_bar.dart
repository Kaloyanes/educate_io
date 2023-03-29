import 'package:educate_io/app/modules/chats/controllers/chat_controller.dart';
import 'package:flutter/material.dart';

class ChatBottomBar extends StatelessWidget {
  const ChatBottomBar({
    super.key,
    required this.controller,
  });

  final ChatController controller;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 1,
      height: 110,
      // height: MediaQuery.of(context).padding.bottom + 90,
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

                case 4:
                  controller.pickFile();
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
              PopupMenuItem(
                value: 4,
                child: Row(
                  children: [
                    Icon(Icons.file_upload),
                    SizedBox(width: 10),
                    Text("Файл"),
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
    );
  }
}
