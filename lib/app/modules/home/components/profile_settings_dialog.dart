import 'package:educate_io/app/routes/app_pages.dart';
import 'package:educate_io/app/services/auth/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSettingsDialog extends StatelessWidget {
  const ProfileSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              fit: StackFit.passthrough,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.person,
                    size: 40,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Настройки на профила",
              style: context.textTheme.titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton.icon(
              label: const Text("Настройки на профила"),
              icon: const Icon(Icons.settings),
              onPressed: () => Get.toNamed(
                Routes.PROFILE_SETTINGS,
                preventDuplicates: false,
              ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text("Излез от профила"),
              onPressed: () {
                FirebaseAuthService.logOut();
                Get.back();
              },
            )
          ],
        ),
      ),
    );
  }
}
