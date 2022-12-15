import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/home/views/details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TeachCard extends StatelessWidget {
  const TeachCard({Key? key, required this.teacher}) : super(key: key);

  final Teacher teacher;

  void GoToDetails() {
    Get.to(DetailsView(teacher));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GoToDetails(),
      child: SizedBox(
        width: 250,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      teacher.imgUrl,
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
            ],
          ),
        ),
      ),
    );
  }
}
