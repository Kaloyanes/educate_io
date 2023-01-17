import 'package:dynamic_color/dynamic_color.dart';
import 'package:educate_io/app/firebase_options.dart';
import 'package:educate_io/app/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FlutterNativeSplash.preserve(widgetsBinding: binding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
  // FlutterNativeSplash.remove();
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  static ColorScheme defaultLight =
      ColorScheme.fromSeed(seedColor: Colors.deepPurple);

  static ColorScheme defaultDark = ColorScheme.fromSeed(
      seedColor: Colors.deepPurple, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (light, dark) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setSystemUIOverlayStyle(
          const SystemUiOverlayStyle(
            systemNavigationBarColor: Colors.transparent,
            statusBarColor: Colors.transparent,
          ),
        );
        SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
        );

        return GetMaterialApp(
          title: "EducateIO",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          themeMode: ThemeMode.system,
          theme: Themes.theme(light ?? defaultLight),
          darkTheme: Themes.theme(dark ?? defaultDark),
          debugShowCheckedModeBanner: false,
          scrollBehavior: const CupertinoScrollBehavior(),
          locale: Locale("bg"),
          defaultTransition: Transition.native,
          popGesture: false,
          // transitionDuration: const Duration(milliseconds: 400),
          smartManagement: SmartManagement.full,
        );
      },
    );
  }
}
