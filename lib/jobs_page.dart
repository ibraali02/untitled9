import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Job Listings',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const JobsPage(),
    );
  }
}

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  String? selectedCategory;
  double minSalary = 0;
  double maxSalary = 7000;
  List<Map<String, dynamic>> jobs = [];
  final picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _fetchJobs();
  }

  Future<void> _checkPermissions() async {
    if (await Permission.camera.request().isGranted &&
        await Permission.storage.request().isGranted) {
      // الأذونات ممنوحة
    } else {
      // الأذونات مرفوضة
    }
  }

  Future<void> _fetchJobs() async {
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('jobs').get();
    final List<Map<String, dynamic>> fetchedJobs = result.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();

    setState(() {
      jobs = fetchedJobs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Job Listings',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF980E0E),
                Color(0xFF330000),
              ],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategories(),
              const SizedBox(height: 20),
              _buildSalaryRangeSlider(),
              const SizedBox(height: 20),
              _jobsList(context),
              _buildAddJobButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _categoryButton('All'),
          const SizedBox(width: 8),
          _categoryButton('Full Time'),
          const SizedBox(width: 8),
          _categoryButton('Part Time'),
          const SizedBox(width: 8),
          _categoryButton('Remote'),
          const SizedBox(width: 8),
          _categoryButton('Productivity-Based'),
        ],
      ),
    );
  }

  Widget _categoryButton(String title) {
    bool isSelected = selectedCategory == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = (isSelected && title == 'All') ? null : title;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red[800]!),
          borderRadius: BorderRadius.circular(30),
          color: isSelected ? Colors.red[100] : Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(title, style: TextStyle(color: Colors.red[800], fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSalaryRangeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Salary Range: LYD. ${minSalary.toInt()} - LYD. ${maxSalary.toInt()}',
          style: const TextStyle(fontSize: 16),
        ),
        RangeSlider(
          values: RangeValues(minSalary, maxSalary),
          min: 0,
          max: 7000,
          divisions: 70,
          labels: RangeLabels('${minSalary.toInt()}', '${maxSalary.toInt()}'),
          activeColor: Colors.red[800],
          inactiveColor: Colors.red[200],
          onChanged: (RangeValues values) {
            setState(() {
              minSalary = values.start;
              maxSalary = values.end;
            });
          },
        ),
      ],
    );
  }

  Widget _jobsList(BuildContext context) {
    final filteredJobs = jobs.where((job) {
      final isCategoryMatch = selectedCategory == null || selectedCategory == 'All' || job['category'] == selectedCategory;
      final isSalaryMatch = job['salary'] >= minSalary && job['salary'] <= maxSalary;
      return isCategoryMatch && isSalaryMatch;
    }).toList();

    return Column(
      children: filteredJobs.map<Widget>((job) {
        return _jobCard(context, job);
      }).toList(),
    );
  }

  Widget _jobCard(BuildContext context, Map<String, dynamic> job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (job['imagePath'] != null && File(job['imagePath']).existsSync())
              Image.file(
                File(job['imagePath']),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(job['description']),
                  const SizedBox(height: 8),
                  Text('LYD. ${job['salary'].toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(job['category'], style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddJobButton() {
    return GestureDetector(
      onTap: () {
        _showAddJobDialog();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF980E0E),
              Color(0xFF330000),
            ],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white),
            SizedBox(width: 10),
            Text('Add Job', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showAddJobDialog() async {
    String title = '';
    String description = '';
    double salary = 0;
    String category = 'Full Time';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Job'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      title = value;
                    },
                    decoration: const InputDecoration(labelText: 'Job Title'),
                  ),
                  TextField(
                    onChanged: (value) {
                      description = value;
                    },
                    decoration: const InputDecoration(labelText: 'Job Description'),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      salary = double.tryParse(value) ?? 0;
                    },
                    decoration: const InputDecoration(labelText: 'Salary'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 50,
                      );
                      if (pickedFile != null) {
                        setState(() {
                          _image = File(pickedFile.path);
                        });
                      }
                    },
                    child: const Text('Upload Image'),
                  ),
                  if (_image != null) Image.file(_image!, width: 100, height: 100),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('jobs').add({
                  'title': title,
                  'description': description,
                  'salary': salary,
                  'category': category,
                  'imagePath': _image?.path,
                });

                Navigator.of(context).pop();
                _fetchJobs();
              },
              child: const Text('Add Job'),
            ),
          ],
        );
      },
    );
  }
}
