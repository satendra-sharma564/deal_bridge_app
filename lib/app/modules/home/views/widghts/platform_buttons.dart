import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlatformButtons extends StatelessWidget {
  const PlatformButtons({super.key});

  Future<void> openLink(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔴 Myntra Button
        GestureDetector(
          onTap: () {
            openLink("https://myntr.it/I2w661u");
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/0/0d/Myntra_logo.png",
                  height: 30,
                ),
                const SizedBox(width: 10),
                const Text(
                  "Shop on Myntra",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // 🔵 Ajio Button
        GestureDetector(
          onTap: () {
            openLink("https://ajiio.in/HR7e33a");
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/2/2a/Ajio-Logo.png",
                  height: 30,
                ),
                const SizedBox(width: 10),
                const Text(
                  "Shop on Ajio",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
