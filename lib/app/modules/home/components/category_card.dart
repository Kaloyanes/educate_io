import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  CategoryCard({Key? key, required this.category, required this.value})
      : super(key: key);

  final String category;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(category, style: Theme.of(context).textTheme.titleLarge),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
                child:
                    Text(value, style: Theme.of(context).textTheme.bodyLarge)),
          ),
        ],
      ),
    );
  }
}
