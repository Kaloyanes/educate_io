import 'package:cached_network_image/cached_network_image.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/home/views/details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeachCard extends StatelessWidget {
  const TeachCard({Key? key, required this.teacher}) : super(key: key);

  final Teacher teacher;

  void GoToDetails() {
    Get.to(
      DetailsView(teacher),
      fullscreenDialog: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GoToDetails(),
      // onLongPress: () => ShowBottomSheet(),
      child: SizedBox(
        width: 250,
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline,
              )),
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Hero(
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
      ),
    );
  }
}
