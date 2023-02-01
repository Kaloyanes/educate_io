import 'package:educate_io/app/modules/home/components/drawer/drawer_destination.dart';
import 'package:educate_io/app/routes/app_pages.dart';
import 'package:educate_io/app/services/auth/firebase_auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserContent extends StatelessWidget {
  const UserContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DrawerDestination(
            icon: CupertinoIcons.heart_fill,
            label: "Запазени учители",
            onTap: () => Get.toNamed(Routes.LIKED_TEACHERS),
          ),
          DrawerDestination(
            icon: Icons.chat_rounded,
            label: "Чатове",
            onTap: () => Get.toNamed(Routes.CHATS),
          ),
          DrawerDestination(
            icon: Icons.person_pin_circle,
            label: "Учители на близо",
            onTap: () => Get.toNamed(Routes.TEACHERS_NEARBY),
          ),
          const Spacer(),
          DrawerDestination(
            icon: Icons.person,
            label: "Настройки на профила",
            onTap: () => Get.toNamed(Routes.PROFILE_SETTINGS),
          ),
          const SizedBox(height: 10),
          DrawerDestination(
            icon: Icons.settings,
            label: "Настройки",
            onTap: () => Get.toNamed(Routes.SETTINGS),
          ),
          const SizedBox(height: 10),
          DrawerDestination(
            icon: Icons.logout,
            label: "Излез от профила",
            onTap: () {
              FirebaseAuthService.logOut();
            },
          ),
        ],
      ),
    );
  }
}
