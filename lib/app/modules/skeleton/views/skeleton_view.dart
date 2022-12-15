import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/skeleton_controller.dart';

class SkeletonView extends GetView<SkeletonController> {
  const SkeletonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SkeletonView'),
        centerTitle: true,
      ),
      body: Text("MAK"),
    );
  }
}
