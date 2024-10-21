import 'package:flutter/material.dart';

class JobDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String salary;
  final String imageUrl;

  const JobDetailPage({super.key, 
    required this.title,
    required this.description,
    required this.salary,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.red[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Salary: $salary', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            Text(description),
          ],
        ),
      ),
    );
  }
}