import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingFiltersBottomSheet extends StatefulWidget {
  const RatingFiltersBottomSheet({super.key});

  @override
  State<RatingFiltersBottomSheet> createState() =>
      _RatingFiltersBottomSheetState();
}

class _RatingFiltersBottomSheetState extends State<RatingFiltersBottomSheet> {
  var selectedRange = const RangeValues(0, 5);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Text(
              "Звезди",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            RangeSlider(
              onChanged: (value) => setState(() {
                selectedRange = value;
              }),
              values: selectedRange,
              min: 0,
              max: 5,
              divisions: 5,
              labels:
                  RangeLabels("${selectedRange.start}", "${selectedRange.end}"),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () => Get.back(
                result: {
                  "startStars": selectedRange.start,
                  "endStars": selectedRange.end,
                },
              ),
              icon: const Icon(Icons.save),
              label: const Text("Запази филтрите"),
            )
          ],
        ),
      ),
    );
  }
}
