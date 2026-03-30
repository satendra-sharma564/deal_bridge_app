import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:deal_bridge_app/app/data/models/product_model.dart';

class PlatformBottomSheet extends StatelessWidget {
  final ProductModel product;

  const PlatformBottomSheet({super.key, required this.product});

  static void show(BuildContext context, ProductModel product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PlatformBottomSheet(product: product),
    );
  }

  // ── All supported platforms visual configs ──────────────────
  static final Map<String, Map<String, dynamic>> _platformConfigs = {
    'Amazon': {
      'logo': 'https://logo.clearbit.com/amazon.in',
      'color': const Color(0xFFFFF8EC),
      'badge': '🏷️ Affiliate',
      'hint': 'Product link ready',
    },
    'Flipkart': {
      'logo': 'https://logo.clearbit.com/flipkart.com',
      'color': const Color(0xFFE8F4FF),
      'badge': '🏷️ Affiliate',
    },
    'Myntra': {
      'logo': 'https://logo.clearbit.com/myntra.com',
      'color': const Color(0xFFFFF0F5),
      'badge': '🏷️ Affiliate',
    },
    'Ajio': {
      'logo': 'https://logo.clearbit.com/ajio.com',
      'color': const Color(0xFFF0F0F0),
      'badge': '🏷️ Affiliate',
    },
    'Meesho': {
      'logo': 'https://logo.clearbit.com/meesho.com',
      'color': const Color(0xFFF5F0FF),
      'badge': '🏷️ Affiliate',
    },
    'Reliance Digital': {
      'logo': 'https://logo.clearbit.com/reliancedigital.in',
      'color': const Color(0xFFFFEEEE),
      'badge': '🏷️ Affiliate',
    },
    'Other': {
      'logo':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Check_green_icon.svg/1200px-Check_green_icon.svg.png',
      'color': const Color(0xFFF0F8FF),
      'badge': '🏷️ Affiliate',
    }
  };

  Future<void> _openPlatform(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppWebView);
    } else {
      Get.snackbar('Error', 'Could not open link');
    }
  }

  Widget _buildProductLogo() {
    final img = product.image;
    if (img.startsWith('data:')) {
      try {
        final bytes = base64Decode(img.split(',').last);
        return Image.memory(bytes, fit: BoxFit.contain);
      } catch (_) {
        return const Icon(Icons.image, size: 48, color: Colors.grey);
      }
    }
    return CachedNetworkImage(
      imageUrl: img,
      fit: BoxFit.contain,
      errorWidget: (_, __, ___) =>
          const Icon(Icons.image, size: 48, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag handle ──────────────────────────────
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),

          // ── Product preview ──────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: _buildProductLogo(),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: Color(0xFF1E212D),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${product.price.toInt()}',
                            style: const TextStyle(
                              color: Color(0xFF6B4EFF),
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          if (product.mrp > product.price) ...[
                            const SizedBox(width: 8),
                            Text(
                              '₹${product.mrp.toInt()}',
                              style: const TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${((product.mrp - product.price) / product.mrp * 100).toInt()}% OFF',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade100, thickness: 1.5),
          const SizedBox(height: 4),

          // ── Title ────────────────────────────────────
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Kahan se kharidein?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5A5F7D),
                  ),
                ),
              ],
            ),
          ),

          // ── Platform list ────────────────────────────
          if (product.links.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'No affiliate links available for this product.',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: product.links.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final linkItem = product.links[index];
                final platformName = linkItem.platform;
                final url = linkItem.url;

                final config = _platformConfigs[platformName] ??
                    _platformConfigs['Other']!;

                return Material(
                  color: config['color'] as Color,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _openPlatform(url);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          // Logo
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
                                imageUrl: config['logo'] as String,
                                fit: BoxFit.contain,
                                httpHeaders: const {
                                  'User-Agent':
                                      'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36',
                                },
                                errorWidget: (_, __, ___) => const Icon(
                                    Icons.store_rounded,
                                    color: Color(0xFF6B4EFF)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Name + badge
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      platformName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                        color: Color(0xFF1E212D),
                                      ),
                                    ),
                                    if (config['badge'] != null) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF6B4EFF),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          config['badge'] as String,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  config['hint'] as String? ??
                                      'Click to view product',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Arrow
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF6B4EFF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_forward_ios,
                                size: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
