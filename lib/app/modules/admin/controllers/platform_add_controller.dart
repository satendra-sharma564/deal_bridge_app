// import 'package:get/get.dart';
// import '../../../data/services/api_service.dart';

// class AdminPlatformController extends GetxController {
//   final ApiService api = ApiService();

//   var isLoading = false.obs;

//   Future<void> addPlatform({
//     String? name,
//     String? logo,
//     String? link,
//     String? color,
//   }) async {
//     try {
//       isLoading(true);

//       final success = await api.addPlatform({
//         "name": name,
//         "logo": logo,
//         "link": link,
//         "color": color,
//       });

//       if (success) {
//         Get.snackbar("Success", "Platform Added ✅");
//       } else {
//         Get.snackbar("Error", "Failed ❌");
//       }
//     } finally {
//       isLoading(false);
//     }
//   }
// }
