import 'package:educate_io/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  // TODO: implement priority
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // TODO: implement redirect
    return super.redirect(route);
  }
}
