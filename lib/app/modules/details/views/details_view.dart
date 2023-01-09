import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/details/components/category_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:get/get.dart';

import '../controllers/details_controller.dart';

class DetailsView extends GetView<DetailsController> {
  const DetailsView(this.teacher, {Key? key}) : super(key: key);

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(
      () => DetailsController(),
    );
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar.medium(
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              teacher.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            expandedTitleScale: 1.4,
            centerTitle: true,
            collapseMode: CollapseMode.parallax,
          ),
        ),
        SliverToBoxAdapter(
          child: profileView(context, teacher),
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            favouriteButton(),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.chat),
            ),
            IconButton(
              onPressed: () async =>
                  await FlutterPhoneDirectCaller.callNumber(teacher.phone),
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
            .contains(teacher.uid)) {
          icon = CupertinoIcons.heart_fill;
        }

        return IconButton(
          onPressed: () => favoriteTeacher(teacher),
          icon: Icon(icon),
        );
      },
    );
  }
}

SingleChildScrollView profileView(BuildContext context, Teacher teacher) {
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
              const CategoryCard(category: "Описание", value: ""),
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
      ],
    ),
  );
}

Future<void> favoriteTeacher(Teacher teacher) async {
  var doc = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid);

  var teachers =
      await doc.get().then((value) => value.get("likedTeachers") as List);

  if (teachers.contains(teacher.uid)) {
    teachers.remove(teacher.uid);

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text("Премахнат учител от любими учители"),
        duration: Duration(seconds: 2),
      ),
    );
  } else {
    teachers.add(teacher.uid);
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text("Успешно добавен учител към любими учители"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  doc.update({"likedTeachers": teachers});
}
