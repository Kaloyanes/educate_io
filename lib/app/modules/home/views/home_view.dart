import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/modules/home/components/teach_card.dart';
import 'package:educate_io/app/routes/app_pages.dart';
import 'package:educate_io/app/services/auth/firebase_auth_service.dart';
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
            stream: FirebaseAuth.instance.userChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                print(snapshot.error);
                return CircularProgressIndicator();
              }

              if (!snapshot.hasData) {
                return IconButton(
                  onPressed: () => Get.toNamed(Routes.LOGIN),
                  icon: Icon(Icons.person),
                );
              }

              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(snapshot.data?.uid ?? "")
                    .snapshots(),
                builder: (context, snapshot) => FutureBuilder(
                  future: controller.getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return CircularProgressIndicator();
                    }

                    var data = snapshot.data;

                    Widget child = const CircularProgressIndicator();

                    child = CircleAvatar(
                      child: Text(data!["name"]!),
                    );

                    if (data["photoUrl"]!.isNotEmpty) {
                      child = CircleAvatar(
                        foregroundImage:
                            CachedNetworkImageProvider(data["photoUrl"]!),
                      );
                    }

                    return GestureDetector(
                      child: child,
                      onTap: () => controller.showProfileSettings(),
                    );
                  },
                ),
              );
            },
          ),
        )
      ],
      title: const Text(
        "Учители",
      ),
      centerTitle: true,
      pinned: true,
      stretch: true,
    );
  }

  SliverToBoxAdapter content() {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(bottom: 30, left: 10, top: 20),
              child: Text(
                "Добре дошъл\nКалоян",
                style: Get.textTheme.titleLarge,
              ),
            ),
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: controller.teachers.length,
              itemBuilder: (BuildContext context, int index) => TeachCard(
                teacher: controller.teachers[index],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          for (int i = 1; i <= 100; i++)
            Text(
              i.toString(),
              style: Theme.of(Get.context!).textTheme.headlineSmall,
            ),
          ElevatedButton(
              onPressed: () => FirebaseAuthService.logOut(),
              child: Text("log out"))
        ],
      ),
    );
  }
}
