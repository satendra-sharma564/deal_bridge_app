import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:deal_bridge_app/app/modules/admin/controllers/admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PlatformGrid extends StatelessWidget {
  final controller = Get.put(AdminController());

  PlatformGrid({super.key});

  int getCrossAxisCount(double width) {
    if (width < 600) return 2;
    if (width < 1000) return 3;
    return 4;
  }

  Future<void> openLink(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.inAppWebView);
  }

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "ff$hex";
    return Color(int.parse("0x$hex"));
  }

  /// Supports both network URLs and base64 data URIs
  Widget buildLogoWidget(String logoUrl) {
    if (logoUrl.startsWith('data:')) {
      // base64 image stored in DB
      try {
        final base64Str = logoUrl.split(',').last;
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.store_rounded, size: 40, color: Color(0xFF6B4EFF)),
        );
      } catch (_) {
        return const Icon(Icons.store_rounded, size: 40, color: Color(0xFF6B4EFF));
      }
    }
    // Regular network URL
    return CachedNetworkImage(
      imageUrl: logoUrl,
      fit: BoxFit.contain,
      httpHeaders: const {
        'User-Agent':
            'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
      },
      placeholder: (context, url) => const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF6B4EFF),
          ),
        ),
      ),
      errorWidget: (context, url, error) =>
          const Icon(Icons.store_rounded, size: 40, color: Color(0xFF6B4EFF)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.platformList.isEmpty) {
        return const SizedBox.shrink();
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: getCrossAxisCount(width),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: controller.platformList.length,
        itemBuilder: (context, index) {
          final item = controller.platformList[index];

          return InkWell(
            onTap: () => openLink(item.link),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: hexToColor(item.color),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: buildLogoWidget(item.logo)),
                  const SizedBox(height: 10),
                  Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
