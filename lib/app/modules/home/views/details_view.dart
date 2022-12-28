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
    return Scaffold(
      extendBodyBehindAppBar: false,
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.heart))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
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
                filterQuality: FilterQuality.low,
                imageBuilder: (context, imageProvider) => ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(image: imageProvider),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    teacher.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CategoryCard(
                      category: "Описание", value: teacher.description),
                  for (int i = 0; i < teacher.categories.length; i++)
                    Text(
                      teacher.categories[i],
                      style: Get.textTheme.headlineSmall,
                    ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
