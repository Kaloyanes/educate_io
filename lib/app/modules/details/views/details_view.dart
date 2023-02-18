import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/details/components/category_card.dart';
import 'package:educate_io/app/modules/details/views/rating_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../controllers/details_controller.dart';

class DetailsView extends GetView<DetailsController> {
  const DetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(
      () => DetailsController(),
    );
    return Scaffold(
        body: CupertinoScrollbar(
          child: CustomScrollView(slivers: [
            SliverAppBar.medium(
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  controller.teacher.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                expandedTitleScale: 1.4,
                centerTitle: true,
                collapseMode: CollapseMode.parallax,
              ),
              actions: [
                IconButton(
                  onPressed: () => controller.report(),
                  icon: const Icon(
                    Icons.report_rounded,
                    color: Colors.red,
                    size: 25,
                  ),
                )
              ],
            ),
            SliverToBoxAdapter(
              child: profileView(context, controller.teacher),
            ),
          ]),
        ),
        bottomNavigationBar: BottomAppBar(
          height: MediaQuery.of(context).padding.bottom + 60,
          child: Row(
            children: [
              favouriteButton(),
              const Spacer(),
              if (FirebaseAuth.instance.currentUser != null)
                IconButton(
                  onPressed: () => controller.createChat(),
                  icon: const Icon(Icons.chat),
                ),
              if (controller.teacher.phone != null)
                IconButton(
                  onPressed: () => controller.callTeacher(),
                  icon: const Icon(Icons.phone),
                )
            ],
          ),
        ));
  }

  Widget favouriteButton() {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      return Container();
    }

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const Icon(null);
        }

        var icon = CupertinoIcons.heart;

        if (List.castFrom(snapshot.data?["likedTeachers"])
            .contains(controller.teacher.uid)) {
          icon = CupertinoIcons.heart_fill;
        }

        return IconButton(
          onPressed: () => controller.favoriteTeacher(controller.teacher),
          icon: Icon(icon),
        );
      },
    );
  }

  Widget profileView(BuildContext context, Teacher teacher) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Hero(
              tag: teacher,
              createRectTween: (begin, end) =>
                  MaterialRectCenterArcTween(begin: begin, end: end),
              child: CachedNetworkImage(
                imageUrl: teacher.photoUrl!,
                imageBuilder: (context, imageProvider) => ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    fit: BoxFit.fitWidth,
                    width: 350,
                    image: imageProvider,
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.question_mark,
                  size: 50,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                personalInfo(teacher),
                if (teacher.description != null)
                  CategoryCard(
                    category: "Описание",
                    value: Text(
                      teacher.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                subjectsColumn(teacher, context),
                const SizedBox(
                  height: 10,
                ),
              ].animate(interval: 70.ms).scaleXY(
                    end: 1,
                    begin: 0,
                    duration: 600.ms,
                    curve: Curves.easeInOutQuint,
                  ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          rating(teacher).animate(delay: 300.ms).scaleXY(
                delay: 150.ms,
                begin: 0,
                duration: 600.ms,
                end: 1,
                curve: Curves.easeInOutExpo,
              ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  ListTile rating(Teacher teacher) {
    return ListTile(
      onTap: () => Get.to(
        () => const RatingView(),
        arguments: {
          "id": teacher.uid,
        },
      ),
      title: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(teacher.uid)
              .collection("reviews")
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var docs = snapshot.data!.docs;

            var rating = 0.0;
            if (docs.isNotEmpty) {
              for (var element in docs) {
                rating += element.data()["rating"] as num;
              }

              rating /= docs.length;
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RatingBar.builder(
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onRatingUpdate: (value) {},
                      ignoreGestures: true,
                      allowHalfRating: true,
                      initialRating: rating,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Text(
                  "${docs.length} ${docs.length == 1 ? "отзив" : "отзиви"}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                  ),
                )
              ],
            );
          }),
    );
  }

  Row subjectsColumn(Teacher teacher, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (teacher.badSubjects != null)
          Expanded(
            child: CategoryCard(
              category: "Търси",
              value: Column(
                children: [
                  for (var badSubject in teacher.badSubjects!)
                    Text(
                      badSubject,
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                ],
              ),
            ),
          ),
        Expanded(
          child: CategoryCard(
            category: "Обучава",
            value: Column(
              children: [
                for (var subject in teacher.subjects)
                  Text(
                    subject,
                    style: Theme.of(context).textTheme.titleMedium,
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row personalInfo(Teacher teacher) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          flex: 3,
          child: GestureDetector(
            onTap: () => controller.launchEmail(),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: FittedBox(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.email,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          teacher.email,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: FittedBox(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.cake_rounded,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        (DateTime.now().difference(teacher.birthDay).inDays /
                                365)
                            .toStringAsFixed(0),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
