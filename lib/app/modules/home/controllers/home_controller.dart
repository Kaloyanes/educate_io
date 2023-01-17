import 'package:educate_io/app/services/database/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Stream authStream = const Stream.empty();

  @override
  void onInit() {
    super.onInit();
    authStream = FirebaseAuth.instance.authStateChanges();
  }

  Future<String> getName() async {
    var data = await FirestoreProfileService.getUserData();
    return data?["name"] ?? "";
  }

  // void showProfileSettings() {
  //   HapticFeedback.selectionClick();
  //   showDialog(
  //     context: Get.context!,
  //     builder: (context) => const ProfileSettingsDialog(),
  //   );
  // }
}
