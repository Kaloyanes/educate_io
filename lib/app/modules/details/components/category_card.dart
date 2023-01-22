import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({Key? key, required this.category, required this.value})
      : super(key: key);

  final String category;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(category, style: Theme.of(context).textTheme.titleLarge),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: value,
            ),
          ),
        ],
      ),
    );
  }
}
