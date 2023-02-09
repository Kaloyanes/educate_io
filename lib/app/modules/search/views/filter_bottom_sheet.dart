import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues value = const RangeValues(0, 5);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Звезди",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            RangeSlider(
              min: 0,
              max: 5,
              divisions: 5,
              values: value,
              labels: RangeLabels(value.start.toString(), value.end.toString()),
              onChanged: (value) => setState(() {
                this.value = value;
              }),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => Get.back(result: value),
              child: const Text("Филтрирай"),
            ),
          ],
        ),
      ),
    );
  }
}
