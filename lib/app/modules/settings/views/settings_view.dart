import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
            title: const Text("Цвят на темата"),
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
          Obx(
            () => Column(
              children: [
                const Text(
                  "Как да бъдат показани менторите на началната страница?",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                RadioListTile(
                  value: false,
                  groupValue: controller.isGrid.value,
                  onChanged: (value) => controller.changeList(value!),
                  title: const Text("Списък"),
                ),
                RadioListTile(
                  value: true,
                  groupValue: controller.isGrid.value,
                  onChanged: (value) => controller.changeList(value!),
                  title: const Text("Решетка"),
                ),
              ],
            ),
          ),
          Obx(
            () => Column(
              children: [
                const Text(
                  "Колко на брой менторя да виждаш на 1 ред?",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                DropdownButton(
                  enableFeedback: true,
                  value: controller.gridTeacherCount.value,
                  items: const [
                    DropdownMenuItem<int>(
                      value: 2,
                      child: Text("2"),
                    ),
                    DropdownMenuItem<int>(
                      value: 3,
                      child: Text("3"),
                    ),
                  ],
                  onChanged: (value) =>
                      controller.changeGridTeacher(value ?? 2),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
