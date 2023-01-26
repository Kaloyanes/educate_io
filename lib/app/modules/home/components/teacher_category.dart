import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/home/components/teacher_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TeacherSubject extends StatefulWidget {
  const TeacherSubject({
    super.key,
    required this.subject,
  });

  final String subject;

  @override
  State<TeacherSubject> createState() => _TeacherSubjectState();
}

class _TeacherSubjectState extends State<TeacherSubject> {
  Future<List<Teacher>> getTeachers() async {
    var teachers = <Teacher>[];

    var teachersQuery = await FirebaseFirestore.instance
        .collection("users")
        .where("subjects", arrayContains: widget.subject)
        .where("photoUrl", isNull: false)
        .get();

    for (var element in teachersQuery.docs) {
      var data = element.data();
      data.addAll({"uid": element.id});
      var teacher = Teacher.fromMap(data);

      teachers.add(teacher);
    }
    return teachers;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            child: Text(
              widget.subject,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("users")
              .where("subjects", arrayContains: widget.subject)
              .where("photoUrl", isNull: false)
              .where("showProfile", isEqualTo: true)
              .limit(10)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var list = snapshot.data!.docs;

            if (list.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                    child: Text(
                  "Няма учители или ученици по " + widget.subject,
                  style: Theme.of(context).textTheme.titleMedium,
                )),
              );
            }

            return SizedBox(
              height: 330,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  var data = list.elementAt(index).data();
                  data.addAll({"uid": list.elementAt(index).id});

                  return TeacherCard(
                    subject: widget.subject,
                    teacher: Teacher.fromMap(data),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
