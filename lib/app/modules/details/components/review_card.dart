import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReviewCard extends StatelessWidget {
  ReviewCard(
      {super.key,
      required this.review,
      required this.reviewText,
      required this.photoUrl,
      required this.name,
      required this.docId,
      required this.date});

  final double review;
  final String reviewText;
  final String photoUrl;
  final String name;
  final String docId;
  final DateTime date;

  final DateFormat dateFormatter = DateFormat("H:m | d/M/y");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => showOptions(),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
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
                        initialRating: review,
                        allowHalfRating: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(dateFormatter.format(date)),
                    ],
                  )
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
      ),
    );
  }

  void showOptions() {
    if (docId != FirebaseAuth.instance.currentUser?.uid) return;

    showModalBottomSheet(
      context: Get.context!,
      builder: (context) => Container(),
    );
  }
}
