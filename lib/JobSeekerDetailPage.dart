import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // استيراد الحزمة اللازمة

class JobSeekerDetailPage extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String cv;
  final String image;

  const JobSeekerDetailPage({super.key, 
    required this.name,
    required this.email,
    required this.phone,
    required this.cv,
    required this.image,
  });

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ النص إلى الحافظة!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.red[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Image.asset(
                image,
                width: 400,
                height: 400,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Name: $name',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: Text('Email: $email')),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyToClipboard(context, email), // تمرير context
                ),
              ],
            ),
            Row(
              children: [
                Expanded(child: Text('Phone: $phone')),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () => _copyToClipboard(context, phone), // تمرير context
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('CV: $cv'),
          ],
        ),
      ),
    );
  }
}