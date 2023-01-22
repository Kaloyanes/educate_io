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
    super.initState();
    authStream = FirebaseAuth.instance.authStateChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width > 600
          ? MediaQuery.of(context).size.width / 2
          : MediaQuery.of(context).size.width / 1.4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(50),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: Get.mediaQuery.padding.top + 20,
          ),
          Text(
            "EducateIO",
            style: TextStyle(
              fontSize: 30,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),

          // Content
          StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasData) {
                return const UserContent();
              }

              return const AnonContent();
            },
          ),
          SizedBox(
            height: Get.mediaQuery.padding.bottom,
          ),
        ],
      ),
    );
  }
}
