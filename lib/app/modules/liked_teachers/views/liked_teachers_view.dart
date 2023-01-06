import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/liked_teachers_controller.dart';

class LikedTeachersView extends GetView<LikedTeachersController> {
  const LikedTeachersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LikedTeachersView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'LikedTeachersView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
