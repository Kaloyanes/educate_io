import 'package:get/get.dart';

import '../middleware/auth_middleware.dart';
import '../modules/auth/login/bindings/login_binding.dart';
import '../modules/auth/login/views/login_view.dart';
import '../modules/auth/register/bindings/register_binding.dart';
import '../modules/auth/register/views/google_data_view.dart';
import '../modules/auth/register/views/register_view.dart';
import '../modules/chats/bindings/chats_binding.dart';
import '../modules/chats/views/chats_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/liked_teachers/bindings/liked_teachers_binding.dart';
import '../modules/liked_teachers/views/liked_teachers_view.dart';
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
    GetPage(
      name: _Paths.CHATS,
      page: () => const ChatsView(),
      binding: ChatsBinding(),
    ),
    GetPage(
      name: _Paths.LIKED_TEACHERS,
      page: () => const LikedTeachersView(),
      binding: LikedTeachersBinding(),
    ),
  ];
}
