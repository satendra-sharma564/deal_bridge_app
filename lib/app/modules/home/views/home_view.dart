import 'package:deal_bridge_app/app/modules/admin/controllers/admin_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/home_controller.dart';
import 'widghts/product_grid.dart';
import 'widghts/category_widget.dart';
import 'widghts/banner_widget.dart';
import 'widghts/platform_grid.dart';

const String _amazonAffTag = 'dealbridge0d-21';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
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
                      message: 'Search products',
                      child:
                          Icon(Icons.travel_explore, color: Color(0x806B4EFF)),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  textInputAction: TextInputAction.search,
                  onChanged: (value) => controller.setSearchQuery(value),
                  onSubmitted: (query) {
                    controller.setSearchQuery(query);
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
            padding: EdgeInsets.only(top: 16.0, bottom: 12.0),
            sliver: SliverToBoxAdapter(
              child: CategoryWidget(),
            ),
          ),
          SliverToBoxAdapter(
            child: _PlatformCategorySection(),
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
                return SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 32, horizontal: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off_rounded,
                            size: 52, color: Color(0xFFB0B3C6)),
                        const SizedBox(height: 12),
                        const Text(
                          'Koi product nahi mila',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E212D)),
                        ),
                        if (controller.searchQuery.value.trim().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              '"${controller.searchQuery.value.trim()}" – yahan dhundho:',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // ── Amazon Affiliate Button (direct search with aff tag) ──
                          Material(
                            color: const Color(0xFFFFF8EC),
                            borderRadius: BorderRadius.circular(16),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () async {
                                final q = Uri.encodeComponent(
                                    controller.searchQuery.value.trim());
                                final Uri uri = Uri.parse(
                                    'https://www.amazon.in/s?k=$q&tag=$_amazonAffTag');
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri,
                                      mode: LaunchMode.inAppWebView);
                                } else {
                                  Get.snackbar(
                                      'Error', 'Amazon open nahi ho saka');
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              'https://logo.clearbit.com/amazon.in',
                                          fit: BoxFit.contain,
                                          errorWidget: (_, __, ___) =>
                                              const Icon(
                                                  Icons.shopping_cart_outlined,
                                                  color: Color(0xFFFD9000)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                'Amazon',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 15,
                                                  color: Color(0xFF1E212D),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFFD9000),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Text(
                                                  '🏷️ Affiliate',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          const Text(
                                            'Amazon par search karein',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFD9000),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.arrow_forward_ios,
                                          size: 12, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // ── Other platforms — EarnKaro affiliate links use karo ──
                          Builder(
                            builder: (context) {
                              const allowedPlatforms = {
                                'flipkart',
                                'myntra',
                                'ajio',
                                'reliance digital',
                              };
                              final adminCtrl = Get.put(AdminController());
                              final matchedNames =
                                  controller.getPlatformNamesForQuery(
                                      controller.searchQuery.value);
                              return Obx(() {
                                if (adminCtrl.platformList.isEmpty) {
                                  return const SizedBox();
                                }
                                final bool hasDbMatch = matchedNames.isNotEmpty;
                                final matchedNamesLower = matchedNames
                                    .map((n) => n.toLowerCase())
                                    .toSet();

                                final platformsToShow =
                                    adminCtrl.platformList.where((p) {
                                  final pLower = p.name.toLowerCase();
                                  final inWhitelist = allowedPlatforms.any(
                                      (a) =>
                                          pLower.contains(a) ||
                                          a.contains(pLower));
                                  if (!inWhitelist) return false;
                                  if (!hasDbMatch) return true;
                                  return matchedNamesLower.any((mn) =>
                                      mn.contains(pLower) ||
                                      pLower.contains(mn));
                                }).toList();

                                if (platformsToShow.isEmpty) {
                                  return const SizedBox();
                                }

                                // Platform accent colors
                                Color accentFor(String name) {
                                  final n = name.toLowerCase();
                                  if (n.contains('flipkart')) {
                                    return const Color(0xFF2874F0);
                                  } else if (n.contains('myntra')) {
                                    return const Color(0xFFFF3F6C);
                                  } else if (n.contains('ajio')) {
                                    return const Color(0xFF1A1A1A);
                                  } else if (n.contains('reliance')) {
                                    return const Color(0xFF0078D7);
                                  }
                                  return const Color(0xFF6B4EFF);
                                }

                                Color bgFor(String name) {
                                  final n = name.toLowerCase();
                                  if (n.contains('flipkart')) {
                                    return const Color(0xFFEAF2FF);
                                  } else if (n.contains('myntra')) {
                                    return const Color(0xFFFFECF1);
                                  } else if (n.contains('ajio')) {
                                    return const Color(0xFFF2F2F2);
                                  } else if (n.contains('reliance')) {
                                    return const Color(0xFFE6F3FF);
                                  }
                                  return const Color(0xFFF0EDFF);
                                }

                                String logoFor(String name) {
                                  final n = name.toLowerCase();
                                  if (n.contains('flipkart')) {
                                    return 'https://logo.clearbit.com/flipkart.com';
                                  } else if (n.contains('myntra')) {
                                    return 'https://logo.clearbit.com/myntra.com';
                                  } else if (n.contains('ajio')) {
                                    return 'https://logo.clearbit.com/ajio.com';
                                  } else if (n.contains('reliance')) {
                                    return 'https://logo.clearbit.com/reliancedigital.in';
                                  }
                                  return 'https://logo.clearbit.com/${name.toLowerCase().replaceAll(' ', '')}.com';
                                }

                                return Column(
                                  children: platformsToShow.map((platform) {
                                    final accent = accentFor(platform.name);
                                    final bg = bgFor(platform.name);
                                    final logo = logoFor(platform.name);
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Material(
                                        color: bg,
                                        borderRadius: BorderRadius.circular(16),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          onTap: () async {
                                            final Uri url =
                                                Uri.parse(platform.link);
                                            if (await canLaunchUrl(url)) {
                                              await launchUrl(url,
                                                  mode:
                                                      LaunchMode.inAppWebView);
                                            } else {
                                              Get.snackbar('Error',
                                                  'Could not open platform');
                                            }
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 14),
                                            child: Row(
                                              children: [
                                                // Platform logo
                                                Container(
                                                  width: 44,
                                                  height: 44,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    child: CachedNetworkImage(
                                                      imageUrl: logo,
                                                      fit: BoxFit.contain,
                                                      errorWidget:
                                                          (_, __, ___) => Icon(
                                                              Icons
                                                                  .shopping_bag_outlined,
                                                              color: accent),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 14),
                                                // Name + badge + subtitle
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            platform.name,
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 15,
                                                              color: Color(
                                                                  0xFF1E212D),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 8),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        2),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: accent,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                            ),
                                                            // child: const Text(
                                                            //   '🔗 EarnKaro',
                                                            //   style:
                                                            //       TextStyle(
                                                            //     color: Colors
                                                            //         .white,
                                                            //     fontSize: 10,
                                                            //     fontWeight:
                                                            //         FontWeight
                                                            //             .w700,
                                                            //   ),
                                                            // ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 2),
                                                      Text(
                                                        hasDbMatch
                                                            ? '${platform.name} par milega'
                                                            : '${platform.name} par search karein',
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.grey),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Arrow button
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: accent,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 12,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              });
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              } // Added missing closing brace
              final fullList = controller.filteredProducts;
              final displayList = !controller.isProductsExpanded.value &&
                      fullList.length > 8
                  ? fullList.take(8).toList()
                  : fullList;
              return ProductGrid(products: displayList);
            }),
          ),
          SliverToBoxAdapter(
            child: Obx(() {
              final fullList = controller.filteredProducts;
              if (!controller.isProductsExpanded.value && fullList.length > 8) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.isProductsExpanded.value = true;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF6B4EFF),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(
                              color: Color(0xFF6B4EFF), width: 1.2),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("View All Products (${fullList.length})",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          const Icon(Icons.keyboard_arrow_down_rounded,
                              size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
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

// ─────────────────────────────────────────────────────────────
// Platform Category Section — richly designed, interesing UI
// ─────────────────────────────────────────────────────────────
class _PlatformCategorySection extends StatefulWidget {
  @override
  State<_PlatformCategorySection> createState() =>
      _PlatformCategorySectionState();
}

class _PlatformCategorySectionState extends State<_PlatformCategorySection> {
  String _selectedCategory = 'All';

  // Category icons map
  static const Map<String, String> _catEmoji = {
    'All': '🌐',
    'Fashion': '👗',
    'Electronics': '💻',
    'Grocery': '🛒',
    'Beauty': '💄',
    'Sports': '⚽',
    'Home & Kitchen': '🏠',
    'General': '🏪',
  };

  // Per-platform accent color fallback
  Color _accentFor(String name) {
    final n = name.toLowerCase();
    if (n.contains('amazon')) return const Color(0xFFFD9000);
    if (n.contains('flipkart')) return const Color(0xFF2874F0);
    if (n.contains('myntra')) return const Color(0xFFFF3F6C);
    if (n.contains('ajio')) return const Color(0xFF1A1A1A);
    if (n.contains('reliance')) return const Color(0xFF0078D7);
    if (n.contains('meesho')) return const Color(0xFFE91E8C);
    return const Color(0xFF6B4EFF);
  }

  String _logoFor(String name) {
    final n = name.toLowerCase();
    if (n.contains('amazon')) return 'https://logo.clearbit.com/amazon.in';
    if (n.contains('flipkart')) return 'https://logo.clearbit.com/flipkart.com';
    if (n.contains('myntra')) return 'https://logo.clearbit.com/myntra.com';
    if (n.contains('ajio')) return 'https://logo.clearbit.com/ajio.com';
    if (n.contains('reliance')) {
      return 'https://logo.clearbit.com/reliancedigital.in';
    }
    if (n.contains('meesho')) return 'https://logo.clearbit.com/meesho.com';
    return 'https://logo.clearbit.com/${n.replaceAll(' ', '')}.com';
  }

  @override
  Widget build(BuildContext context) {
    final adminCtrl = Get.put(AdminController());
    return Obx(() {
      final platforms = adminCtrl.platformList;
      if (platforms.isEmpty) return const SizedBox();

      // Unique categories from data
      final categories = <String>['All'];
      for (final p in platforms) {
        if (!categories.contains(p.category)) {
          categories.add(p.category);
        }
      }

      // Filtered list
      final filtered = _selectedCategory == 'All'
          ? platforms
          : platforms.where((p) => p.category == _selectedCategory).toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header & Dropdown ──────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Platforms',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E212D),
                    letterSpacing: -0.5,
                  ),
                ),
                Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF6B4EFF).withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      icon: const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(Icons.keyboard_arrow_down_rounded,
                            size: 20, color: Color(0xFF6B4EFF)),
                      ),
                      elevation: 4,
                      borderRadius: BorderRadius.circular(16),
                      style: const TextStyle(
                        color: Color(0xFF6B4EFF),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      dropdownColor: Colors.white,
                      items: categories.map((cat) {
                        final emoji = _catEmoji[cat] ?? '🏪';
                        return DropdownMenuItem(
                          value: cat,
                          child: Text('$emoji  $cat'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedCategory = val);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ── Horizontal platform cards ─────────────────
          SizedBox(
            height: 130,
            child: filtered.isEmpty
                ? const Center(
                    child: Text('No platforms in this category',
                        style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final p = filtered[i];
                      final accent = _accentFor(p.name);
                      final logo = p.logo.isNotEmpty &&
                              !p.logo.contains('placeholder')
                          ? p.logo
                          : _logoFor(p.name);
                      return GestureDetector(
                        onTap: () async {
                          final uri = Uri.parse(p.link);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri,
                                mode: LaunchMode.inAppWebView);
                          }
                        },
                        child: Container(
                          width: 110,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: accent.withOpacity(0.12),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Logo circle with gradient ring
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      accent.withOpacity(0.15),
                                      accent.withOpacity(0.05),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: accent.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: logo,
                                    fit: BoxFit.contain,
                                    errorWidget: (_, __, ___) => Icon(
                                        Icons.store_rounded,
                                        color: accent,
                                        size: 28),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Name
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  p.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1E212D),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Category badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: accent.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  p.category,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 32),
        ],
      );
    });
  }
}
