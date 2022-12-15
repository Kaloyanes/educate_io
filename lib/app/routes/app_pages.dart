import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/skeleton/bindings/skeleton_binding.dart';
import '../modules/skeleton/views/skeleton_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SKELETON;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SKELETON,
      page: () => const SkeletonView(),
      binding: SkeletonBinding(),
    ),
  ];
}
