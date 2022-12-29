part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const AUTH = _Paths.AUTH;
  static const LOGIN = _Paths.AUTH + _Paths.LOGIN;
  static const REGISTER = _Paths.AUTH + _Paths.REGISTER;
  static const PROFILE = _Paths.PROFILE;
  static const PROFILE_SETTINGS = _Paths.PROFILE + _Paths.PROFILE_SETTINGS;
  static const GOOGLE_DATA = _Paths.AUTH + _Paths.GOOGLE_DATA;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const AUTH = '/auth';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const PROFILE = '/profile';
  static const PROFILE_SETTINGS = '/settings';
  static const GOOGLE_DATA = '/google-data';
}
