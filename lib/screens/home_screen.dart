import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grades/screens/course_list_screen.dart';
import 'package:grades/screens/feed_screen.dart';
import 'package:grades/utilities/dots_indicator.dart';

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

  var kDuration = const Duration(milliseconds: 300);

  var kCurve = Curves.ease;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        PageView.builder(
          controller: controller,
          itemCount: pages.length,
          itemBuilder: (context, position) => pages[position],
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            // color: Colors.grey[800].withOpacity(0.5),
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: DotsIndicator(
                controller: controller,
                itemCount: pages.length,
                onPageSelected: (int page) {
                  controller.animateToPage(
                    page,
                    duration: kDuration,
                    curve: kCurve,
                  );
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
