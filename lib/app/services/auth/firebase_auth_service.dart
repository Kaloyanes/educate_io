import 'package:educate_io/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  static Future<void> login(String email, String password) async {
    var instance = FirebaseAuth.instance;

    try {
      await instance.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }

  static Future<void> logOut() async {
    var instance = FirebaseAuth.instance;

    await instance.signOut();
  }

  static Future<void> createAccount(String email, String password) async {
    var instance = FirebaseAuth.instance;
  }

  static Future<void> logInGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    Get.back();
  }
}
