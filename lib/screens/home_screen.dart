import 'package:flutter/material.dart';
import 'package:grades/screens/course_list_screen.dart';
import 'package:grades/screens/feed_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

PageController controller = PageController(initialPage: 1);

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> pages = [
    FeedScreen(),
    CourseListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      itemCount: pages.length,
      itemBuilder: (context, position) => pages[position],
    );
  }
}
