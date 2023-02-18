import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LikedTeachersController extends GetxController {
  List<String> teachers = [];

  Future<void> removeTeacher(String uid) async {
    teachers.removeWhere((element) => element == uid);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"likedTeachers": teachers});
  }
}
