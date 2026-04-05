import 'package:get/get.dart';
import 'package:deal_bridge_app/app/data/models/product_model.dart';
import 'package:deal_bridge_app/app/data/models/category_model.dart';
import 'package:deal_bridge_app/app/data/services/api_service.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();
  var productList = <ProductModel>[].obs;
  var categoryList = <CategoryModel>[].obs;
  var selectedCategory = 'All'.obs;
  var searchQuery = ''.obs;
  var isLoading = true.obs;
  var isProductsExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchCategories();
  }

  void fetchProducts() async {
    try {
      isLoading(true);
      var products = await _apiService.getProducts();
      productList.assignAll(products);
    } finally {
      isLoading(false);
    }
  }

  void fetchCategories() async {
    try {
      var categories = await _apiService.getCategories();
      categoryList
          .assignAll(categories.map((c) => CategoryModel.fromJson(c)).toList());
    } catch (e) {
      print("Error fetching categories: $e");
    }
  }

  void selectCategory(String categoryName) {
    selectedCategory.value = categoryName;
    isProductsExpanded.value = false;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    isProductsExpanded.value = false;
  }

  List<ProductModel> get filteredProducts {
    List<ProductModel> filtered = productList.toList();

    // Filter by Category
    if (selectedCategory.value != 'All') {
      filtered =
          filtered.where((p) => p.category == selectedCategory.value).toList();
    }

    // Filter by Search Query
    if (searchQuery.value.trim().isNotEmpty) {
      final query = searchQuery.value.trim().toLowerCase();
      filtered =
          filtered.where((p) => p.title.toLowerCase().contains(query)).toList();
    }

    return filtered;
  }

  /// Search ALL products (ignoring category filter) for [query] and return
  /// the Set of platform names whose affiliate links are in those products.
  Set<String> getPlatformNamesForQuery(String query) {
    if (query.trim().isEmpty) return {};
    final q = query.trim().toLowerCase();
    final Set<String> platforms = {};
    for (final product in productList) {
      if (product.title.toLowerCase().contains(q) ||
          product.category.toLowerCase().contains(q)) {
        for (final link in product.links) {
          if (link.platform.trim().isNotEmpty) {
            platforms.add(link.platform.trim());
          }
        }
      }
    }
    return platforms;
  }
}
