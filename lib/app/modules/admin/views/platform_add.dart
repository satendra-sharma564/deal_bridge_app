import 'dart:convert';
import 'dart:io';
import 'package:deal_bridge_app/app/data/models/platform_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/admin_controller.dart';

class AddPlatformView extends StatefulWidget {
  final PlatformModel? platformToEdit;
  const AddPlatformView({Key? key, this.platformToEdit}) : super(key: key);

  @override
  State<AddPlatformView> createState() => _AddPlatformViewState();
}

class _AddPlatformViewState extends State<AddPlatformView> {
  final AdminController controller = Get.find<AdminController>();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _logoCtrl = TextEditingController();
  final TextEditingController _linkCtrl = TextEditingController();
  final TextEditingController _colorCtrl = TextEditingController(text: '#ffffff');
  final TextEditingController _customCatCtrl = TextEditingController();

  String? _selectedDropCategory;

  // Logo source toggle
  bool _useUrlForLogo = true;
  File? _pickedImage;
  bool _isUploadingImage = false;
  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.platformToEdit != null) {
      _nameCtrl.text = widget.platformToEdit!.name;
      _logoCtrl.text = widget.platformToEdit!.logo;
      _linkCtrl.text = widget.platformToEdit!.link;
      _colorCtrl.text = widget.platformToEdit!.color;

      final editCat = widget.platformToEdit!.category;
      // Check if this category exists among platform categories
      final exists = controller.platformList
          .any((p) => p.category.trim().toLowerCase() == editCat.trim().toLowerCase());
      if (exists) {
        _selectedDropCategory = editCat;
      } else {
        _selectedDropCategory = 'Custom';
        _customCatCtrl.text = editCat;
      }
    } else {
      // Default: first platform category or General
      final cats = _getUniquePlatformCategories();
      _selectedDropCategory = cats.isNotEmpty ? cats.first : 'General';
    }
  }

  List<String> _getUniquePlatformCategories() {
    final Set<String> seen = {};
    return controller.platformList
        .map((p) => p.category.trim())
        .where((cat) => cat.isNotEmpty && seen.add(cat))
        .toList()
      ..sort();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _logoCtrl.dispose();
    _linkCtrl.dispose();
    _colorCtrl.dispose();
    _customCatCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
      imageQuality: 85,
    );

    if (image == null) return;

    setState(() {
      _isUploadingImage = true;
      _pickedImage = File(image.path);
      _uploadedImageUrl = null;
    });

    try {
      final bytes = await _pickedImage!.readAsBytes();
      final base64Str = base64Encode(bytes);
      final mimeType = image.mimeType ?? 'image/jpeg';
      final dataUri = 'data:$mimeType;base64,$base64Str';

      setState(() {
        _uploadedImageUrl = dataUri;
        _isUploadingImage = false;
      });

      Get.snackbar(
        'Image Ready ✅',
        'Image successfully loaded!',
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      setState(() => _isUploadingImage = false);
      Get.snackbar(
        'Error ❌',
        'Could not load image. Try again.',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _submitPlatform() async {
    if (_nameCtrl.text.isEmpty || _linkCtrl.text.isEmpty) {
      Get.snackbar('Error', 'Name and Affiliate Link are required!',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    String logoUrl;
    if (_useUrlForLogo) {
      logoUrl = _logoCtrl.text.trim().isEmpty
          ? 'https://via.placeholder.com/100'
          : _logoCtrl.text.trim();
    } else {
      if (_uploadedImageUrl == null) {
        Get.snackbar('Error', 'Please pick and upload an image first!',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
        return;
      }
      logoUrl = _uploadedImageUrl!;
    }

    final finalCategory = _selectedDropCategory == 'Custom'
        ? _customCatCtrl.text.trim()
        : (_selectedDropCategory ?? 'General');

    if (finalCategory.isEmpty) {
      Get.snackbar('Error', 'Category cannot be empty!',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    final data = {
      'name': _nameCtrl.text.trim(),
      'logo': logoUrl,
      'link': _linkCtrl.text.trim(),
      'color': _colorCtrl.text.trim(),
      'category': finalCategory,
    };

    bool success;
    if (widget.platformToEdit != null) {
      success = await controller.updatePlatform(widget.platformToEdit!.id, data);
    } else {
      success = await controller.addPlatform(data);
    }

    if (success) {
      Get.back();
      Get.snackbar(
        'Success ✅',
        widget.platformToEdit != null ? 'Platform Updated!' : 'Platform Added!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
    } else {
      Get.snackbar('Error ❌', 'Failed to save platform.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  // ── Category Picker (Bottom Sheet) ─────────────────────────

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final catNames = _getUniquePlatformCategories();
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.55,
              maxChildSize: 0.85,
              builder: (_, scrollCtrl) => Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select Category',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      controller: scrollCtrl,
                      children: [
                        // Platform categories with delete option
                        ...catNames.map((cat) {
                          final isGeneral =
                              cat.trim().toLowerCase() == 'general';
                          final isSelected = _selectedDropCategory == cat;
                          return ListTile(
                            leading: Icon(
                              isSelected
                                  ? Icons.check_circle_rounded
                                  : Icons.label_outline_rounded,
                              color: isSelected
                                  ? const Color(0xFF6B4EFF)
                                  : Colors.grey,
                              size: 20,
                            ),
                            title: Text(
                              cat,
                              style: TextStyle(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? const Color(0xFF6B4EFF)
                                    : const Color(0xFF1E212D),
                              ),
                            ),
                            trailing: isGeneral
                                ? null
                                : IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.redAccent, size: 20),
                                    onPressed: () {
                                      _confirmDeletePlatformCategory(
                                        cat,
                                        onDeleted: () {
                                          setModalState(() {}); // refresh sheet
                                          setState(() {
                                            if (_selectedDropCategory == cat) {
                                              _selectedDropCategory = 'General';
                                            }
                                          });
                                        },
                                      );
                                    },
                                  ),
                            onTap: () {
                              setState(() => _selectedDropCategory = cat);
                              Get.back();
                            },
                          );
                        }),

                        // Custom option
                        ListTile(
                          leading: Icon(
                            _selectedDropCategory == 'Custom'
                                ? Icons.check_circle_rounded
                                : Icons.edit_outlined,
                            color: _selectedDropCategory == 'Custom'
                                ? const Color(0xFF6B4EFF)
                                : Colors.grey,
                            size: 20,
                          ),
                          title: Text(
                            'Custom',
                            style: TextStyle(
                              fontWeight: _selectedDropCategory == 'Custom'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _selectedDropCategory == 'Custom'
                                  ? const Color(0xFF6B4EFF)
                                  : const Color(0xFF1E212D),
                            ),
                          ),
                          onTap: () {
                            setState(() => _selectedDropCategory = 'Custom');
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDeletePlatformCategory(
    String categoryName, {
    required VoidCallback onDeleted,
  }) {
    final affectedCount = controller.platformList
        .where((p) =>
            p.category.trim().toLowerCase() ==
            categoryName.trim().toLowerCase())
        .length;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 22),
            SizedBox(width: 8),
            Text('Delete Category',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Delete "$categoryName"?'),
            if (affectedCount > 0) ...[
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.orange.shade700, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$affectedCount platform(s) will move to "General".',
                        style: TextStyle(
                            color: Colors.orange.shade800, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Get.back(); // close dialog
              // Move all platforms in this category → General
              for (final p in controller.platformList
                  .where((p) =>
                      p.category.trim().toLowerCase() ==
                      categoryName.trim().toLowerCase())
                  .toList()) {
                await controller.updatePlatform(p.id, {
                  'name': p.name,
                  'logo': p.logo,
                  'link': p.link,
                  'color': p.color,
                  'category': 'General',
                });
              }
              await controller.fetchPlatforms();
              onDeleted();
              Get.back(); // close bottom sheet
              Get.snackbar(
                'Deleted ✅',
                affectedCount > 0
                    ? '$affectedCount platform(s) moved to "General".'
                    : 'Category removed.',
                backgroundColor: Colors.green.shade100,
                colorText: Colors.green.shade900,
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: Text(
          widget.platformToEdit != null ? 'Edit Platform' : 'Add Platform',
          style: const TextStyle(
              color: Color(0xFF1E212D), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E212D)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
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
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Platform Name
                _buildSectionTitle('Platform Name'),
                _buildTextField(
                    hint: 'e.g. Myntra',
                    icon: Icons.store_rounded,
                    controller: _nameCtrl),
                const SizedBox(height: 24),

                // Logo
                _buildSectionTitle('Platform Logo'),
                Row(
                  children: [
                    _buildToggleChip(
                      label: '🔗 URL se',
                      selected: _useUrlForLogo,
                      onTap: () => setState(() {
                        _useUrlForLogo = true;
                        _pickedImage = null;
                        _uploadedImageUrl = null;
                      }),
                    ),
                    const SizedBox(width: 10),
                    _buildToggleChip(
                      label: '🖼️ Gallery se',
                      selected: !_useUrlForLogo,
                      onTap: () => setState(() => _useUrlForLogo = false),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_useUrlForLogo)
                  _buildTextField(
                      hint: 'https://logo-url.png',
                      icon: Icons.image_rounded,
                      controller: _logoCtrl),
                if (!_useUrlForLogo) _buildGalleryPicker(),
                if (_useUrlForLogo && _logoCtrl.text.isNotEmpty ||
                    !_useUrlForLogo && _uploadedImageUrl != null)
                  _buildLogoPreview(),
                const SizedBox(height: 20),

                // Affiliate Link
                _buildSectionTitle('Affiliate Link'),
                _buildTextField(
                    hint: 'https://earnkro.com/...',
                    icon: Icons.link_rounded,
                    controller: _linkCtrl),
                const SizedBox(height: 20),

                // Category
                _buildSectionTitle('Platform Category'),
                _buildCategoryField(),
                const SizedBox(height: 20),

                // Theme Color
                _buildSectionTitle('Theme Color (Hex)'),
                _buildTextField(
                    hint: '#ffffff',
                    icon: Icons.color_lens_rounded,
                    controller: _colorCtrl),
                const SizedBox(height: 36),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Obx(() => ElevatedButton(
                        onPressed:
                            controller.isLoading.value || _isUploadingImage
                                ? null
                                : _submitPlatform,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B4EFF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: controller.isLoading.value || _isUploadingImage
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : Text(
                                widget.platformToEdit != null
                                    ? 'Update Platform'
                                    : 'Save Platform',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Category Field ──────────────────────────────────────────

  Widget _buildCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tappable field to open bottom sheet
        GestureDetector(
          onTap: _showCategoryPicker,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.category_rounded,
                    color: const Color(0xFF6B4EFF).withOpacity(0.7), size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    (_selectedDropCategory == null ||
                            _selectedDropCategory!.isEmpty)
                        ? 'Select category...'
                        : _selectedDropCategory == 'Custom'
                            ? 'Custom'
                            : _selectedDropCategory!,
                    style: TextStyle(
                      fontSize: 16,
                      color: (_selectedDropCategory == null ||
                              _selectedDropCategory!.isEmpty)
                          ? const Color(0xFFB0B3C6)
                          : const Color(0xFF1E212D),
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF6B4EFF)),
              ],
            ),
          ),
        ),

        // Custom text field
        if (_selectedDropCategory == 'Custom') ...[
          const SizedBox(height: 12),
          _buildTextField(
            hint: 'Enter custom category',
            icon: Icons.edit_rounded,
            controller: _customCatCtrl,
          ),
        ],
      ],
    );
  }

  // ── Helper Widgets ──────────────────────────────────────────

  Widget _buildGalleryPicker() {
    return GestureDetector(
      onTap: _isUploadingImage ? null : _pickAndUploadImage,
      child: Container(
        height: 130,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF6B4EFF).withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: _isUploadingImage
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF6B4EFF)),
                    SizedBox(height: 10),
                    Text('Uploading...',
                        style: TextStyle(color: Color(0xFF6B4EFF))),
                  ],
                ),
              )
            : _pickedImage != null && _uploadedImageUrl != null
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(_pickedImage!,
                            fit: BoxFit.contain,
                            height: 130,
                            width: double.infinity),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text('Uploaded',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_rounded,
                          size: 40,
                          color: const Color(0xFF6B4EFF).withOpacity(0.6)),
                      const SizedBox(height: 8),
                      const Text('Tap to pick from Gallery',
                          style: TextStyle(
                              color: Color(0xFF6B4EFF),
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      const Text('PNG, JPG supported',
                          style: TextStyle(
                              color: Color(0xFFB0B3C6), fontSize: 12)),
                    ],
                  ),
      ),
    );
  }

  Widget _buildLogoPreview() {
    final url = _useUrlForLogo ? _logoCtrl.text.trim() : _uploadedImageUrl!;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          const Text('Preview: ',
              style: TextStyle(color: Color(0xFF4A4E69), fontSize: 13)),
          const SizedBox(width: 8),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EDFF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(url,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF6B4EFF) : const Color(0xFFF0EDFF),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : const Color(0xFF6B4EFF),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
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

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      onChanged: (_) => setState(() {}),
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
