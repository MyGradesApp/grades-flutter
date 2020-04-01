import 'package:flutter/material.dart';
import 'package:grades/screens/course_list_screen.dart';
import 'package:grades/screens/feed_screen.dart';
import 'package:grades/screens/upcoming_screen.dart';
import 'package:grades/utilities/helpers/update.dart';
import 'package:grades/widgets/page_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Initial page state
  String title = 'COURSES';
  int previous = -1;
  List<Widget> pages = [
    FeedScreen(),
    CourseListScreen(),
    UpcomingScreen(),
  ];

  bool updateAvailable = false;

  var kDuration = const Duration(milliseconds: 300);

  var kCurve = Curves.ease;

  PageController controller = PageController(initialPage: 1);

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      var updateAvailableResult = await checkUpdateAvailable();
      setState(() {
        updateAvailable = updateAvailableResult;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Stack(children: <Widget>[
        Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            title: Text(title),
            leading: IconButton(
              tooltip: 'Profile',
              icon: Icon(
                Icons.person,
              ),
              onPressed: () => Navigator.pushNamed(context, '/academic_info'),
            ),
            actions: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  IconButton(
                    tooltip: 'Settings',
                    icon: Icon(Icons.settings),
                    onPressed: () => Navigator.pushNamed(context, '/settings'),
                  ),
                  if (updateAvailable)
                    Positioned(
                      left: 8,
                      top: 9,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                ],
              )
            ],
          ),
          body: PageView.builder(
            controller: controller,
            itemCount: pages.length,
            onPageChanged: (page) {
              setState(() {
                if (page == 0) {
                  title = 'RECENT';
                } else if (page == 2) {
                  title = 'UPCOMING';
                } else {
                  title = 'COURSES';
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
              child: PageIndicator(
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
        )
      ]),
    );
  }
}
