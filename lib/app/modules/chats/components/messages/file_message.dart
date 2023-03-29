import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:educate_io/app/modules/chats/components/message_settings.dart';
import 'package:educate_io/app/modules/chats/models/message_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class FileMessage extends StatelessWidget {
  const FileMessage(
      {super.key,
      required this.message,
      required this.ownMessage,
      required this.doc});

  final Message message;
  final bool ownMessage;
  final DocumentReference doc;

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseStorage.instance.refFromURL(message.value);

    return Align(
      alignment: ownMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () async {
          if (!ownMessage) return;

          await showModalBottomSheet<String>(
            context: context,
            builder: (context) => MessageSettings(
              doc: doc,
            ),
          );
        },
        onTap: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Стартира изтеглянето на ${ref.name}"),
              behavior: SnackBarBehavior.floating,
              // elevation: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
            ),
          );
          Dio dio = Dio();
          Directory dir = await getApplicationDocumentsDirectory();
          String path = dir.path;

          await dio.download(message.value, '$path/${ref.name}');
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Успешно изтеглихте ${ref.name}"),
              behavior: SnackBarBehavior.floating,
              // elevation: 20,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 7),
          child: Container(
            constraints: BoxConstraints(maxWidth: Get.width / 2),
            padding: const EdgeInsets.all(15.0),
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
            child: Row(
              children: [
                const Icon(
                  Icons.file_download,
                  size: 40,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    ref.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
