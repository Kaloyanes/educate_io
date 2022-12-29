import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/user_model.dart';
import 'package:educate_io/app/modules/auth/google_data/views/google_data_view.dart';
import 'package:educate_io/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  static Future<void> login(String email, String password) async {
    var auth = FirebaseAuth.instance;
    UserCredential? credential;

    try {
      credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    }
  }

  static Future<void> logOut() async => await FirebaseAuth.instance.signOut();

  static Future<void> createAccount(UserModel createUser) async {
    var auth = FirebaseAuth.instance;
    var store = FirebaseFirestore.instance;

    var user = await auth.createUserWithEmailAndPassword(
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

    print("maika ti");

    var userCred = await auth.signInWithCredential(credential);
    var doc = store.collection("users").doc(auth.currentUser?.uid);

    var doc2 = await doc.get();
    if (doc2.exists) {
      print("doc exists");
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
}
