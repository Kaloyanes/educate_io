import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/modules/chats/components/message_settings.dart';
import 'package:educate_io/app/modules/chats/models/message_model.dart';
import 'package:educate_io/app/modules/chats/controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatefulWidget {
  const ChatMessage(
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

class _ChatMessageState extends State<ChatMessage> {
  DateFormat formatter = DateFormat("H:mm | d/MM/yyyy");

  bool showInfo = false;

  @override
  void initState() {
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

          await showModalBottomSheet<String>(
            context: context,
            builder: (context) => MessageSettings(
              doc: widget.doc,
            ),
          );
        },
        onTap: () {
          setState(() {
            showInfo = !showInfo;
          });
          HapticFeedback.selectionClick();
        },
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
              const SizedBox(
                height: 10,
              ),
              AnimatedContainer(
                curve: Curves.fastLinearToSlowEaseIn,
                height: showInfo ? 20 : 0,
                duration: 600.ms,
                alignment: widget.ownMessage
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(
                  formatter.format(widget.message.time),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
