import 'package:deal_bridge_app/app/modules/home/views/widghts/platform_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/home_controller.dart';
import 'widghts/product_grid.dart';
import 'widghts/category_widget.dart';
import 'widghts/banner_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA), // Light modern background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Dealora',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 24,
            color: Color(0xFF1E212D),
            letterSpacing: -0.5,
          ),
        ),
        actions: const [],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 4),
              child: Text(
                'Find Your Best Deals',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E212D),
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4)),
                    ]),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search Deals & Products...',
                    hintStyle: TextStyle(color: Color(0xFFB0B3C6)),
                    prefixIcon: Icon(Icons.search, color: Color(0xFF6B4EFF)),
                    suffixIcon: Tooltip(
                      message: 'Press Enter to search on Amazon',
                      child:
                          Icon(Icons.travel_explore, color: Color(0x806B4EFF)),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  textInputAction: TextInputAction.search,
                  onChanged: (value) => controller.setSearchQuery(value),
                  onSubmitted: (query) async {
                    if (query.trim().isNotEmpty) {
                      const String affiliateTag = 'dealbridge0d-21';
                      final Uri url = Uri.parse(
                          'https://www.amazon.in/s?k=${Uri.encodeComponent(query)}&tag=$affiliateTag');
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.inAppBrowserView,
                        );
                      } else {
                        Get.snackbar('Error', 'Could not open Amazon search');
                      }
                    }
                  },
                ),
              ),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            sliver: SliverToBoxAdapter(
              child: BannerWidget(),
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 16.0, bottom: 24.0),
            sliver: SliverToBoxAdapter(
              child: CategoryWidget(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: Obx(() {
              if (controller.isLoading.value) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF6B4EFF)),
                    ),
                  ),
                );
              }
              if (controller.filteredProducts.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text(
                        'No products found matching your criteria.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                );
              }
              return ProductGrid(products: controller.filteredProducts);
            }),
          ),
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(16, 32, 16, 12),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Explore Top Platforms',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E212D),
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
            sliver: SliverToBoxAdapter(child: PlatformGrid()),
          ),
        ],
      ),
    );
  }
}
