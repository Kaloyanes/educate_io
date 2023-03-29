import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/modules/details/controllers/rating_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReviewCard extends StatelessWidget {
  ReviewCard({
    super.key,
    required this.rating,
    required this.reviewText,
    required this.photoUrl,
    required this.name,
    required this.docId,
    required this.date,
    required this.userId,
  });

  final double rating;
  final String reviewText;
  final String photoUrl;
  final String name;
  final String docId;
  final DateTime date;
  final String userId;

  final DateFormat dateFormatter = DateFormat("HH:m | d/MM/y");

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CircleAvatar(
                        foregroundImage: CachedNetworkImageProvider(photoUrl),
                        radius: 30,
                        child: const Icon(
                          Icons.person_rounded,
                          size: 35,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(name),
                  ],
                ),
                Expanded(child: Container()),
                Row(
                  children: [
                    Column(
                      children: [
                        RatingBar.builder(
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          itemSize: 25,
                          onRatingUpdate: (value) {},
                          ignoreGestures: true,
                          initialRating: rating,
                          allowHalfRating: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(dateFormatter.format(date)),
                      ],
                    ),
                    const SizedBox(width: 10),
                    if (docId == (FirebaseAuth.instance.currentUser?.uid ?? ""))
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () => editReview(),
                            child: const Text("Редактирай"),
                          ),
                          PopupMenuItem(
                            onTap: () => deleteReview(),
                            child: const Text(
                              "Изтрий",
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        ],
                        child: const Icon(Icons.more_vert),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                reviewText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void editReview() {
    var controller = Get.find<RatingController>();

    controller.edit(rating, reviewText);
  }

  Future<void> deleteReview() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("reviews")
        .doc(docId)
        .delete();

    ScaffoldMessenger.of(Get.context!)
        .showSnackBar(const SnackBar(content: Text("Успешно изтрихте отзива")));
  }
}
