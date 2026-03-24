import 'package:get/get.dart';
import 'package:deal_bridge_app/app/data/models/product_model.dart';
import 'package:deal_bridge_app/app/data/services/api_service.dart';

class HomeController extends GetxController {
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
}
