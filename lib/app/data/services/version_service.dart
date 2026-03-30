import 'dart:convert';
import 'package:http/http.dart' as http;

class VersionCheckResult {
  final String latestVersion;
  final String apkUrl;
  final bool forceUpdate;
  final String message;

  VersionCheckResult({
    required this.latestVersion,
    required this.apkUrl,
    required this.forceUpdate,
    required this.message,
  });

  factory VersionCheckResult.fromJson(Map<String, dynamic> json) {
    return VersionCheckResult(
      latestVersion: json['latestVersion'] ?? '1.0.0',
      apkUrl: json['apkUrl'] ?? '',
      forceUpdate: json['forceUpdate'] ?? false,
      message: json['message'] ?? 'Please update the app.',
    );
  }
}

class VersionService {
  static const String _baseUrl = 'https://dealbridge-backend.onrender.com/api';

  /// Returns null if up-to-date, or [VersionCheckResult] if update required.
  static Future<VersionCheckResult?> checkForUpdate(
      String currentVersion) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/version'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = VersionCheckResult.fromJson(data);

        if (_isUpdateRequired(currentVersion, result.latestVersion)) {
          return result;
        }
      }
    } catch (e) {
      // If server is unreachable, allow user to proceed (don't block)
      print('Version check error: $e');
    }
    return null;
  }

  /// Returns true if [serverVersion] is newer than [localVersion]
  static bool _isUpdateRequired(String local, String server) {
    final localParts = local.split('.').map(int.parse).toList();
    final serverParts = server.split('.').map(int.parse).toList();

    for (int i = 0; i < serverParts.length; i++) {
      final l = i < localParts.length ? localParts[i] : 0;
      final s = serverParts[i];
      if (s > l) return true;
      if (s < l) return false;
    }
    return false;
  }
}
