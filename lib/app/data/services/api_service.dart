import 'dart:convert';
import 'package:deal_bridge_app/app/data/models/platform_model.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = 'https://dealbridge-backend.onrender.com/api';

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/products'));
      if (response.statusCode == 200) {
        Iterable json = jsonDecode(response.body);
        return json.map((e) => ProductModel.fromJson(e)).toList();
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
    return [];
  }

  Future<bool> addProduct(Map<String, dynamic> productData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productData),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      print('Error adding product: $e');
    }
    return false;
  }

  Future<int> fetchAnalyticsTotalClicks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/analytics'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['totalClicks'] ?? 0;
      }
    } catch (e) {
      print('Error fetching analytics: $e');
    }
    return 0;
  }

  Future<bool> updateProduct(
      String id, Map<String, dynamic> productData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productData),
      );
      if (response.statusCode == 200) return true;
    } catch (e) {
      print('Error updating product: $e');
    }
    return false;
  }

  Future<bool> deleteProduct(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/products/$id'));
      if (response.statusCode == 200) return true;
    } catch (e) {
      print('Error deleting product: $e');
    }
    return false;
  }

  // Future<bool> addPlatform(Map<String, dynamic> data) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/platforms'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(data),
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return true;
  //     }
  //   } catch (e) {
  //     print('Error adding platform: $e');
  //   }
  //   return false;
  // }

  Future<bool> addPlatform(Map<String, dynamic> data) async {
    try {
      print("🌐 API URL: $baseUrl/platforms");

      final response = await http.post(
        Uri.parse('$baseUrl/platforms'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      print('❌ API Error: $e');
    }
    return false;
  }

  Future<List<PlatformModel>> getPlatforms() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/platforms'));
      if (response.statusCode == 200) {
        //Iterable json = jsonDecode(response.body);
        final List list = jsonDecode(response.body)['data'];
        return list.map((e) => PlatformModel.fromJson(e)).toList();
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
    return [];
  }

  Future<bool> updatePlatform(
      String id, Map<String, dynamic> platformData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/platforms/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(platformData),
      );
      if (response.statusCode == 200) return true;
    } catch (e) {
      print('Error updating platform: $e');
    }
    return false;
  }

  Future<bool> deletePlatform(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/platforms/$id'));
      if (response.statusCode == 200) return true;
    } catch (e) {
      print('Error deleting platform: $e');
    }
    return false;
  }

  // ── Categories ───────────────────────────────────────────
  Future<List<dynamic>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
    return [];
  }

  Future<bool> addCategory(String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/categories'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      print('Error adding category: $e');
    }
    return false;
  }

  Future<bool> updateCategory(String id, String name) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/categories/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name}),
      );
      if (response.statusCode == 200) return true;
    } catch (e) {
      print('Error updating category: $e');
    }
    return false;
  }

  Future<bool> deleteCategory(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/categories/$id'));
      if (response.statusCode == 200) return true;
    } catch (e) {
      print('Error deleting category: $e');
    }
    return false;
  }

  // ── Notifications ─────────────────────────────────────────
  Future<bool> sendNotification(String title, String body) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/notifications/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'body': body,
          'topic': 'all_users',
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      print('Notification API error: ${response.statusCode} ${response.body}');
    } catch (e) {
      print('Error sending notification: $e');
    }
    return false;
  }
}
