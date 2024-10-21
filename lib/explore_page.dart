import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String? selectedCategory; // لتتبع الفئة المحددة

  final List<Map<String, dynamic>> courses = [
    {'title': 'Course 1', 'description': 'Description of Course 1', 'price': 'LYD. 500', 'image': 'images/im.png', 'category': 'Programming'},
    {'title': 'Course 2', 'description': 'Description of Course 2', 'price': 'LYD. 600', 'image': 'images/im.png', 'category': 'Design'},
    {'title': 'Course 3', 'description': 'Description of Course 3', 'price': 'LYD. 700', 'image': 'images/im1.png', 'category': 'Cybersecurity'},
    // يمكنك إضافة المزيد من الكورسات هنا مع تحديد الفئة
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Courses', style: TextStyle(color: Colors.white)),
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
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _filterButtonsWithImages(),
              const SizedBox(height: 16),
              _sortDropdown(),
              const SizedBox(height: 16),
              _coursesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterButtonsWithImages() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterButton('All', Icons.list), // استخدام أيقونة بدلاً من الصورة
          const SizedBox(width: 8),
          _filterButton('Programming', 'images/cod.png'),
          const SizedBox(width: 8),
          _filterButton('Design', 'images/dis.png'),
          const SizedBox(width: 8),
          _filterButton('Cybersecurity', 'images/sy.png'),
          const SizedBox(width: 8),
          _filterButton('App Development', 'images/app.png'),
        ],
      ),
    );
  }

  Widget _filterButton(String title, dynamic icon) {
    bool isSelected = selectedCategory == title; // تحقق مما إذا كانت الفئة محددة

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = (isSelected && title == 'All') ? null : title; // تغيير الفئة المحددة
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.red[100] : Colors.white, // تغيير اللون عند التحديد
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Text(title, style: const TextStyle(color: Colors.black)),
            const SizedBox(width: 8),
            // عرض الأيقونة أو الصورة
            icon is IconData
                ? Icon(icon, size: 40) // إذا كانت أيقونة
                : SizedBox(
              width: 40,
              height: 40,
              child: ClipOval(
                child: Image.asset(
                  icon,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sortDropdown() {
    return DropdownButton<String>(
      isExpanded: true,
      hint: const Text('Sort by'),
      items: <String>[
        'Popular',
        'Newest',
        'Price: Low to High',
        'Price: High to Low'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        // Add sorting logic here
      },
    );
  }

  Widget _coursesList() {
    // تصفية الكاردات بناءً على الفئة المحددة
    final filteredCourses = selectedCategory == null || selectedCategory == 'All'
        ? courses
        : courses.where((course) => course['category'] == selectedCategory).toList();

    return Column(
      children: filteredCourses.map<Widget>((course) {
        return _courseCard(course['title'], course['description'], course['price'], course['image']);
      }).toList(),
    );
  }

  Widget _courseCard(String title, String description, String price, String imageUrl) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(description),
                    const SizedBox(height: 8),
                    Text(
                      price,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}