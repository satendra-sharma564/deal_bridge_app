import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProductView extends StatelessWidget {
  const AddProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(labelText: 'Title')),
            SizedBox(height: 10),
             TextField(decoration: InputDecoration(labelText: 'Price')),
            SizedBox(height: 10),
             TextField(decoration: InputDecoration(labelText: 'Category')),
            SizedBox(height: 10),
             TextField(decoration: InputDecoration(labelText: 'Image URL')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back();
                Get.snackbar('Success', 'Product Added Successfully (Mocked)');
              },
              child: Text('Save Product'),
            )
          ],
        ),
      ),
    );
  }
}
