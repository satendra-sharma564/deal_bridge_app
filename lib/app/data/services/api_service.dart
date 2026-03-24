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
}
