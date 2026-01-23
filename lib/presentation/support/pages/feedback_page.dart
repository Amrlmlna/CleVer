import 'package:flutter/material.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../../core/services/analytics_service.dart';

// Note: In a real app, you would inject a repository to handle the API call.
// For this MVP, we will use a simple inline HTTP call or just mock it.
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  String _feedbackType = 'Saran Fitur';
  final _msgController = TextEditingController();
  final _contactController = TextEditingController();
  bool _isLoading = false;

  final List<String> _types = ['Lapor Bug', 'Saran Fitur', 'Pertanyaan', 'Lainnya'];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    // Simulate API Delay
    await Future.delayed(const Duration(seconds: 1));

    // Try to send to backend (if running)
    // Replace IP with your backend URL
    try {
      final response = await http.post(
        Uri.parse('https://cvmaster-chi.vercel.app/api/feedback'), // Production URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'type': _feedbackType,
          'message': _msgController.text,
          'contact': _contactController.text,
        }),
      );
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        debugPrint('Feedback API Error: ${response.statusCode}');
        // We proceed anyway for UX in this demo
      }
    } catch (e) {
      debugPrint('Feedback Network Error: $e');
      // Proceed silently
    }

    // Track Event
    AnalyticsService().trackEvent('feedback_sent', properties: {
      'type': _feedbackType,
    });

    if (mounted) {
      setState(() => _isLoading = false);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Terima Kasih!'),
          content: const Text('Masukan Anda sangat berharga buat pengembangan CV Master.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Close Dialog
                Navigator.pop(context); // Back to Help Page
              },
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _msgController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kirim Masukan'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apa yang bisa kami bantu?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black, fontFamily: 'Outfit'),
            ),
            const SizedBox(height: 8),
            Text(
              'Ceritakan pengalamanmu atau laporkan masalah yang kamu temui.',
              style: TextStyle(color: Colors.grey[500], fontSize: 16),
            ),
            const SizedBox(height: 32),

            // White Card Form
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Theme(
                data: Theme.of(context).copyWith(brightness: Brightness.light), // Force Light inputs
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Type Dropdown
                      const Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                           border: Border.all(color: Colors.grey.shade300),
                           borderRadius: BorderRadius.circular(16),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _feedbackType,
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            style: const TextStyle(color: Colors.black, fontSize: 16),
                            items: _types.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                            onChanged: (val) => setState(() => _feedbackType = val!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
    
                      // Message
                      CustomTextFormField(
                        controller: _msgController,
                        labelText: 'Pesan / Detail',
                        maxLines: 5,
                        validator: (v) => v!.isEmpty ? 'Tulis sesuatu dong' : null,
                      ),
                      const SizedBox(height: 24),
    
                      // Contact (Optional)
                      CustomTextFormField(
                        controller: _contactController,
                        labelText: 'Email / WhatsApp (Opsional)',
                        hintText: 'Biar kami bisa bales...',
                      ),
    
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // Contrast on White Card
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            elevation: 0,
                          ),
                          child: _isLoading 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Kirim Masukan', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
