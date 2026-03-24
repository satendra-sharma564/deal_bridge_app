import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/services/api_service.dart';

class AdminController extends GetxController {
  final ApiService _apiService = ApiService();
  var productList = <ProductModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
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
  
  int get totalClicks {
    return productList.fold(0, (sum, item) => sum + item.clicks);
  }
}
