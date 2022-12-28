import 'package:cached_network_image/cached_network_image.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/home/views/details_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/default_transitions.dart';

class TeachCard extends StatelessWidget {
  const TeachCard({Key? key, required this.teacher}) : super(key: key);

  final Teacher teacher;

  void GoToDetails() {
    Get.to(
      () => DetailsView(teacher),
      // duration: Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GoToDetails(),
      child: SizedBox(
        width: 250,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Hero(
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
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  teacher.name,
                  style: Get.textTheme.titleLarge,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  teacher.categories[0],
                  style: Get.textTheme.titleMedium,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
