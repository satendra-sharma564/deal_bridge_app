import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
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

  Future<bool> updateProduct(String id, Map<String, dynamic> productData) async {
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
}

