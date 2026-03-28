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
        "logo": "https://logo.clearbit.com/myntra.com",
        "link": "https://myntr.it/I2w661u",
        "color": Colors.pink.shade50,
      },
      {
        "name": "Ajio",
        "logo": "https://logo.clearbit.com/ajio.com",
        "link": "https://ajiio.in/HR7e33a",
        "color": Colors.grey.shade100,
      },
      {
        "name": "Flipkart",
        "logo": "https://logo.clearbit.com/flipkart.com",
        "link": "https://fktr.in/l4NUzGg",
        "color": Colors.blue.shade50,
      },
      {
        "name": "Bitli",
        "logo": "https://logo.clearbit.com/bitly.com",
        "link": "https://bitli.in/7ayDprU",
        "color": Colors.grey.shade100,
      },
      {
        "name": "KIMTI",
        "logo": "https://logo.clearbit.com/meesho.com",
        "link": "https://bitli.in/tYJi64g",
        "color": Colors.pink.shade50,
      },
      {
        "name": "Reliance Digital",
        "logo": "https://logo.clearbit.com/reliancedigital.in",
        "link": "https://bitli.in/79N57YE",
        "color": Colors.red.shade50,
      },
      {
        "name": "The Derma Co",
        "logo": "https://logo.clearbit.com/thedermacompany.com",
        "link": "https://bitli.in/0eaayRI",
        "color": Colors.lightBlue.shade50,
      },
      {
        "name": "Neuro",
        "logo": "https://logo.clearbit.com/neurogum.com",
        "link": "https://bitli.in/M8j8i9K",
        "color": Colors.grey.shade100,
      },
      {
        "name": "Goibibo",
        "logo": "https://logo.clearbit.com/goibibo.com",
        "link": "https://bitli.in/97FWoodI",
        "color": Colors.teal.shade50,
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
                        httpHeaders: const {
                          'User-Agent':
                              'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
                        },
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
