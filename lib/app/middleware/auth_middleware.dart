import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // var user = FirebaseAuth.instance.currentUser;
    // if (user != null) {
    //   FirebaseFirestore.instance
    //       .collection("users")
    //       .doc(user.uid)
    //       .get()
    //       .then((value) {
    //     if (!value.exists) {
    //       Get.offAndToNamed(Routes.GOOGLE_DATA);
    //     }
    //   });
    // }

    return super.redirect(route);
  }
}
