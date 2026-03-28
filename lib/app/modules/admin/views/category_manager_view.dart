import 'package:deal_bridge_app/app/data/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';

class CategoryManagerView extends StatelessWidget {
  final AdminController controller = Get.find();
  final TextEditingController _categoryCtrl = TextEditingController();

  CategoryManagerView({super.key});

  void _showAddEditDialog(BuildContext context, [CategoryModel? cat]) {
    _categoryCtrl.text = cat?.name ?? '';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(cat == null ? 'Add Category' : 'Edit Category'),
        content: TextField(
          controller: _categoryCtrl,
          decoration: const InputDecoration(hintText: 'e.g. Electronics'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
                onPressed: controller.isSaving.value
                    ? null
                    : () async {
                        final name = _categoryCtrl.text.trim();
                        if (name.isEmpty) return;

                        bool success;
                        if (cat == null) {
                          success = await controller.addCategory(name);
                        } else {
                          success = await controller.updateCategory(cat.id, name);
                        }

                        if (success) {
                          Get.back();
                          Get.snackbar(
                            'Success',
                            cat == null ? 'Category added!' : 'Category updated!',
                            backgroundColor: Colors.green.shade100,
                            colorText: Colors.green.shade900,
                          );
                        }
                      },
                child: controller.isSaving.value
                    ? const SizedBox(
                        height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(cat == null ? 'Add' : 'Update'),
              )),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, CategoryModel cat) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${cat.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              controller.deleteCategory(cat.id);
              Get.back();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: const Text('Manage Categories', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6B4EFF),
        onPressed: () => _showAddEditDialog(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Category', style: TextStyle(color: Colors.white)),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.categoryList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.categoryList.isEmpty) {
          return const Center(child: Text('No categories found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.categoryList.length,
          itemBuilder: (context, index) {
            final cat = controller.categoryList[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showAddEditDialog(context, cat),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(context, cat),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
