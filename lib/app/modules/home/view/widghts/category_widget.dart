import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = ['Electronics', 'Clothing', 'Books', 'Home', 'Toys'];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Chip(
              label: Text(categories[index], style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.blueAccent,
            ),
          );
        },
      ),
    );
  }
}
