import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final listController = ScrollController(keepScrollOffset: true);

  @override
  void onInit() {
    super.onInit();
    Timer(
      const Duration(milliseconds: 1),
      () => listController.jumpTo(
        listController.position.maxScrollExtent,
      ),
    );
  }
}
