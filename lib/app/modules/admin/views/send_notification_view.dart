import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:deal_bridge_app/app/data/services/api_service.dart';

class SendNotificationView extends StatefulWidget {
  const SendNotificationView({Key? key}) : super(key: key);

  @override
  State<SendNotificationView> createState() => _SendNotificationViewState();
}

class _SendNotificationViewState extends State<SendNotificationView> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  final _apiService = ApiService();

  bool _isSending = false;

  // Quick templates
  final List<Map<String, String>> _templates = [
    {
      'label': '🔥 New Deal',
      'title': '🔥 New Deal Alert!',
      'body': 'Check out today\'s hottest deals on DealBridge!'
    },
    {
      'label': '⚡ Flash Sale',
      'title': '⚡ Flash Sale Live Now!',
      'body': 'Limited time offer — grab it before it\'s gone!'
    },
    {
      'label': '🎉 Offer',
      'title': '🎉 Special Offer Just For You!',
      'body': 'Exclusive deals are waiting for you on DealBridge.'
    },
    {
      'label': '📦 New Product',
      'title': '📦 New Products Added!',
      'body': 'Fresh deals just added. Open the app to explore!'
    },
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendNotification() async {
    final title = _titleCtrl.text.trim();
    final body = _bodyCtrl.text.trim();

    if (title.isEmpty || body.isEmpty) {
      Get.snackbar('Error', 'Title aur Body dono required hain!',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => _isSending = true);

    try {
      final success = await _apiService.sendNotification(title, body);
      if (success) {
        _titleCtrl.clear();
        _bodyCtrl.clear();
        Get.snackbar(
          'Sent ✅',
          'Notification sabhi users ko bhej di gayi!',
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar('Failed ❌', 'Notification send nahi ho saki. Try again.',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        title: const Text(
          'Send Notification',
          style: TextStyle(
              color: Color(0xFF1E212D), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E212D)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B4EFF), Color(0xFF907CFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B4EFF).withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.notifications_active_rounded,
                      color: Colors.white, size: 40),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Push Notification',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Sabhi users ko ek saath notification bhejein',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Quick Templates
            const _SectionLabel('Quick Templates'),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _templates.map((t) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _titleCtrl.text = t['title']!;
                          _bodyCtrl.text = t['body']!;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0EDFF),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: const Color(0xFF6B4EFF).withOpacity(0.3)),
                        ),
                        child: Text(
                          t['label']!,
                          style: const TextStyle(
                              color: Color(0xFF6B4EFF),
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 28),

            // Form Card
            Container(
              padding: const EdgeInsets.all(24),
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
                  // Title
                  const _SectionLabel('Notification Title'),
                  const SizedBox(height: 8),
                  _buildField(
                    controller: _titleCtrl,
                    hint: 'e.g. 🔥 New Deal Alert!',
                    icon: Icons.title_rounded,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 20),

                  // Body
                  const _SectionLabel('Notification Message'),
                  const SizedBox(height: 8),
                  _buildField(
                    controller: _bodyCtrl,
                    hint: 'e.g. Check out today\'s hottest deals...',
                    icon: Icons.message_rounded,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 28),

                  // Preview Card
                  _buildPreviewCard(),
                  const SizedBox(height: 28),

                  // Send Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isSending ? null : _sendNotification,
                      icon: _isSending
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5))
                          : const Icon(Icons.send_rounded, color: Colors.white),
                      label: Text(
                        _isSending ? 'Sending...' : 'Send to All Users',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B4EFF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    final title = _titleCtrl.text.trim();
    final body = _bodyCtrl.text.trim();
    if (title.isEmpty && body.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('Preview'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: const Color(0xFF6B4EFF).withOpacity(0.15)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF6B4EFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_offer_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.isEmpty ? 'Notification Title' : title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF1E212D)),
                    ),
                    if (body.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        body,
                        style: const TextStyle(
                            fontSize: 13, color: Color(0xFF6B7280)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB0B3C6)),
        prefixIcon: Icon(icon, color: const Color(0xFF6B4EFF).withOpacity(0.7)),
        filled: true,
        fillColor: const Color(0xFFF9FAFF),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide:
              const BorderSide(color: Color(0xFF6B4EFF), width: 1.5),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4A4E69)),
    );
  }
}
