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
  final TextEditingController _colorCtrl = TextEditingController(text: "#ffffff");

  // Logo source toggle
  bool _useUrlForLogo = true;
  File? _pickedImage;
  bool _isUploadingImage = false;
  String? _uploadedImageUrl; // stores base64 data URI

  @override
  void initState() {
    super.initState();
    if (widget.platformToEdit != null) {
      _nameCtrl.text = widget.platformToEdit!.name;
      _logoCtrl.text = widget.platformToEdit!.logo;
      _linkCtrl.text = widget.platformToEdit!.link;
      _colorCtrl.text = widget.platformToEdit!.color;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _logoCtrl.dispose();
    _linkCtrl.dispose();
    _colorCtrl.dispose();
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
      // Convert to base64 — no external API needed!
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
      Get.snackbar(
        'Error',
        'Name and Affiliate Link are required!',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    // Determine logo URL
    String logoUrl;
    if (_useUrlForLogo) {
      logoUrl = _logoCtrl.text.trim().isEmpty
          ? 'https://via.placeholder.com/100'
          : _logoCtrl.text.trim();
    } else {
      if (_uploadedImageUrl == null) {
        Get.snackbar(
          'Error',
          'Please pick and upload an image first!',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }
      logoUrl = _uploadedImageUrl!;
    }

    final data = {
      "name": _nameCtrl.text.trim(),
      "logo": logoUrl,
      "link": _linkCtrl.text.trim(),
      "color": _colorCtrl.text.trim(),
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
      Get.snackbar(
        'Error ❌',
        'Failed to save platform. Try again.',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: Text(
          widget.platformToEdit != null ? 'Edit Platform' : 'Add Platform',
          style: const TextStyle(
            color: Color(0xFF1E212D),
            fontWeight: FontWeight.bold,
          ),
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
                  controller: _nameCtrl,
                ),
                const SizedBox(height: 24),

                // ── LOGO SECTION ──────────────────────────────
                _buildSectionTitle('Platform Logo'),

                // Toggle: URL vs Gallery
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

                // URL input
                if (_useUrlForLogo)
                  _buildTextField(
                    hint: 'https://logo-url.png',
                    icon: Icons.image_rounded,
                    controller: _logoCtrl,
                  ),

                // Gallery picker
                if (!_useUrlForLogo) _buildGalleryPicker(),

                // ── Preview ───────────────────────────────────
                if (_useUrlForLogo && _logoCtrl.text.isNotEmpty ||
                    !_useUrlForLogo && _uploadedImageUrl != null)
                  _buildLogoPreview(),

                const SizedBox(height: 20),

                // Affiliate Link
                _buildSectionTitle('Affiliate Link'),
                _buildTextField(
                  hint: 'https://earnkro.com/...',
                  icon: Icons.link_rounded,
                  controller: _linkCtrl,
                ),
                const SizedBox(height: 20),

                // Theme Color
                _buildSectionTitle('Theme Color (Hex)'),
                _buildTextField(
                  hint: '#ffffff',
                  icon: Icons.color_lens_rounded,
                  controller: _colorCtrl,
                ),
                const SizedBox(height: 36),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value || _isUploadingImage
                            ? null
                            : _submitPlatform,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B4EFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isLoading.value || _isUploadingImage
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                widget.platformToEdit != null
                                    ? 'Update Platform'
                                    : 'Save Platform',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
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
            style: BorderStyle.solid,
          ),
        ),
        child: _isUploadingImage
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF6B4EFF)),
                    SizedBox(height: 10),
                    Text('Uploading...', style: TextStyle(color: Color(0xFF6B4EFF))),
                  ],
                ),
              )
            : _pickedImage != null && _uploadedImageUrl != null
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(
                          _pickedImage!,
                          fit: BoxFit.contain,
                          height: 130,
                          width: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text('Uploaded', style: TextStyle(color: Colors.white, fontSize: 12)),
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
                          size: 40, color: const Color(0xFF6B4EFF).withOpacity(0.6)),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap to pick from Gallery',
                        style: TextStyle(color: Color(0xFF6B4EFF), fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'PNG, JPG supported',
                        style: TextStyle(color: Color(0xFFB0B3C6), fontSize: 12),
                      ),
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
          const Text('Preview: ', style: TextStyle(color: Color(0xFF4A4E69), fontSize: 13)),
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
              child: Image.network(
                url,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, color: Colors.grey),
              ),
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
      onChanged: (_) => setState(() {}), // for logo URL preview update
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
