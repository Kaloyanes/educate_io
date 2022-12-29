import 'dart:developer';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/home/components/category_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          actions: [
            IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.heart))
          ],
          title: Text(teacher.name),
        ),
        SliverToBoxAdapter(
          child: ProfileView(context, teacher),
        ),
      ]),
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
            flightShuttleBuilder: (
              flightContext,
              animation,
              flightDirection,
              fromHeroContext,
              toHeroContext,
            ) =>
                SizeTransition(
              sizeFactor: animation,
              axis: Axis.horizontal,
              child: toHeroContext.widget,
            ),
            tag: teacher,
            child: CachedNetworkImage(
              imageUrl: teacher.imgUrl,
              filterQuality: FilterQuality.medium,
              imageBuilder: (context, imageProvider) => Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(image: imageProvider),
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
