import 'dart:convert';
import 'package:deal_bridge_app/app/data/models/platform_model.dart';
import 'package:http/http.dart' as http;

class PlatformService {
  static Future<List<PlatformModel>> fetchPlatforms() async {
    final response = await http.get(
      Uri.parse("https://dealbridge-backend.onrender.com/api/platforms"),
    );

    final data = jsonDecode(response.body);

    return (data['data'] as List)
        .map((e) => PlatformModel.fromJson(e))
        .toList();
  }
}
