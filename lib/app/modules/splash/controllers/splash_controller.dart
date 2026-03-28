import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/services/version_service.dart';
import '../../../routes/app_pages.dart';

/// Current installed app version — must match pubspec.yaml version string
const String kAppVersion = '1.0.0'; // ← Update this every time you release new APK

class SplashController extends GetxController {
  final RxBool isChecking = true.obs;

  @override
  void onReady() {
    super.onReady();
    _checkVersion();
  }

  Future<void> _checkVersion() async {
    // Small delay for splash visibility
    await Future.delayed(const Duration(milliseconds: 1500));

    final result = await VersionService.checkForUpdate(kAppVersion);

    if (result != null) {
      isChecking.value = false;
      _showForceUpdateDialog(result);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }

  void _showForceUpdateDialog(VersionCheckResult result) {
    Get.dialog(
      WillPopScope(
        // Prevent back button from dismissing
        onWillPop: () async => false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: Row(
            children: const [
              Icon(Icons.system_update_alt_rounded, color: Color(0xFF6B4EFF), size: 28),
              SizedBox(width: 10),
              Text(
                'Update Required',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: Color(0xFF1E212D),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.message,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF5A5F7D),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EDFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFF6B4EFF), size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'New version: v${result.latestVersion}',
                      style: const TextStyle(
                        color: Color(0xFF6B4EFF),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _downloadUpdate(result.apkUrl),
                icon: const Icon(Icons.download_rounded, color: Colors.white),
                label: const Text(
                  'Update Karo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B4EFF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _downloadUpdate(String url) async {
    if (url.isEmpty || url.contains('YOUR_GOOGLE_DRIVE_FILE_ID')) {
      Get.snackbar(
        'Coming Soon',
        'APK link abhi set nahi hua. Admin se contact karein.',
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
