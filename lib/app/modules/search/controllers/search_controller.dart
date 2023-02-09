import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/models/teacher_model.dart';
import 'package:educate_io/app/modules/search/views/filter_bottom_sheet.dart';
import 'package:educate_io/app/services/get_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final notFilteredTeachers = <Teacher>[];
  final teachers = <Teacher>[].obs;

  final gridTeacherCount =
      (GetStorageService().read<int>("teacherGridCount") ?? 2).obs;

  @override
  void onInit() {
    getTeachers();
    super.onInit();
  }

  Future filter() async {
    var results = await showModalBottomSheet<RangeValues>(
      context: Get.context!,
      builder: (context) => const FilterBottomSheet(),
    );

    if (results == null) return;

    if (results.start == 0 && results.end == 5) {
      teachers.value = notFilteredTeachers;
      return;
    }

    inspect(results);

    var teachersFiltered = <Teacher>[];

    for (var teacher in notFilteredTeachers) {
      var docDir = FirebaseFirestore.instance
          .collection('users')
          .doc(teacher.uid)
          .collection("reviews");

      inspect(teacher);

      var docsSnapshot = await docDir.get();

      var rating = 0.0;
      for (var doc in docsSnapshot.docs) {
        rating += doc.get("rating");
      }

      if (rating == 0) continue;
      rating /= docsSnapshot.docs.length;

      if (rating >= results.start && rating <= results.end) {
        teachersFiltered.add(teacher);
      }
    }

    inspect(teachersFiltered);
    teachers.value = teachersFiltered;
  }

  Future getTeachers() async {
    var docs = await FirebaseFirestore.instance
        .collection("users")
        .where("showProfile", isEqualTo: true)
        .where("photoUrl", isNotEqualTo: "")
        .get();

    inspect(docs);

    for (var doc in docs.docs) {
      var data = doc.data();

      data.addAll({"uid": doc.id});
      var teacher = Teacher.fromMap(data);
      teachers.add(teacher);
      notFilteredTeachers.add(teacher);
    }
  }

  void filterResults(String value) {
    if (value.isEmpty) teachers.value = notFilteredTeachers;

    teachers.value = teachers.where((element) {
      return element.name.contains(value) ||
          hasThisSubject(element.subjects, value) ||
          hasThisSubject(element.badSubjects ?? [], value) ||
          (element.phone?.contains(value) ?? false) ||
          (element.role == "student" && value.toLowerCase() == "ученик") ||
          (element.role == "teacher" && value.toLowerCase() == "ментор");
    }).toList();
  }

  bool hasThisSubject(List<String> subjects, String search) {
    for (var subject in subjects) {
      if (subject.toLowerCase().contains(search.toLowerCase())) return true;
    }

    return false;
  }
}
