import 'package:educate_io/app/services/database/firestore_service.dart';
import 'package:educate_io/app/services/get_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final authStream = FirebaseAuth.instance.authStateChanges();

  @override
  void onInit() {
    super.onInit();
  }

  Future<String> getName() async {
    var data = await FirestoreProfileService.getUserData();
    return data?["name"] ?? "";
  }
}
