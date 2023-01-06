import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/home/components/category_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';

class DetailsView extends GetView {
  DetailsView(this.teacher, {Key? key}) : super(key: key);

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    inspect(teacher);
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar.medium(
          flexibleSpace: FlexibleSpaceBar(
            title: Text(teacher.name),
            expandedTitleScale: 1.4,
            centerTitle: true,
            collapseMode: CollapseMode.parallax,
          ),
        ),
        SliverToBoxAdapter(
          child: ProfileView(context, teacher),
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.heart)),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.chat),
            ),
            IconButton(
              onPressed: () async => await FlutterPhoneDirectCaller.callNumber(
                  teacher.phoneNumber),
              icon: Icon(Icons.phone),
            )
          ],
        ),
      ),
      // floatingActionButton: SpeedDial(
      //   animationAngle: 20,
      //   elevation: 0,
      //   children: [
      //     SpeedDialChild(
      //       elevation: 5,
      //       label: "Напиши съобщение",
      //       labelBackgroundColor: Colors.transparent,
      //       onTap: () {},
      //       child: Icon(Icons.chat),
      //     ),
      //     SpeedDialChild(
      //       elevation: 5,
      //       label: "Обади се",
      //       labelBackgroundColor: Colors.transparent,
      //       onTap: () async =>
      //           await FlutterPhoneDirectCaller.callNumber(teacher.phoneNumber),
      //       child: Icon(Icons.phone),
      //     )
      //   ],
      //   animationCurve: Curves.easeOutQuart,
      //   animationDuration: Duration(milliseconds: 250),
      //   animatedIcon: AnimatedIcons.menu_close,
      //   childMargin: EdgeInsets.only(top: 10),
      //   curve: Curves.easeOutQuart,
      //   childrenButtonSize: Size(60, 60),
      //   spaceBetweenChildren: 10,
      // ),
    );
  }
}

SingleChildScrollView ProfileView(BuildContext context, Teacher teacher) {
  return SingleChildScrollView(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Hero(
            tag: teacher.imgUrl,
            child: CachedNetworkImage(
              imageUrl: teacher.imgUrl,
              imageBuilder: (context, imageProvider) => ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  fit: BoxFit.fitWidth,
                  image: imageProvider,
                ),
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
              CategoryCard(category: "Описание", value: teacher.description),
              for (int i = 0; i < teacher.categories.length; i++)
                Text(
                  teacher.categories[i],
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
