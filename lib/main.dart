import 'package:educate_io/app/pages/home/views/home.dart';
import 'package:educate_io/app/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

final _router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(
    GetMaterialApp(
      title: "Application",
      scrollBehavior: const CupertinoScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: Themes.theme(),
      darkTheme: Themes.theme(darkMode: true),
      home: HomePage(),
    ),
  );
}
