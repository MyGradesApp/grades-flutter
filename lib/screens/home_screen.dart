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
  // Initial page state
  String title = "Courses";
  int previous = -1;
  List<Widget> pages = [
    FeedScreen(),
    CourseListScreen(),
  ];

  var kDuration = const Duration(milliseconds: 300);

  var kCurve = Curves.ease;

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text(title),
          leading: IconButton(
            tooltip: "Profile",
            icon: Icon(
              Icons.person,
            ),
            onPressed: () => Navigator.pushNamed(context, '/academic_info'),
          ),
          actions: <Widget>[
            IconButton(
              tooltip: "Settings",
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            )
          ],
        ),
        body: PageView.builder(
          controller: controller,
          itemCount: pages.length,
          onPageChanged: (page) {
            setState(() {
              if (page == 0) {
                title = "Recent";
              } else {
                title = "Courses";
              }
            });
          },
          itemBuilder: (context, position) => pages[position],
        ),
      ),
      Positioned.fill(
        top: null,
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
    ]);
  }
}
