import 'package:educate_io/app/modules/home/components/drawer/drawer_destination.dart';
import 'package:educate_io/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnonContent extends StatelessWidget {
  const AnonContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DrawerDestination(
            icon: Icons.login,
            label: "Влез",
            onTap: () => Get.toNamed(Routes.LOGIN),
          ),
          const SizedBox(height: 10),
          DrawerDestination(
            icon: Icons.app_registration_rounded,
            label: "Създай акаунт",
            onTap: () => Get.toNamed(Routes.REGISTER),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
