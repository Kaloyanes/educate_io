import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Teacher {
  final String imgUrl;
  final String name;
  final int age;
  final String description;
  final String role;
  final String phoneNumber;
  final List<String> categories;

  Teacher({
    required this.imgUrl,
    required this.name,
    required this.age,
    required this.description,
    required this.role,
    required this.phoneNumber,
    required this.categories,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imgUrl': imgUrl,
      'name': name,
      'age': age,
      'description': description,
      'role': role,
      'phoneNumber': phoneNumber,
      'categories': categories,
    };
  }

  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
        imgUrl: map['imgUrl'] as String,
        name: map['name'] as String,
        age: map['age'] as int,
        description: map['description'] as String,
        role: map['role'] as String,
        phoneNumber: map['phoneNumber'] as String,
        categories: List<String>.from(
          (map['categories'] as List<String>),
        ));
  }

  String toJson() => json.encode(toMap());

  factory Teacher.fromJson(String source) =>
      Teacher.fromMap(json.decode(source) as Map<String, dynamic>);
}
