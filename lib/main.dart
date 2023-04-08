import 'package:dynamic_color/dynamic_color.dart';
import 'package:educate_io/app/controllers/main_controller.dart';
import 'package:educate_io/app/services/get_storage_service.dart';
import 'package:educate_io/app/themes.dart';
import 'package:educate_io/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  final ImagePickerPlatform imagePickerImplementation =
      ImagePickerPlatform.instance;

  if (imagePickerImplementation is ImagePickerAndroid) {
    imagePickerImplementation.useAndroidPhotoPicker = true;
  }

  if (kDebugMode) {
    Animate.restartOnHotReload = true;
  }

  await dotenv.load(fileName: ".env");

  var binding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: binding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init("settings");

  runApp(const App());
}

class App extends GetView<MainController> {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => MainController());
    return DynamicColorBuilder(
      builder: (light, dark) {
        return Obx(() {
          if (controller.dynamicColor.value && light != null && dark != null) {
            controller.lightColor.value = light;
            controller.darkColor.value = dark;
          }

          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.transparent,
              statusBarColor: Colors.transparent,
              systemNavigationBarContrastEnforced: false,
            ),
          );
          SystemChrome.setPreferredOrientations(
            [
              DeviceOrientation.portraitUp,
            ],
          );

          var themeMode = GetStorageService().getThemeMode();

          FlutterNativeSplash.remove();

          return GetMaterialApp(
            title: "EducateIO",
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            themeMode: themeMode,
            theme: Themes.theme(controller.lightColor.value),
            darkTheme: Themes.theme(controller.darkColor.value),
            debugShowCheckedModeBanner: false,
            // scrollBehavior: const CupertinoScrollBehavior(),
            locale: const Locale("bg", "BG"),
            defaultTransition: Transition.native,
            routingCallback: (value) {
              HapticFeedback.mediumImpact();
            },
            // localizationsDelegates: const [
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            //   GlobalCupertinoLocalizations.delegate,
            // ],
          );
        });
      },
    );
  }
}
