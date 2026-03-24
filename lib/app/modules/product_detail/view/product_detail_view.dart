import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:deal_bridge_app/app/data/models/product_model.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailView extends StatelessWidget {
  const ProductDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProductDetailController());
    final ProductModel? product = Get.arguments;

    if (product == null) {
      Future.microtask(() => Get.offAllNamed('/'));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[100],
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Get.back(),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 350,
              width: double.infinity,
              color: Colors.grey[50], // Very light grey background for image
              child: CachedNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.contain,
                errorWidget: (context, url, err) => const Icon(Icons.image, size: 100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EDFF), // light purple bg
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.category,
                      style: const TextStyle(fontSize: 14, color: Color(0xFF6B4EFF), fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.title,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF1E212D)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${product.price.toInt()}',
                    style: const TextStyle(fontSize: 28, color: Color(0xFF6B4EFF), fontWeight: FontWeight.w900, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Product Details',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E212D)),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description ?? 'This is a great product that you will love. Perfect for any occasion and worth every penny.',
                    style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.5),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24, top: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SizedBox(
          height: 60,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFD9000), // Amazon orange
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 24),
            label: const Text(
              'Buy on Amazon',
              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              final linkStr = product.affiliateLink ?? product.link;
              if (linkStr != null && linkStr.isNotEmpty) {
                final Uri linkUri = Uri.parse(linkStr);
                if (!await launchUrl(linkUri, mode: LaunchMode.externalApplication)) {
                  Get.rawSnackbar(message: 'Could not launch Amazon Link');
                }
              } else {
                final String query = Uri.encodeComponent(product.title);
                final Uri amazonUri = Uri.parse('https://www.amazon.in/s?k=$query&tag=dealbridge0d-21');
                if (!await launchUrl(amazonUri, mode: LaunchMode.externalApplication)) {
                  Get.rawSnackbar(message: 'Could not launch Amazon');
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
