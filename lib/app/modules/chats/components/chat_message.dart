import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/message_model.dart';
import 'package:educate_io/app/modules/chats/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(
      {super.key,
      required this.message,
      required this.ownMessage,
      required this.doc});

  final Message message;
  final bool ownMessage;
  final DocumentReference doc;

  DateFormat formatter = DateFormat("H:m \nd/MM");

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: ownMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () async {
          if (!ownMessage) return;
          HapticFeedback.lightImpact();

          var result = await showModalBottomSheet<String>(
            context: context,
            builder: (context) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 5,
                      width: Get.size.width / 3,
                      decoration: BoxDecoration(
                        color: Theme.of(Get.context!).dividerColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text("Изтрийте съобщението"),
                      onTap: () {
                        Get.back();
                        Get.find<ChatController>()
                            .messages
                            .removeWhere((element) => element.msgId == doc.id);
                        doc.delete();
                      },
                      tileColor:
                          Theme.of(context).colorScheme.tertiaryContainer,
                    ),
                    SizedBox(
                      height: Get.mediaQuery.padding.bottom,
                    )
                  ],
                ),
              );
            },
          );
        },
        onTap: () => HapticFeedback.selectionClick(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                ownMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
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
                child: Text(
                  message.value,
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment:
                    ownMessage ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  formatter.format(message.time),
                  textAlign: ownMessage ? TextAlign.right : TextAlign.left,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
