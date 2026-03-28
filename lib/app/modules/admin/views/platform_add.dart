// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/admin_controller.dart';

// class AddPlatformView extends StatelessWidget {
//   AddPlatformView({super.key});

//   final controller = Get.put(AdminController());

//   final nameCtrl = TextEditingController();
//   final logoCtrl = TextEditingController();
//   final linkCtrl = TextEditingController();
//   final colorCtrl = TextEditingController(text: "#ffffff");

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Platform")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameCtrl,
//               decoration: const InputDecoration(labelText: "Platform Name"),
//             ),
//             TextField(
//               controller: logoCtrl,
//               decoration: const InputDecoration(labelText: "Logo URL"),
//             ),
//             TextField(
//               controller: linkCtrl,
//               decoration: const InputDecoration(labelText: "Affiliate Link"),
//             ),
//             TextField(
//               controller: colorCtrl,
//               decoration: const InputDecoration(labelText: "Color (Hex)"),
//             ),
//             const SizedBox(height: 20),
//             Obx(() => ElevatedButton(
//                   onPressed: controller.isLoading.value
//                       ? null
//                       : () {
//                           controller.addPlatform({
//                             "name": nameCtrl.text,
//                             "logo": logoCtrl.text,
//                             "link": linkCtrl.text,
//                             "color": colorCtrl.text,
//                           });
//                         },
//                   child: controller.isLoading.value
//                       ? const CircularProgressIndicator()
//                       : const Text("Add Platform"),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:deal_bridge_app/app/data/models/platform_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final TextEditingController _colorCtrl =
      TextEditingController(text: "#ffffff");

  @override
  void dispose() {
    _nameCtrl.dispose();
    _logoCtrl.dispose();
    _linkCtrl.dispose();
    _colorCtrl.dispose();
    super.dispose();
  }

  // void _submitPlatform() async {
  //   if (_nameCtrl.text.isEmpty || _linkCtrl.text.isEmpty) {
  //     Get.snackbar(
  //       'Error',
  //       'Name and Link are required!',
  //       backgroundColor: Colors.redAccent,
  //       colorText: Colors.white,
  //     );
  //     return;
  //   }

  //   final data = {
  //     "name": _nameCtrl.text.trim(),
  //     "logo": _logoCtrl.text.trim().isEmpty
  //         ? "https://upload.wikimedia.org/wikipedia/commons/0/0d/Myntra_logo.png"
  //         : _logoCtrl.text.trim(),
  //     "link": _linkCtrl.text.trim(),
  //     "color": _colorCtrl.text.trim(),
  //   };

  //   final success = await controller.addPlatform(data);

  //   if (success) {
  //     Get.back();
  //     Get.snackbar(
  //       'Success',
  //       'Platform Added!',
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: const Color(0xFF4CAF50),
  //       colorText: Colors.white,
  //       margin: const EdgeInsets.all(20),
  //       borderRadius: 16,
  //     );
  //   } else {
  //     Get.snackbar(
  //       'Error',
  //       'Failed to add platform',
  //       backgroundColor: Colors.redAccent,
  //       colorText: Colors.white,
  //     );
  //   }
  // }

  void _submitPlatform() async {
    print("🚀 Submit clicked");

    if (_nameCtrl.text.isEmpty || _linkCtrl.text.isEmpty) {
      print("❌ Validation failed");
      Get.snackbar(
        'Error',
        'Name and Link are required!',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final data = {
      "name": _nameCtrl.text.trim(),
      "logo": _logoCtrl.text.trim().isEmpty
          ? "https://upload.wikimedia.org/wikipedia/commons/0/0d/Myntra_logo.png"
          : _logoCtrl.text.trim(),
      "link": _linkCtrl.text.trim(),
      "color": _colorCtrl.text.trim(),
    };

    print("📤 Sending Data: $data");

    final success = await controller.addPlatform(data);

    print("✅ API Response: $success");

    if (success) {
      print("🎉 Platform Added");
      Get.back();
      Get.snackbar("Success", "Platform Added!");
    } else {
      print("❌ Failed to add platform");
      Get.snackbar("Error", "Failed to add platform");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: const Text(
          'Add Platform',
          style: TextStyle(
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
                _buildSectionTitle('Platform Name'),
                _buildTextField(
                  hint: 'e.g. Myntra',
                  icon: Icons.store_rounded,
                  controller: _nameCtrl,
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Logo URL'),
                _buildTextField(
                  hint: 'https://logo.png',
                  icon: Icons.image_rounded,
                  controller: _logoCtrl,
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Affiliate Link'),
                _buildTextField(
                  hint: 'https://affiliate-link',
                  icon: Icons.link_rounded,
                  controller: _linkCtrl,
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Theme Color (Hex)'),
                _buildTextField(
                  hint: '#ffffff',
                  icon: Icons.color_lens_rounded,
                  controller: _colorCtrl,
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: Obx(() => ElevatedButton(
                        onPressed:
                            controller.isLoading.value ? null : _submitPlatform,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B4EFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Save Platform',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
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
