import 'package:flutter/material.dart';
import 'notifications_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> _courses = [
    {
      'title': 'Bootcamp of Cloud Computing',
      'category': 'Finance',
      'price': 'LYD. 500',
      'learners': '1,882',
      'imagePath': 'images/im.png',
    },
    {
      'title': 'Data Analysis with Python',
      'category': 'Data Science',
      'price': 'LYD. 600',
      'learners': '1,200',
      'imagePath': 'images/im.png',
    },
    {
      'title': 'Introduction to Flutter',
      'category': 'Development',
      'price': 'LYD. 400',
      'learners': '1,000',
      'imagePath': 'images/im.png',
    },
  ];

  void _addCourse(Map<String, String> course) {
    setState(() {
      _courses.add(course);
    });
  }

  void _editCourse(int index, Map<String, String> newCourse) {
    setState(() {
      _courses[index] = newCourse;
    });
  }

  void _deleteCourse(int index) {
    setState(() {
      _courses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _customAppBar(context),
          Padding(
            padding: const EdgeInsets.only(top: 200.0), // تعديل المسافة لتجنب التداخل
            child: ListView(
              children: [
                _searchField(),
                const SizedBox(height: 20),
                _continueLearningSection(),
                const SizedBox(height: 20),
                _recentlyAddedSection(),
                const SizedBox(height: 20),
                _addCourseButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customAppBar(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.38,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF980E0E), // اللون الأحمر الفاتح
            Color(0xFF330000), // اللون الأحمر الداكن
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Welcome, Jason 👋',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NotificationsPage()),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingsPage()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'What do you want to learn?',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search...',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }

  Widget _continueLearningSection() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset('images/im1.png', height: 90, width: 80, fit: BoxFit.cover),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('APP', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 5),
                  const Text('Bootcamp of Mobile App From Scratch', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                    value: 0.75,
                    backgroundColor: Colors.grey,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFC02626)),
                  ),
                  const SizedBox(height: 10),
                  const Text('23 of 33 Lessons • 75% completed', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recentlyAddedSection() {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          return _recentlyAddedCard(index);
        },
      ),
    );
  }

  Widget _recentlyAddedCard(int index) {
    final course = _courses[index];
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(right: 16),
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(course['imagePath']!, height:55, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text(course['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(course['category']!, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Text(course['price']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text('${course['learners']} learners', style: const TextStyle(color: Colors.grey)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    _showEditCourseDialog(index);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteCourse(index);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _addCourseButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _showAddCourseDialog();
        },
        child: const Text('Add Course'),
      ),
    );
  }

  void _showAddCourseDialog() {
    String title = '';
    String category = '';
    String price = '';
    String learners = '';
    String imagePath = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  title = value;
                },
                decoration: const InputDecoration(labelText: 'Course Title'),
              ),
              TextField(
                onChanged: (value) {
                  category = value;
                },
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                onChanged: (value) {
                  price = value;
                },
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              TextField(
                onChanged: (value) {
                  learners = value;
                },
                decoration: const InputDecoration(labelText: 'Number of Learners'),
              ),
              TextField(
                onChanged: (value) {
                  imagePath = value;
                },
                decoration: const InputDecoration(labelText: 'Image Path'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                _addCourse({
                  'title': title,
                  'category': category,
                  'price': price,
                  'learners': learners,
                  'imagePath': imagePath,
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditCourseDialog(int index) {
    String title = _courses[index]['title']!;
    String category = _courses[index]['category']!;
    String price = _courses[index]['price']!;
    String learners = _courses[index]['learners']!;
    String imagePath = _courses[index]['imagePath']!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  title = value;
                },
                decoration: InputDecoration(
                  labelText: 'Course Title',
                  hintText: _courses[index]['title'],
                ),
              ),
              TextField(
                onChanged: (value) {
                  category = value;
                },
                decoration: InputDecoration(
                  labelText: 'Category',
                  hintText: _courses[index]['category'],
                ),
              ),
              TextField(
                onChanged: (value) {
                  price = value;
                },
                decoration: InputDecoration(
                  labelText: 'Price',
                  hintText: _courses[index]['price'],
                ),
              ),
              TextField(
                onChanged: (value) {
                  learners = value;
                },
                decoration: InputDecoration(
                  labelText: 'Number of Learners',
                  hintText: _courses[index]['learners'],
                ),
              ),
              TextField(
                onChanged: (value) {
                  imagePath = value;
                },
                decoration: InputDecoration(
                  labelText: 'Image Path',
                  hintText: _courses[index]['imagePath'],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                _editCourse(index, {
                  'title': title,
                  'category': category,
                  'price': price,
                  'learners': learners,
                  'imagePath': imagePath,
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
