import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/modules/details/components/rating_filter_bottom_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingController extends GetxController {
  final id = Get.arguments["id"];

  final formKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();

  final showFAB = false.obs;

  final docStream = FirebaseFirestore.instance
      .collection("users")
      .doc(Get.arguments["id"])
      .collection("reviews")
      .snapshots()
      .obs;

  final giveRating = 0.0.obs;

  final reviewController = TextEditingController();

  Future<void> filter() async {
    var data = await showModalBottomSheet<Map<String, dynamic>>(
      context: Get.context!,
      builder: (context) => const RatingFiltersBottomSheet(),
    );

    if (data == null) return;

    docStream.value = FirebaseFirestore.instance
        .collection("users")
        .doc(Get.arguments["id"])
        .collection("reviews")
        .where("rating", isGreaterThanOrEqualTo: data["startStars"])
        .where("rating", isLessThanOrEqualTo: data["endStars"])
        .snapshots();
  }

  Future<void> writeReview() async {
    if (FirebaseAuth.instance.currentUser == null) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning),
          content: const Text("Не можете да оставете отзив без акаунт"),
          actions: [
            TextButton(
              onPressed: () => Get.back,
              child: const Text("Ок"),
            )
          ],
        ),
      );

      return;
    }

    if (!formKey.currentState!.validate()) return;

    var text = reviewController.text.trim();

    if (text.isEmpty) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning),
          content: const Text("Не можете да оставете празен отзив"),
          actions: [
            TextButton(
              onPressed: () => Get.back,
              child: const Text("Ок"),
            )
          ],
        ),
      );
      return;
    }
    var uid = FirebaseAuth.instance.currentUser?.uid;
    var profileDoc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    var reviewDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(Get.arguments["id"])
        .collection('reviews')
        .doc(uid)
        .get();

    if (uid == Get.arguments["id"]) {
      showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.warning, size: 45),
          title:
              const Text("Не можете да оставете отзив на собствения ви акаунт"),
          actions: [
            TextButton(
              child: const Text("Oк"),
              onPressed: () => Get.back(result: true),
            ),
          ],
        ),
      );

      return;
    }

    if (reviewDoc.exists) {
      var uploadReview = await showDialog<bool>(
        context: Get.context!,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.question_mark_rounded, size: 45),
          title: const Text("Вече имате един отзив. Искате ли да го замените?"),
          actions: [
            TextButton(
              child: const Text("Не"),
              onPressed: () => Get.back(result: false),
            ),
            TextButton(
              child: const Text("Да"),
              onPressed: () => Get.back(result: true),
            ),
          ],
        ),
      );

      uploadReview ??= false;

      if (!uploadReview) return;
    }

    var profileData = profileDoc.data() ?? {};
    var data = {
      "message": text,
      "name": profileData["name"],
      "rating": giveRating.value,
      "uid": uid,
      "photoUrl": profileData["photoUrl"] ?? "",
      "date": Timestamp.now()
    };

    await FirebaseFirestore.instance
        .collection("users")
        .doc(Get.arguments["id"])
        .collection('reviews')
        .doc(uid)
        .set(data);

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text("Успешно е оставен отзив"),
      ),
    );

    giveRating.value = 0;
    reviewController.clear();
  }

  void edit(double rating, String text) {
    giveRating.value = rating;
    reviewController.text = text;
  }
}
