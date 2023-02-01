import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/modules/auth/register/views/google_data_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  static Future<void> login(String email, String password) async {
    try {
      var auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  static Future<void> logOut() async => await FirebaseAuth.instance.signOut();

  static Future<void> createAccount(
      Map<String, dynamic> userData, String email, String password) async {
    try {
      var auth = FirebaseAuth.instance;
      var store = FirebaseFirestore.instance;

      var user = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      user.user?.sendEmailVerification();

      var doc = store.collection("users").doc(user.user?.uid);

      doc.set(userData);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  static Future<void> logInGoogle() async {
    var auth = FirebaseAuth.instance;
    var store = FirebaseFirestore.instance;

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    var userCred = await auth.signInWithCredential(credential);
    var doc = store.collection("users").doc(auth.currentUser?.uid);

    var doc2 = await doc.get();
    if (doc2.exists) {
      Get.back();
      return;
    }

    var data =
        await Get.off<Map<String, dynamic>>(const GoogleDataView()) ?? {};

    data.addAll(
      {
        "name": "Калоян Стоянов",
        "email": userCred.user?.email,
      },
    );

    doc.set(data);

    Get.back();
  }

  static Future<void> forgotPassword(String email) async {
    var auth = FirebaseAuth.instance;
    await auth.sendPasswordResetEmail(
      email: email,
    );
  }
}
