import 'package:cached_network_image/cached_network_image.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsView extends GetView {
  const DetailsView(this.teacher, {Key? key}) : super(key: key);

  final Teacher teacher;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(teacher.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: teacher.imgUrl,
            child: CachedNetworkImage(
              imageUrl: teacher.imgUrl,
              imageBuilder: (context, imageProvider) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image(image: imageProvider),
                );
              },
            ),
          ),
          Text(
            teacher.description,
            style: Get.textTheme.headlineLarge,
          ),
          for (int i = 0; i < teacher.categories.length; i++)
            Text(
              teacher.categories[i],
              style: Get.textTheme.headlineSmall,
            )
        ],
      ),
    );
  }
}
