import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/admin_controller.dart';
import 'add_product_view.dart';

class AdminDashboardView extends GetView<AdminController> {
  const AdminDashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.to(const AddProductView()),
          )
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              color: Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Total Products', style: TextStyle(color: Colors.white, fontSize: 16)),
                        Text('${controller.productList.length}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Total Clicks', style: TextStyle(color: Colors.white, fontSize: 16)),
                        Text('${controller.totalClicks}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Product List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...controller.productList.map((p) => ListTile(
              leading: SizedBox(
                width: 50,
                child: CachedNetworkImage(
                  imageUrl: p.image, 
                  fit: BoxFit.cover,
                  errorWidget: (context, url, err) => const Icon(Icons.image),
                )
              ),
              title: Text(p.title, maxLines: 1),
              subtitle: Text('\$${p.price} | ${p.category}'),
              trailing: Chip(label: Text('Clicks: ${p.clicks}')),
            )).toList(),
          ],
        );
      }),
    );
  }
}
