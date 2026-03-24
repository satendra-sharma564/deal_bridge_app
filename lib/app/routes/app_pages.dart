import 'package:get/get.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/admin/views/admin_dashboard.dart';
import '../modules/admin/bindings/admin_binding.dart';
import '../modules/product_detail/view/product_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;
  static final routes = [
    GetPage(name: Routes.HOME, page: () => const HomeView(), binding: HomeBinding()),
    GetPage(name: Routes.ADMIN, page: () => const AdminDashboardView(), binding: AdminBinding()),
    GetPage(name: Routes.PRODUCT_DETAIL, page: () => const ProductDetailView()),
  ];
}
