import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/home/views/details_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';
import 'package:path/path.dart';

class TeacherCard extends StatelessWidget {
  const TeacherCard({Key? key, required this.teacher}) : super(key: key);

  final Teacher teacher;

  void goToDetails() {
    Get.to(
      () => DetailsView(teacher),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => goToDetails(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, left: 20, right: 20),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: Hero(
                  tag: teacher.imgUrl,
                  child: CachedNetworkImage(
                    imageUrl: teacher.imgUrl,
                    imageBuilder: (context, imageProvider) => ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Image(
                        fit: BoxFit.fitWidth,
                        width: 200,
                        image: imageProvider,
                      ),
                    ),
                    progressIndicatorBuilder: (context, url, progress) =>
                        SizedBox(
                      width: 200,
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: progress.progress,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                teacher.name,
                style: Get.textTheme.titleLarge,
              ),
              Text(
                teacher.categories[0],
                style: Get.textTheme.titleMedium,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
