import 'package:deal_bridge_app/app/data/models/platform_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deal_bridge_app/app/data/models/product_model.dart';
import 'package:deal_bridge_app/app/data/services/api_service.dart';

class AdminController extends GetxController {
  final ApiService _apiService = ApiService();
  var productList = <ProductModel>[].obs;
  var platformList = <PlatformModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchPlatforms();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var products = await _apiService.getProducts();
      productList.assignAll(products);

      // Fetch analytics from backend
      int clicks = await _apiService.fetchAnalyticsTotalClicks();
      _totalClicksData.value = clicks;
    } finally {
      isLoading(false);
    }
  }

  var _totalClicksData = 0.obs;
  int get totalClicks => _totalClicksData.value;

  var isSaving = false.obs;

  Future<bool> addProduct(Map<String, dynamic> productData) async {
    isSaving(true);
    try {
      bool success = await _apiService.addProduct(productData);
      if (success) {
        fetchProducts(); // Refresh the product list
      }
      return success;
    } finally {
      isSaving(false);
    }
  }

  Future<bool> updateProduct(
      String id, Map<String, dynamic> productData) async {
    isSaving(true);
    try {
      bool success = await _apiService.updateProduct(id, productData);
      if (success) {
        fetchProducts();
      }
      return success;
    } finally {
      isSaving(false);
    }
  }

  Future<void> deleteProduct(String id) async {
    bool success = await _apiService.deleteProduct(id);
    if (success) {
      Get.snackbar('Deleted', 'Product has been removed.',
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xFFFFFFFF));
      fetchProducts();
    } else {
      Get.snackbar('Error', 'Failed to delete product.',
          backgroundColor: const Color(0xFFE53935),
          colorText: const Color(0xFFFFFFFF));
    }
  }

  void fetchPlatforms() async {
    try {
      isLoading(true);
      var platforms = await _apiService.getPlatforms();
      platformList.assignAll(platforms);

      // Fetch analytics from backend
      int clicks = await _apiService.fetchAnalyticsTotalClicks();
      _totalClicksData.value = clicks;
    } finally {
      isLoading(false);
    }
  }

  // Future<bool> addPlatform(Map<String, dynamic> platformData) async {
  //   isSaving(true);
  //   try {
  //     bool success = await _apiService.addPlatform(platformData);
  //     if (success) {
  //       fetchPlatforms(); // Refresh the platform list
  //     }
  //     return success;
  //   } finally {
  //     isSaving(false);
  //   }
  // }

  Future<bool> addPlatform(Map<String, dynamic> data) async {
    try {
      isLoading(true);

      print("📡 Calling API...");
      final res = await _apiService.addPlatform(data);

      print("📡 API result: $res");

      isLoading(false);
      return res;
    } catch (e) {
      print("❌ Controller Error: $e");
      isLoading(false);
      return false;
    }
  }

  Future<bool> updatePlatform(
      String id, Map<String, dynamic> platformData) async {
    isSaving(true);
    try {
      bool success = await _apiService.updatePlatform(id, platformData);
      if (success) {
        fetchPlatforms();
      }
      return success;
    } finally {
      isSaving(false);
    }
  }

  Future<void> deletePlatform(String id) async {
    bool success = await _apiService.deletePlatform(id);
    if (success) {
      Get.snackbar('Deleted', 'Platform has been removed.',
          backgroundColor: const Color(0xFF4CAF50),
          colorText: const Color(0xFFFFFFFF));
      fetchPlatforms();
    } else {
      Get.snackbar('Error', 'Failed to delete platform.',
          backgroundColor: const Color(0xFFE53935),
          colorText: const Color(0xFFFFFFFF));
    }
  }
}
