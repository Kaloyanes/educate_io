import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Teacher {
  String email;
  String name;
  String phone;
  String photoUrl;
  String role;
  DateTime birthDay;
  List<String> subjects;
  Teacher({
    required this.email,
    required this.name,
    required this.phone,
    required this.photoUrl,
    required this.role,
    required this.birthDay,
    required this.subjects,
  });

  Teacher copyWith({
    String? email,
    String? name,
    String? phone,
    String? photoUrl,
    String? role,
    DateTime? birthDay,
    List<String>? subjects,
  }) {
    return Teacher(
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      birthDay: birthDay ?? this.birthDay,
      subjects: subjects ?? this.subjects,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'phone': phone,
      'photoUrl': photoUrl,
      'role': role,
      'birthDay': birthDay.millisecondsSinceEpoch,
      'subjects': subjects,
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      email: map['email'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
      photoUrl: map['photoUrl'] as String,
      role: map['role'] as String,
      birthDay: (map['birthDay'] as Timestamp).toDate(),
      subjects: List.castFrom(map["subjects"]),
      // subjects: ["Програмиране"],
    );
  }

  String toJson() => json.encode(toMap());

  factory Teacher.fromJson(String source) =>
      Teacher.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Teacher(email: $email, name: $name, phone: $phone, photoUrl: $photoUrl, role: $role, birthDay: $birthDay, subjects: $subjects)';
  }

  @override
  bool operator ==(covariant Teacher other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.name == name &&
        other.phone == phone &&
        other.photoUrl == photoUrl &&
        other.role == role &&
        other.birthDay == birthDay &&
        listEquals(other.subjects, subjects);
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        photoUrl.hashCode ^
        role.hashCode ^
        birthDay.hashCode ^
        subjects.hashCode;
  }
}
