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
    return Color(int.parse("0xff$hex"));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
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
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: hexToColor(item.color),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    item.logo,
                    height: 40,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.store, size: 40),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
