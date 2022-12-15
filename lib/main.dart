import 'package:educate_io/app/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      scrollBehavior: const CupertinoScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: Themes.theme(),
      darkTheme: Themes.theme(darkMode: true),
    ),
  );
}
