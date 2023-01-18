import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/details/components/category_card.dart';
import 'package:educate_io/app/modules/details/views/rating_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
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
          ),
          SliverToBoxAdapter(
            child: profileView(context, controller.teacher),
          ),
        ]),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            favouriteButton(),
            const Spacer(),
            IconButton(
              onPressed: () => controller.createChat(),
              icon: const Icon(Icons.chat),
            ),
            if (controller.teacher.phone != null)
              IconButton(
                onPressed: () async =>
                    await FlutterPhoneDirectCaller.callNumber(
                        controller.teacher.phone!),
                icon: const Icon(Icons.phone),
              )
          ],
        ),
      ),
    );
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
              child: CachedNetworkImage(
                imageUrl: teacher.photoUrl,
                imageBuilder: (context, imageProvider) => ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(
                    fit: BoxFit.fitWidth,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                if (teacher.description != null)
                  CategoryCard(
                      category: "Описание", value: teacher.description!),
                for (int i = 0; i < teacher.subjects.length; i++)
                  Text(
                    teacher.subjects[i],
                    style: Get.textTheme.headlineSmall,
                  ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: 5,
            itemBuilder: (context, index) => Center(
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.money_dollar),
                      const Text("200"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
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
                    return Center(
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
                            onRatingUpdate: (value) => print(value),
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
                        "${docs.length} ${docs.length == 1 ? "ревю" : "ревюта"}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 20,
                        ),
                      )
                    ],
                  );
                }),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
