import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educate_io/app/routes/app_pages.dart';
import 'package:educate_io/app/services/database/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({
    super.key,
  });

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  var authStream = const Stream.empty();

  @override
  void initState() {
    authStream = FirebaseAuth.instance.authStateChanges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: FirebaseAuth.instance.currentUser,
      stream: authStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.hasError) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData) {
          return IconButton(
            onPressed: () => Get.toNamed(Routes.LOGIN),
            icon: const Icon(Icons.person),
          );
        }

        return FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(snapshot.data?.uid ?? "")
              .get(),
          builder: (context, snapshot) => FutureBuilder(
            future: FirestoreProfileService.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData ||
                  snapshot.hasError) {
                return const CircularProgressIndicator();
              }

              var data = snapshot.data;

              Widget child = CircleAvatar(
                child: Text(data!["initials"] ?? ""),
              );

              if (data["photoUrl"]?.isNotEmpty ?? false) {
                child = CircleAvatar(
                  foregroundImage:
                      CachedNetworkImageProvider(data["photoUrl"] ?? ""),
                );
              }

              return child;
            },
          ),
        );
      },
    );
  }
}
