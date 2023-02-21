import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhotoPickerSheet extends StatelessWidget {
  const PhotoPickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(0),
        ),
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
      ),
      child: SafeArea(
        bottom: true,
        top: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 5,
                width: Get.size.width / 3,
                decoration: BoxDecoration(
                  color: Theme.of(Get.context!).dividerColor,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Снимай с камера"),
                onTap: () async => Get.back(result: "camera"),
                tileColor: Colors.transparent,
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Избери снимка от галерията"),
                onTap: () => Get.back(result: "gallery"),
                tileColor: Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
