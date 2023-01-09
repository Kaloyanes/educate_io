import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterBottomSheet extends StatefulWidget {
  FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet>
    with TickerProviderStateMixin {
  bool _isPlay = false;

  late AnimationController _controller;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomSheetTheme.modalBackgroundColor,
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
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Изтрийте сегашната снимка"),
                onTap: () => Get.back(result: "delete"),
                tileColor: Theme.of(context).colorScheme.tertiaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
