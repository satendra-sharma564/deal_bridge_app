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

  // ── All supported platforms with their affiliate links ──────────────────
  static final List<Map<String, dynamic>> _platforms = [
    {
      'name': 'Amazon',
      'logo': 'https://logo.clearbit.com/amazon.in',
      'color': const Color(0xFFFFF8EC),
      'badge': '🏷️ Affiliate',
      'hint': 'Product automatically search hoga',
      'getUrl': (String title) =>
          'https://www.amazon.in/s?k=${Uri.encodeComponent(title)}&tag=dealbridge0d-21',
    },
    {
      'name': 'Flipkart',
      'logo': 'https://logo.clearbit.com/flipkart.com',
      'color': const Color(0xFFE8F4FF),
      'badge': '🏷️ Affiliate',
      'hint': 'Platform pe jaake khud search karein',
      'getUrl': (String title) => 'https://fktr.in/l4NUzGg',
    },
    {
      'name': 'Myntra',
      'logo': 'https://logo.clearbit.com/myntra.com',
      'color': const Color(0xFFFFF0F5),
      'badge': '🏷️ Affiliate',
      'hint': 'Platform pe jaake khud search karein',
      'getUrl': (String title) => 'https://myntr.it/I2w661u',
    },
    {
      'name': 'Ajio',
      'logo': 'https://logo.clearbit.com/ajio.com',
      'color': const Color(0xFFF0F0F0),
      'badge': '🏷️ Affiliate',
      'hint': 'Platform pe jaake khud search karein',
      'getUrl': (String title) => 'https://ajiio.in/HR7e33a',
    },
    {
      'name': 'Meesho',
      'logo': 'https://logo.clearbit.com/meesho.com',
      'color': const Color(0xFFF5F0FF),
      'badge': '🏷️ Affiliate',
      'hint': 'Platform pe jaake khud search karein',
      'getUrl': (String title) => 'https://bitli.in/tYJi64g',
    },
    {
      'name': 'Reliance Digital',
      'logo': 'https://logo.clearbit.com/reliancedigital.in',
      'color': const Color(0xFFFFEEEE),
      'badge': '🏷️ Affiliate',
      'hint': 'Platform pe jaake khud search karein',
      'getUrl': (String title) => 'https://bitli.in/79N57YE',
    },
  ];

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
                      Text(
                        '₹${product.price.toInt()}',
                        style: const TextStyle(
                          color: Color(0xFF6B4EFF),
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
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
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: _platforms.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final p = _platforms[index];
              final url =
                  (p['getUrl'] as String Function(String))(product.title);

              return Material(
                color: p['color'] as Color,
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
                              imageUrl: p['logo'] as String,
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
                                    p['name'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                      color: Color(0xFF1E212D),
                                    ),
                                  ),
                                  if (p['badge'] != null) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF6B4EFF),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        p['badge'] as String,
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
                                p['hint'] as String? ?? 'Yahan search karein',
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
