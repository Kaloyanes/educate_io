import 'package:cached_network_image/cached_network_image.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/details/views/details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeacherCard extends StatelessWidget {
  const TeacherCard({Key? key, required this.teacher, required this.subject})
      : super(key: key);

  final String subject;
  final Teacher teacher;

  void goToDetails() {
    Get.to(
      () => const DetailsView(),
      arguments: {
        "teacher": teacher,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => goToDetails(),
      child: Padding(
        // padding: EdgeInsets.zero,
        padding: const EdgeInsets.only(left: 5, right: 5),

        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              SizedBox(
                width: 190,
                child: Hero(
                  tag: teacher,
                  transitionOnUserGestures: true,
                  placeholderBuilder: (context, heroSize, child) => SizedBox(
                    width: heroSize.width,
                    height: heroSize.height,
                  ),
                  createRectTween: (begin, end) =>
                      MaterialRectCenterArcTween(begin: begin, end: end),
                  child: CachedNetworkImage(
                    imageUrl: teacher.photoUrl ?? "",
                    imageBuilder: (context, imageProvider) => ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Image(
                        fit: BoxFit.fitWidth,
                        image: imageProvider,
                      ),
                    ),
                    progressIndicatorBuilder: (context, url, progress) =>
                        SizedBox(
                      width: 200,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        teacher.name,
                        style: Theme.of(Get.context!)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        subject,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
