import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/user_model.dart';
import 'package:educate_io/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  static Future<void> login(String email, String password) async {
    var instance = FirebaseAuth.instance;
    UserCredential? credential;

    try {
      credential = await instance.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }

  static Future<void> logOut() async => await FirebaseAuth.instance.signOut();

  static Future<void> createAccount(UserModel createUser) async {
    var instance = FirebaseAuth.instance;
    var store = FirebaseFirestore.instance;

    var user = await instance.createUserWithEmailAndPassword(
      email: createUser.email,
      password: createUser.password,
    );

    user.user?.sendEmailVerification();
    user.user?.updateDisplayName(createUser.name);

    var doc = store.collection("users").doc(user.user?.uid);

    doc.set({
      "name": createUser.name,
      "age": createUser.age,
      "birthday": createUser.birthDate,
      "role": createUser.role,
      "email": createUser.email,
    });
  }

  static Future<void> logInGoogle() async {
    await FirebaseAuth.instance.signInWithProvider(GoogleAuthProvider());
    Get.back();
    return;

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
