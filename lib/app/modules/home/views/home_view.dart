import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:educate_io/app/modules/home/components/teach_card.dart';
import 'package:educate_io/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
          SliverAppBar(
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: StreamBuilder(
                  stream: FirebaseAuth.instance.userChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return IconButton(
                        onPressed: () => Get.toNamed(Routes.LOGIN),
                        icon: Icon(Icons.person),
                      );
                    }

                    var instance = FirebaseAuth.instance;

                    var name = instance.currentUser!.displayName!.split(' ');

                    String display = "";
                    name.forEach(
                      (element) => display += element[0],
                    );

                    var child = CircleAvatar();

                    if (instance.currentUser?.photoURL != null) {
                      child = CircleAvatar(
                        foregroundImage: CachedNetworkImageProvider(
                          instance.currentUser!.photoURL!,
                        ),
                      );
                    } else {
                      child = CircleAvatar(
                        child: Text(
                          display,
                        ),
                      );
                    }

                    return GestureDetector(
                      onTap: () => controller.showProfileSettings(),
                      child: child,
                    );
                  },
                ),
              )
            ],
            title: Text(
              "Учители",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            centerTitle: false,
            elevation: 0,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(),
              ),
            ),
            floating: true,
            forceElevated: false,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30, left: 10, top: 20),
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
                    itemBuilder: (BuildContext context, int index) {
                      return TeachCard(teacher: controller.teachers[index]);
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
