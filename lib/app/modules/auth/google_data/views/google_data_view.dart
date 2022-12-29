import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/google_data_controller.dart';

class GoogleDataView extends GetView<GoogleDataController> {
  const GoogleDataView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GoogleDataView'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Get.back(
            result: <String, dynamic>{
              "birthDay": DateTime(2006, 7, 2),
            },
          ),
          child: Text("back"),
        ),
      ),
    );
  }
}
