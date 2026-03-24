import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../data/models/product_model.dart';
import '../../product_detail/view/product_detail_view.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductModel> products;
  const ProductGrid({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = products[index];
          return GestureDetector(
            onTap: () {
              Get.toNamed('/product-detail', arguments: product);
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CachedNetworkImage(
                        imageUrl: product.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorWidget: (context, url, err) => const Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('\$${product.price}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
        childCount: products.length,
      ),
    );
  }
}
