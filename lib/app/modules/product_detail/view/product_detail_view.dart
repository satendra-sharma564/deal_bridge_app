import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/product_model.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProductDetailController());
    final ProductModel product = Get.arguments;

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[200],
              child: CachedNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.cover,
                errorWidget: (context, url, err) => const Icon(Icons.image, size: 100),
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('\$${product.price}', style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Chip(label: Text(product.category)),
                  const SizedBox(height: 16),
                  const Text('Product Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('This is a great product that you will love. Perfect for any occasion and worth every penny.')
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: () => Get.rawSnackbar(message: 'Added to cart!'),
          child: const Text('Add to Cart', style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
      ),
    );
  }
}
