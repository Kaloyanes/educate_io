import 'package:get/get.dart';

import '../middleware/auth_middleware.dart';
import '../modules/auth/google_data/bindings/google_data_binding.dart';
import '../modules/auth/google_data/views/google_data_view.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/profile_settings/bindings/profile_settings_bindings.dart';
import '../modules/profile/profile_settings/views/profile_settings_view.dart';
import '../modules/profile/views/profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: [
        AuthMiddleware(),
      ],
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const LoginView(),
      children: [
        GetPage(
          name: _Paths.LOGIN,
          page: () => const LoginView(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: _Paths.REGISTER,
          page: () => const RegisterView(),
          binding: RegisterBinding(),
        ),
        GetPage(
          name: _Paths.GOOGLE_DATA,
          page: () => const GoogleDataView(),
          binding: GoogleDataBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      children: [
        GetPage(
          name: _Paths.PROFILE_SETTINGS,
          page: () => const ProfileSettingsView(),
          binding: ProfileSettingsBinding(),
        ),
      ],
    ),
  ];
}
