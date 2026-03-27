import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';
import 'package:deal_bridge_app/app/data/models/product_model.dart';

class AddProductView extends StatefulWidget {
  final ProductModel? productToEdit;
  
  const AddProductView({Key? key, this.productToEdit}) : super(key: key);

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final AdminController controller = Get.find<AdminController>();

  final List<String> _predefinedCategories = ['Electronics', 'Mobiles', 'Clothing', 'Home', 'Custom'];
  String _selectedDropCategory = 'Electronics';

  late final TextEditingController _titleCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _catCtrl;
  late final TextEditingController _imageCtrl;

  @override
  void initState() {
    super.initState();
    final p = widget.productToEdit;
    
    String initialCustomCat = '';
    if (p != null && p.category.isNotEmpty) {
      if (_predefinedCategories.contains(p.category)) {
        _selectedDropCategory = p.category;
      } else {
        _selectedDropCategory = 'Custom';
        initialCustomCat = p.category;
      }
    }

    _titleCtrl = TextEditingController(text: p?.title ?? '');
    _priceCtrl = TextEditingController(text: p != null ? p.price.toString() : '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _catCtrl = TextEditingController(text: initialCustomCat);
    _imageCtrl = TextEditingController(text: p?.image ?? '');
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    _catCtrl.dispose();
    _imageCtrl.dispose();
    super.dispose();
  }

  void _submitProduct() async {
    if (_titleCtrl.text.isEmpty || _priceCtrl.text.isEmpty) {
      Get.snackbar('Error', 'Title and Price are required!', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    final finalCategory = _selectedDropCategory == 'Custom' ? _catCtrl.text.trim() : _selectedDropCategory;

    if (finalCategory.isEmpty) {
      Get.snackbar('Error', 'Category cannot be empty!', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    final productData = {
      "title": _titleCtrl.text.trim(),
      "image": _imageCtrl.text.trim().isEmpty ? "https://via.placeholder.com/150" : _imageCtrl.text.trim(),
      "price": double.tryParse(_priceCtrl.text.trim()) ?? 0.0,
      "description": _descCtrl.text.trim(),
      "category": finalCategory,
    };

    bool success;
    if (widget.productToEdit == null) {
      success = await controller.addProduct(productData);
    } else {
      success = await controller.updateProduct(widget.productToEdit!.id!, productData);
    }

    if (success) {
      Get.back();
      Get.snackbar(
        'Success', 
        widget.productToEdit == null ? 'Product Added!' : 'Product Updated!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
        margin: const EdgeInsets.all(20),
        borderRadius: 16,
      );
    } else {
      Get.snackbar('Error', 'Failed to save product', backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.productToEdit != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Product' : 'Add New Product',
          style: const TextStyle(
            color: Color(0xFF1E212D),
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E212D)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Product Title'),
                _buildTextField(hint: 'e.g. MacBook Air', icon: Icons.title_rounded, controller: _titleCtrl),
                
                const SizedBox(height: 20),
                _buildSectionTitle('Price (₹)'),
                _buildTextField(hint: 'e.g. 99999', icon: Icons.attach_money_rounded, isNumber: true, controller: _priceCtrl),
                
                const SizedBox(height: 20),
                _buildSectionTitle('Description'),
                _buildTextField(hint: 'e.g. Apple laptop', icon: Icons.description_rounded, controller: _descCtrl),
                
                const SizedBox(height: 20),
                _buildSectionTitle('Product Category'),
                DropdownButtonFormField<String>(
                  value: _selectedDropCategory,
                  items: _predefinedCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                         _selectedDropCategory = val;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.category_rounded, color: const Color(0xFF6B4EFF).withOpacity(0.7)),
                    filled: true,
                    fillColor: const Color(0xFFF9FAFF),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF6B4EFF), width: 1.5)),
                  ),
                ),
                if (_selectedDropCategory == 'Custom') ...[
                  const SizedBox(height: 12),
                  _buildTextField(hint: 'Enter custom category', icon: Icons.edit_rounded, controller: _catCtrl),
                ],
                
                const SizedBox(height: 20),
                _buildSectionTitle('Image URL'),
                _buildTextField(hint: 'https://via.placeholder.com/150', icon: Icons.image_rounded, controller: _imageCtrl),
                
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Obx(() => ElevatedButton(
                    onPressed: controller.isSaving.value ? null : _submitProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B4EFF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: controller.isSaving.value
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(isEditing ? 'Update Product' : 'Save Product', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4A4E69),
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint, required IconData icon, bool isNumber = false, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB0B3C6)),
        prefixIcon: Icon(icon, color: const Color(0xFF6B4EFF).withOpacity(0.7)),
        filled: true,
        fillColor: const Color(0xFFF9FAFF),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF6B4EFF), width: 1.5),
        ),
      ),
    );
  }
}
