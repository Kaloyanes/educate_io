import 'package:cached_network_image/cached_network_image.dart';
import 'package:educate_io/app/modules/details/views/details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:educate_io/app/models/teacher_model.dart';

class TeacherCard extends StatelessWidget {
  const TeacherCard({Key? key, required this.teacher}) : super(key: key);

  final Teacher teacher;

  void goToDetails() {
    Get.to(() => DetailsView(teacher), curve: Curves.easeInOutExpo);
  }

  @override
  Widget build(BuildContext context) {
    if (teacher.photoUrl == "") {
      return Container();
    }

    return GestureDetector(
      onTap: () => goToDetails(),
      child: Padding(
        // padding: EdgeInsets.zero,
        padding: const EdgeInsets.only(bottom: 10.0, left: 5, right: 5),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              SizedBox(
                // height: 200,
                child: Hero(
                  tag: teacher,
                  child: CachedNetworkImage(
                    imageUrl: teacher.photoUrl,
                    imageBuilder: (context, imageProvider) => ClipRRect(
                      borderRadius: const BorderRadius.vertical(
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
                      height: 180,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: progress.progress,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => const SizedBox(
                      height: 200,
                      width: 200,
                      child: Icon(
                        Icons.question_mark,
                        size: 60,
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
                style: Theme.of(Get.context!)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 20),
              ),
              Text(
                teacher.subjects[0],
                style: Get.textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
