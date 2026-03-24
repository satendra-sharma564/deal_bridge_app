import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../admin/views/admin_dashboard.dart';
import 'widghts/product_grid.dart';
import 'widghts/category_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deal Bridge', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: () => Get.toNamed('/admin'),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: CategoryWidget(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: Obx(() {
              if (controller.isLoading.value) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (controller.productList.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No products found.')),
                );
              }
              return ProductGrid(products: controller.productList);
            }),
          ),
        ],
      ),
    );
  }
}
