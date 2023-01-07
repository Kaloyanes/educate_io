import 'package:educate_io/app/modules/home/components/drawer/content/anon_content.dart';
import 'package:educate_io/app/modules/home/components/drawer/content/user_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerComponent extends StatefulWidget {
  const DrawerComponent({
    super.key,
  });

  @override
  State<DrawerComponent> createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  late Stream<User?> authStream;

  @override
  void initState() {
    authStream = FirebaseAuth.instance.authStateChanges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: -1,
      children: [
        SizedBox(
          height: Get.mediaQuery.padding.top + 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            "EducateIO",
            style: TextStyle(
              fontSize: 30,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        // Content

        Expanded(
          child: StreamBuilder(
            stream: authStream,
            initialData: FirebaseAuth.instance.currentUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasData) {
                return const UserContent();
              } else {
                return const AnonContent();
              }
            },
          ),
        ),
        SizedBox(
          height: Get.mediaQuery.padding.bottom,
        ),
      ],
    );
  }
}
