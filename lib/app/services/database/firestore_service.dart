import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreProfileService {
  static Future<Map<String, dynamic>?> getUserData() async {
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return null;
    }
    String uid = currentUser.uid;

    // Get the document snapshot for the current user
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    if (data == null) {
      return {};
    }

    // Get the name and photo url from the data
    String name = data['name'] ?? "";
    String photoUrl = data['photoUrl'] ?? "";
    // If there is no photo url, generate the initials from the name
    if (photoUrl.isEmpty) {
      List<String> nameParts = name.split(' ');
      String initials = '';
      for (String part in nameParts) {
        initials += part[0];
      }
      name = initials;
    }
    data.addAll({"initials": name});
    // Return a map with the name and photo url
    return data;
  }

  static Future<Map<String, dynamic>> getUserMapData() async {
    var data = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    inspect(data);

    return await data.get().then((value) => value.data() ?? {});
  }
}
