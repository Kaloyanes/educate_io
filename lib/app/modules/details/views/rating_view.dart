import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/modules/details/components/review_card.dart';
import 'package:educate_io/app/modules/details/controllers/rating_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:get/get.dart';

class RatingView extends GetView<RatingController> {
  const RatingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => RatingController());

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is UserScrollNotification &&
              notification.direction != ScrollDirection.idle) {
            controller.showFAB.value =
                notification.direction == ScrollDirection.forward &&
                    !notification.metrics.atEdge;
          }

          return false;
        },
        child: CustomScrollView(
          controller: controller.scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverAppBar.medium(
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_alt),
                  onPressed: () => controller.filter(),
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Отзиви",
                    style: Theme.of(context).textTheme.headlineSmall),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ratingInfo(context),
                    Obx(
                      () => StreamBuilder(
                        stream: controller.docStream.value,
                        builder: (context, snapshot) {
                          if (snapshot.data == null ||
                              !snapshot.hasData ||
                              snapshot.connectionState ==
                                  ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          var docs = snapshot.data!.docs;
                          if (docs.isEmpty) {
                            return Center(
                              child: Text(
                                "Няма отзиви",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            );
                          }

                          var index = docs.indexWhere((element) {
                            String uid =
                                FirebaseAuth.instance.currentUser?.uid ?? "";
                            return element.id == uid;
                          });

                          if (index != -1) {
                            var doc = docs[index];
                            docs.insert(0, doc);

                            docs.removeAt(docs.lastIndexWhere(
                              (element) => element.id == doc.id,
                            ));
                          }

                          return ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              for (int i = 0; i < docs.length; i++)
                                Builder(
                                  builder: (context) {
                                    var docId = docs[i].id;

                                    var data = docs[i].data();

                                    return ReviewCard(
                                      docId: docId,
                                      userId: Get.arguments["id"],
                                      name: data["name"],
                                      rating: data["rating"] as double,
                                      reviewText: data["message"],
                                      photoUrl: data["photoUrl"],
                                      date: DateTime.fromMillisecondsSinceEpoch(
                                        (data["date"] as Timestamp)
                                            .millisecondsSinceEpoch,
                                      ),
                                    );
                                  },
                                )
                            ].animate(interval: 70.ms).scaleXY(
                                  end: 1,
                                  begin: 0,
                                  duration: 600.ms,
                                  curve: Curves.easeInOutQuint,
                                ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: Obx(
      //   () => FloatingActionButton(
      //     onPressed: () => controller.scrollToTop(),
      //     child: const Icon(
      //       Icons.arrow_upward,
      //     ),
      //   )
      //       .animate(target: controller.showFAB.value ? 1 : 0)
      //       .scaleXY(
      //         curve: Curves.easeOutCubic,
      //         duration: 400.ms,
      //         delay: 150.ms,
      //         begin: -1,
      //         end: 1,
      //       )
      //       .slideY(
      //         begin: 4,
      //         end: 0,
      //         curve: Curves.easeInOutExpo,
      //         duration: 800.ms,
      //       )
      //       .blurXY(
      //         begin: 3,
      //         end: 0,
      //         duration: 450.ms,
      //         curve: Curves.easeOut,
      //       ),
      // ),
    );
  }

  Column ratingInfo(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(
              () => RatingBar.builder(
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Theme.of(context).colorScheme.primary,
                ),
                initialRating: controller.giveRating.value,
                onRatingUpdate: (value) => controller.giveRating.value = value,
                allowHalfRating: true,
                glow: true,
                updateOnDrag: true,
              ),
            ),
            Obx(
              () => Text(
                controller.giveRating.value.toStringAsFixed(1),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Obx(() {
          var to = controller.giveRating.value == 0.0;

          return AnimatedOpacity(
            opacity: to ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuart,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutQuart,
                  constraints: to
                      ? const BoxConstraints.tightFor(
                          width: 0,
                          height: 0,
                        )
                      : const BoxConstraints.tightFor(
                          width: 400,
                          height: 120,
                        ),
                  child: Form(
                    key: controller.formKey,
                    child: TextFormField(
                      controller: controller.reviewController,
                      maxLines: 3,
                      minLines: 3,
                      decoration: InputDecoration(
                        labelText: "Ревю",
                        suffixIcon: controller.reviewController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () =>
                                    controller.reviewController.clear(),
                                icon: const Icon(Icons.clear),
                              )
                            : null,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Попълнете полето";
                        }

                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutQuart,
                  constraints: to
                      ? const BoxConstraints.tightFor(width: 0, height: 0)
                      : const BoxConstraints.tightFor(width: 300, height: 40),
                  child: ElevatedButton(
                    onPressed: () => controller.writeReview(),
                    child: const Text("Качи "),
                  ),
                )
              ],
            ),
          );
        }),
      ],
    );
  }
}
