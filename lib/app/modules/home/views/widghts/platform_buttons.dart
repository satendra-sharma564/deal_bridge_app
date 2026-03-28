import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlatformButtons extends StatelessWidget {
  const PlatformButtons({super.key});

  Future<void> openLink(String url) async {
    final uri = Uri.parse(url);
    // Use inAppWebView to prevent native apps (Myntra, Flipkart, etc.)
    // from intercepting the URL via Android deep-link intent,
    // ensuring affiliate tags remain intact in the URL.
    if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final platforms = [
      {
        "name": "Myntra",
        "logo":
            "https://upload.wikimedia.org/wikipedia/commons/0/0d/Myntra_logo.png",
        "link": "https://myntr.it/I2w661u",
        "color": Colors.pink.shade50,
      },
      {
        "name": "Ajio",
        "logo":
            "https://upload.wikimedia.org/wikipedia/commons/2/2a/Ajio-Logo.png",
        "link": "https://ajiio.in/HR7e33a",
        "color": Colors.grey.shade100,
      },
      {
        "name": "Flipkart",
        "logo":
            "https://upload.wikimedia.org/wikipedia/commons/f/f1/Flipkart-logo.png",
        "link": "https://fktr.in/l4NUzGg",
        "color": Colors.grey.shade100,
      },
      {
        "name": "Bitli",
        "logo":
            "https://upload.wikimedia.org/wikipedia/commons/f/f1/Flipkart-logo.png",
        "link": "https://bitli.in/7ayDprU",
        "color": Colors.grey.shade100,
      },
      {
        "name": "KIMTI",
        "logo":
            "https://upload.wikimedia.org/wikipedia/commons/f/f1/Flipkart-logo.png",
        "link": "https://bitli.in/tYJi64g",
        "color": Colors.grey.shade100,
      },
      {
        "name": "Reliance digital",
        "logo":
            "https://upload.wikimedia.org/wikipedia/commons/f/f1/Flipkart-logo.png",
        "link": "https://bitli.in/79N57YE",
        "color": Colors.grey.shade100,
      },
      {
        "name": "The Derma co",
        "logo":
            "https://upload.wikimedia.org/wikipedia/commons/0/0d/Myntra_logo.png",
        "link": "https://bitli.in/0eaayRI",
        "color": Colors.grey.shade100,
      },
      {
        "name": "Neuro",
        "logo":
            "https://upload.wikimedia.org/wikipedia/commons/0/0d/Myntra_logo.png",
        "link": "https://bitli.in/M8j8i9K",
        "color": Colors.grey.shade100,
      },
      {
        "name": "Goibibo",
        "logo":
            "https://upload.wikimedia.org/wikipedia/commons/0/0d/Myntra_logo.png",
        "link": "https://bitli.in/97FWoodI",
        "color": Colors.grey.shade100,
      },
    ];

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250, // responsive like ProductGrid
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.9,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = platforms[index];

          return GestureDetector(
            onTap: () => openLink(item['link'] as String),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 TOP LOGO AREA (same as product image box)
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: item['color'] as Color,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: item['logo'] as String,
                        fit: BoxFit.contain,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image, size: 40),
                      ),
                    ),
                  ),

                  /// 🔹 TEXT AREA (same feel as product details)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Shop Now",
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF6B4EFF),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['name'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: Color(0xFF1E212D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Visit Store",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF0EDFF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 10,
                                color: Color(0xFF6B4EFF),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
        childCount: platforms.length,
      ),
    );
  }
}
