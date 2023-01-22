import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/modules/home/components/drawer/drawer_component.dart';
import 'package:educate_io/app/modules/home/components/teacher_category.dart';
import 'package:educate_io/app/routes/app_pages.dart';
import 'package:educate_io/app/services/database/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomeController());

    return Scaffold(
      drawer: const DrawerComponent(),
      body: CustomScrollView(
        slivers: [
          appBar(context),
          content(),
        ],
      ),
    );
  }

  SliverAppBar appBar(BuildContext context) {
    return SliverAppBar.medium(
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: StreamBuilder(
            initialData: FirebaseAuth.instance.currentUser,
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.hasError) {
                return const CircularProgressIndicator();
              }

              if (!snapshot.hasData) {
                return IconButton(
                  onPressed: () => Get.toNamed(Routes.LOGIN),
                  icon: const Icon(Icons.person),
                );
              }

              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(snapshot.data?.uid ?? "")
                    .get(),
                builder: (context, snapshot) => FutureBuilder(
                  future: FirestoreProfileService.getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData ||
                        snapshot.hasError) {
                      return const CircularProgressIndicator();
                    }

                    var data = snapshot.data;

                    Widget child = CircleAvatar(
                      child: Text(data!["initials"] ?? ""),
                    );

                    if (data["photoUrl"]?.isNotEmpty ?? false) {
                      child = CircleAvatar(
                        foregroundImage:
                            CachedNetworkImageProvider(data["photoUrl"] ?? ""),
                      );
                    }

                    return child;
                  },
                ),
              );
            },
          ),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text("Учители"),
        centerTitle: true,
      ),
      stretch: true,
    );
  }

  SliverToBoxAdapter content() {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          welcomeText(),
          StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (FirebaseAuth.instance.currentUser == null) {
                return Column(
                  children: [
                    TeacherSubject(subject: "Програмиране"),
                  ],
                );
              }

              return FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Text("maika ti");
                  }

                  var list = snapshot.data!.data()?[
                      snapshot.data!.get("role") == "teacher"
                          ? "subjects"
                          : "badSubjects"] as List<dynamic>;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) => TeacherSubject(
                      subject: list.elementAt(index),
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(
            height: Get.mediaQuery.padding.bottom,
          )
        ],
      ),
    );
  }

  Align welcomeText() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 30, left: 10, top: 20),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser?.uid ?? "example")
              .snapshots(),
          builder: (context, snapshot) {
            return Text(
              "Добре дошъл\n${snapshot.data?["name"] ?? ""}",
              style: Theme.of(Get.context!).textTheme.titleLarge,
            );
          },
        ),
      ),
    );
  }
}
