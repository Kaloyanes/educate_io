import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  // TODO: implement priority
  int? get priority => 1;

  bool isAuthenticated = false;

  @override
  RouteSettings? redirect(String? route) {
    if (!isAuthenticated) return RouteSettings(name: "/login");

    // TODO: implement redirect
    return super.redirect(route);
  }
}
