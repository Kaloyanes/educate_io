import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  //TODO: Implement SearchController

  final notFilteredTeachers = <Teacher>[];
  final teachers = <Teacher>[].obs;

  @override
  void onInit() {
    getTeachers();
    super.onInit();
  }

  Future getTeachers() async {
    var docs = await FirebaseFirestore.instance
        .collection("users")
        .where("showProfile", isEqualTo: true)
        .where("photoUrl", isNotEqualTo: "")
        .get();

    inspect(docs);

    for (var doc in docs.docs) {
      var teacher = Teacher.fromMap(doc.data());
      teachers.add(teacher);
      notFilteredTeachers.add(teacher);
    }
  }

  void filterResults(String value) {
    print(value);
    if (value.isEmpty) teachers.value = notFilteredTeachers;

    teachers.value = teachers.where((element) {
      print(element.phone);
      return element.name.contains(value) ||
          hasThisSubject(element.subjects, value) ||
          hasThisSubject(element.badSubjects ?? [], value) ||
          (element.phone?.contains(value) ?? false) ||
          (element.role == "student" && value.toLowerCase() == "ученик") ||
          (element.role == "teacher" && value.toLowerCase() == "учител");
    }).toList();
  }

  bool hasThisSubject(List<String> subjects, String search) {
    for (var subject in subjects) {
      if (subject.toLowerCase().contains(search.toLowerCase())) return true;
    }

    return false;
  }
}
