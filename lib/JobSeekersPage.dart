import 'package:flutter/material.dart';
import 'JobSeekerDetailPage.dart';

class JobSeekersPage extends StatefulWidget {
  const JobSeekersPage({super.key});

  @override
  _JobSeekersPageState createState() => _JobSeekersPageState();
}

class _JobSeekersPageState extends State<JobSeekersPage> {
  final List<Map<String, dynamic>> jobSeekers = [
    {
      'name': 'Alice Smith',
      'email': 'alice@example.com',
      'phone': '123-456-7890',
      'cv': 'Link to CV',
      'image': 'images/ib.png',
      'courses': ['App Development', 'Cyber Security'],
      'category': 'Graduate',
      'city': 'Misrata',
      'age': 24,
      'university': 'Information Technology College Misrata',
    },
    {
      'name': 'Ali Ayad',
      'email': 'ali@example.com',
      'phone': '987-654-3210',
      'cv': 'Link to CV',
      'image': 'images/ali.png',
      'courses': ['Cloud Computing'],
      'category': 'Student',
      'city': 'Tripoli',
      'age': 22,
      'university': 'Information Technology College Misrata',
    },
    {
      'name': 'Mohamed Omar',
      'email': 'mohamed@example.com',
      'phone': '555-123-4567',
      'cv': 'Link to CV',
      'image': 'images/ib.png',
      'courses': ['Data Science'],
      'category': 'Graduate',
      'city': 'Benghazi',
      'age': 26,
      'university': 'Information Technology College Benghazi',
    },
  ];

  List<String> selectedCourses = [];
  bool isGraduate = false;
  String selectedCity = 'All Cities';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Job Seekers',
          style: TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF980E0E), // اللون الأحمر الفاتح
                Color(0xFF330000), // اللون الأحمر الداكن
              ],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildCityFilters(),
          _buildFilters(),
          Expanded(child: _buildJobSeekersList()),
        ],
      ),
    );
  }

  Widget _buildCityFilters() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.grey[200],
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ['All Cities', 'Misrata', 'Tripoli', 'Benghazi'].map((city) {
            final isSelected = selectedCity == city;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedCity = city;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF980E0E) : Colors.white,
                  border: Border.all(color: isSelected ? Colors.white : const Color(0xFF980E0E)),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: const EdgeInsets.only(right: 10),
                child: Text(
                  city,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF980E0E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        _buildCourseFilters(),
        _buildGraduateCheckbox(),
      ],
    );
  }

  Widget _buildCourseFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ['App Development', 'Cyber Security', 'Cloud Computing'].map((course) {
          final isSelected = selectedCourses.contains(course);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedCourses.remove(course);
                } else {
                  selectedCourses.add(course);
                }
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF980E0E) : Colors.white,
                border: Border.all(color: isSelected ? Colors.white : const Color(0xFF980E0E)),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: const EdgeInsets.only(right: 10),
              child: Text(
                course,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF980E0E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGraduateCheckbox() {
    return CheckboxListTile(
      title: const Text("Graduate"),
      value: isGraduate,
      onChanged: (bool? value) {
        setState(() {
          isGraduate = value ?? false;
        });
      },
    );
  }

  Widget _buildJobSeekersList() {
    final filteredJobSeekers = jobSeekers.where((seeker) {
      if (selectedCity != 'All Cities' && seeker['city'] != selectedCity) return false;
      bool matchesCourses = selectedCourses.isEmpty || seeker['courses'].any((course) => selectedCourses.contains(course));
      bool matchesGraduate = isGraduate ? seeker['category'] == 'Graduate' : true;
      return matchesCourses && matchesGraduate;
    }).toList();

    return ListView.builder(
      itemCount: filteredJobSeekers.length,
      itemBuilder: (context, index) {
        final seeker = filteredJobSeekers[index];
        return Card(
          margin: const EdgeInsets.all(10),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        seeker['city'],
                        style: const TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (seeker['category'] == 'Graduate') ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.school,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          seeker['image'] ?? 'images/default.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              seeker['name'],
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text('University: ${seeker['university']}'),
                            Text('Age: ${seeker['age']}'),
                            const SizedBox(height: 5),
                            Wrap(
                              spacing: 8,
                              children: seeker['courses'].map<Widget>((course) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.red[100],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    course,
                                    style: TextStyle(color: Colors.red[800], fontWeight: FontWeight.bold),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF980E0E),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobSeekerDetailPage(
                              name: seeker['name'],
                              email: seeker['email'] ?? "غير متوفر",
                              phone: seeker['phone'] ?? "غير متوفر",
                              cv: seeker['cv'] ?? "غير متوفر",
                              image: seeker['image'] ?? 'images/ib.png',
                            ),
                          ),
                        );
                      },
                      child: const Text('View More'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}