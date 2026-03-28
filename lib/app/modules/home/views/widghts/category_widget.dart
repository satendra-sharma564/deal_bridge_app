import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';

class CategoryWidget extends GetView<HomeController> {
  const CategoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Obx(() {
        final apiCats = controller.categoryList.map((c) => c.name).toSet();
        final productCats = controller.productList.map((p) => p.category).where((c) => c.trim().isNotEmpty).toSet();
        final combinedCats = apiCats.union(productCats).toList();
        
        final categories = ['All', ...combinedCats];
        
        if (categories.length == 1 && controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF6B4EFF)));
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final catName = categories[index];
            final isSelected = controller.selectedCategory.value == catName;
            
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: GestureDetector(
                onTap: () {
                  controller.selectCategory(catName);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF6B4EFF) : Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: isSelected ? null : Border.all(color: Colors.grey.shade300),
                    boxShadow: isSelected
                        ? [BoxShadow(color: const Color(0xFF6B4EFF).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                        : [],
                  ),
                  child: Text(
                    catName,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF1E212D),
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
