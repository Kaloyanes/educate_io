import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/home/components/drawer/drawer_component.dart';
import 'package:educate_io/app/modules/home/components/profile_picture.dart';
import 'package:educate_io/app/modules/home/components/teacher_category.dart';
import 'package:educate_io/app/modules/search/views/search_view.dart';
import 'package:educate_io/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => HomeController());

    return Scaffold(
      drawer: const DrawerComponent(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar.large(
            forceElevated: innerBoxIsScrolled,
            actions: [
              IconButton(
                onPressed: () => Get.to(
                  const SearchView(),
                ),
                icon: const Icon(Icons.search),
              ),
              const SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                    onTap: () => Get.toNamed(Routes.PROFILE_SETTINGS),
                    child: const ProfilePicture()),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Ментори",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              centerTitle: true,
            ),
            expandedHeight: 120,
            stretch: true,
          ),
        ],
        body: Column(
          children: [
            welcomeText(),
            Expanded(child: teacherListings()),
          ],
        ),
      ),
    );
  }

  Widget content() {
    return Column(
      children: <Widget>[
        welcomeText(),
        teacherListings(),
      ].animate(interval: 100.ms).fadeIn(
            curve: Curves.easeOut,
          ),
    );
  }

  StreamBuilder<User?> teacherListings() {
    return StreamBuilder(
      stream: controller.authStream,
      builder: (context, snapshot) {
        if (FirebaseAuth.instance.currentUser == null) {
          return Column(
            children: const [
              TeacherSubject(
                subject: "Програмиране",
                isGrid: false,
              ),
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var user = Teacher.fromMap(snapshot.data!.data()!);

            var list = user.badSubjects ?? user.subjects;

            return Obx(() {
              if (controller.isGrid.value) {
                return PageView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) => TeacherSubject(
                    isGrid: true,
                    subject: list.elementAt(index),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: list.length < 10 ? list.length : 10,
                itemBuilder: (context, index) => TeacherSubject(
                  isGrid: false,
                  subject: list.elementAt(index),
                ),
              );
            });
          },
        );
      },
    );
  }

  Widget welcomeText() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(bottom: 0, left: 20, top: 0),
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          var user = snapshot.data;

          return FutureBuilder(
            future: FirebaseFirestore.instance
                .collection("users")
                .doc(user?.uid ?? "awe")
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              var text = "Добре дошъл,";

              if (!snapshot.hasError && snapshot.data!.exists) {
                text += "\n${snapshot.data?["name"] ?? ""}";
              }

              return Text(
                text,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.left,
              )
                  .animate()
                  .scaleXY(
                    begin: 0,
                    end: 1,
                    curve: Curves.easeOutExpo,
                    duration: 350.ms,
                  )
                  .blurXY(
                    begin: 2,
                    end: 0,
                    curve: Curves.easeOutExpo,
                    delay: 150.ms,
                    duration: 300.ms,
                  );
            },
          );
        },
      ),
    );
  }
}
