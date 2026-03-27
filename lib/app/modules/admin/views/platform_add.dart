import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';

class AddPlatformScreen extends StatelessWidget {
  AddPlatformScreen({super.key});

  final controller = Get.put(AdminController());

  final nameCtrl = TextEditingController();
  final logoCtrl = TextEditingController();
  final linkCtrl = TextEditingController();
  final colorCtrl = TextEditingController(text: "#ffffff");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Platform")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Platform Name"),
            ),
            TextField(
              controller: logoCtrl,
              decoration: const InputDecoration(labelText: "Logo URL"),
            ),
            TextField(
              controller: linkCtrl,
              decoration: const InputDecoration(labelText: "Affiliate Link"),
            ),
            TextField(
              controller: colorCtrl,
              decoration: const InputDecoration(labelText: "Color (Hex)"),
            ),
            const SizedBox(height: 20),
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          controller.addPlatform({
                            "name": nameCtrl.text,
                            "logo": logoCtrl.text,
                            "link": linkCtrl.text,
                            "color": colorCtrl.text,
                          });
                        },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text("Add Platform"),
                )),
          ],
        ),
      ),
    );
  }
}
