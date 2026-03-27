import 'package:deal_bridge_app/app/data/models/platform_model.dart';
import 'package:deal_bridge_app/app/data/services/platform_service.dart';
import 'package:get/get.dart';

class PlatformController extends GetxController {
  var platforms = <PlatformModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  void fetchData() async {
    try {
      isLoading(true);
      platforms.value = await PlatformService.fetchPlatforms();
    } finally {
      isLoading(false);
    }
  }
}
