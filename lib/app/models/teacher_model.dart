// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Teacher {
  String? uid;
  String email;
  String name;
  String? phone;
  String photoUrl;
  String role;
  DateTime birthDay;
  List<String> subjects;
  List<String>? badSubjects;
  Teacher({
    this.uid,
    required this.email,
    required this.name,
    this.phone,
    required this.photoUrl,
    required this.role,
    required this.birthDay,
    required this.subjects,
    this.badSubjects,
  });

  Teacher copyWith({
    String? uid,
    String? email,
    String? name,
    String? phone,
    String? photoUrl,
    String? role,
    DateTime? birthDay,
    List<String>? subjects,
    List<String>? badSubjects,
  }) {
    return Teacher(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      birthDay: birthDay ?? this.birthDay,
      subjects: subjects ?? this.subjects,
      badSubjects: badSubjects ?? this.badSubjects,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'photoUrl': photoUrl,
      'role': role,
      'birthDay': birthDay.millisecondsSinceEpoch,
      'subjects': subjects,
      'badSubjects': badSubjects,
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      uid: map['uid'] != null ? map['uid'] as String : null,
      email: map['email'] as String,
      name: map['name'] as String,
      phone: map['phone'] != null ? map['phone'] as String : null,
      photoUrl: map['photoUrl'] as String,
      role: map['role'] as String,
      birthDay: DateTime.fromMillisecondsSinceEpoch(
          (map['birthDay'] as Timestamp).millisecondsSinceEpoch),
      subjects: List.castFrom(map["subjects"] as List),
      badSubjects: map["badSubjects"] != null
          ? List.castFrom(map["badSubjects"] as List)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Teacher.fromJson(String source) =>
      Teacher.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Teacher(uid: $uid, email: $email, name: $name, phone: $phone, photoUrl: $photoUrl, role: $role, birthDay: $birthDay, subjects: $subjects, badSubjects: $badSubjects)';
  }

  @override
  bool operator ==(covariant Teacher other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.email == email &&
        other.name == name &&
        other.phone == phone &&
        other.photoUrl == photoUrl &&
        other.role == role &&
        other.birthDay == birthDay &&
        listEquals(other.subjects, subjects) &&
        listEquals(other.badSubjects, badSubjects);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        email.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        photoUrl.hashCode ^
        role.hashCode ^
        birthDay.hashCode ^
        subjects.hashCode ^
        badSubjects.hashCode;
  }
}
