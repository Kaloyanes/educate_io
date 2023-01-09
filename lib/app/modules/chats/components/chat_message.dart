import 'package:educate_io/app/modules/chats/models/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key, required this.message, required this.ownMessage});

  final Message message;
  final bool ownMessage;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: ownMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: Get.width / 2,
        // height: Get.height / 10,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: ownMessage
                ? const Radius.circular(40)
                : const Radius.circular(10),
            bottomRight: const Radius.circular(40),
            topLeft: const Radius.circular(40),
            topRight: ownMessage
                ? const Radius.circular(10)
                : const Radius.circular(40),
          ),
          color: ownMessage
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.secondaryContainer,
        ),
        child: Text(message.value),
      ),
    );
  }
}
