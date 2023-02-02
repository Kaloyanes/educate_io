import 'package:educate_io/app/services/get_storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Тема",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          Divider(thickness: 2, color: Theme.of(context).colorScheme.primary),
          ListTile(
            leading: Icon(Theme.of(context).brightness == Brightness.dark
                ? Icons.dark_mode
                : Icons.light_mode),
            // title: const Text("Тъмен Режим"),
            title: Obx(() {
              var themeString = controller.themeVal.value ?? "Системен";

              switch (themeString) {
                case "light":
                  themeString = "Бял";
                  break;

                case "dark":
                  themeString = "Тъмен";
                  break;

                case "system":
                  themeString = "Системен";
                  break;
              }

              return Text("$themeString режим");
            }),
            onTap: () => controller.changeTheme(),
          ),
          ListTile(
            title: Text("Цвят на темата"),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            onTap: () => controller.changeColor(),
          ),
          Text(
            "Данни",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
          Divider(thickness: 2, color: Theme.of(context).colorScheme.primary),
          Text(
            "Как да бъдат показани учителите на началната страница?",
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          Obx(
            () => Column(
              children: [
                RadioListTile(
                  value: false,
                  groupValue: controller.isGrid.value,
                  onChanged: (value) => controller.changeList(value!),
                  title: Text("Списък"),
                ),
                RadioListTile(
                  value: true,
                  groupValue: controller.isGrid.value,
                  onChanged: (value) => controller.changeList(value!),
                  title: Text("Решетка"),
                ),
              ],
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     const Icon(
          //       Icons.list_rounded,
          //       size: 30,
          //     ),
          //     Obx(
          //       () => Switch(
          //         value: controller.isGrid.value!,
          //         onChanged: (val) => controller.changeList(val),
          //       ),
          //     ),
          //     const Icon(
          //       Icons.grid_4x4_rounded,
          //       size: 30,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
