import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/message_model.dart';
import 'package:educate_io/app/modules/chats/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatefulWidget {
  ChatMessage(
      {super.key,
      required this.message,
      required this.ownMessage,
      required this.doc});

  final Message message;
  final bool ownMessage;
  final DocumentReference doc;

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage>
    with TickerProviderStateMixin {
  DateFormat formatter = DateFormat("H:mm \nd/MM");

  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          widget.ownMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () async {
          if (!widget.ownMessage) return;
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
                        Get.find<ChatController>().messages.removeWhere(
                            (element) => element.msgId == widget.doc.id);
                        widget.doc.delete();
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
            crossAxisAlignment: widget.ownMessage
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: widget.ownMessage
                        ? const Radius.circular(40)
                        : const Radius.circular(10),
                    bottomRight: const Radius.circular(40),
                    topLeft: const Radius.circular(40),
                    topRight: widget.ownMessage
                        ? const Radius.circular(10)
                        : const Radius.circular(40),
                  ),
                  color: widget.ownMessage
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: Text(
                  widget.message.value,
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment: widget.ownMessage
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  formatter.format(widget.message.time),
                  textAlign:
                      widget.ownMessage ? TextAlign.right : TextAlign.left,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // .animate(delay: 100.ms)
    // .then()
    // .scaleXY(
    //   begin: 2,
    //   end: 1,
    //   curve: Curves.easeOutExpo,
    //   duration: 400.ms,
    // )
    // .blurXY(
    //   begin: 4,
    //   end: 0,
    // );
  }
}
