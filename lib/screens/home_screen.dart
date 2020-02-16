import 'package:flutter/material.dart';
import 'package:grades/screens/course_list_screen.dart';
import 'package:grades/screens/feed_screen.dart';
import 'package:grades/utilities/dots_indicator.dart';
import 'package:grades/utilities/updated_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

PageController controller = PageController(initialPage: 0);

class _HomeScreenState extends State<HomeScreen> {
  // Initial page state
  String title = "COURSES";
  int previous = -1;
  List<Widget> pages = [
    CourseListScreen(),
    FeedScreen(),
  ];

  var kDuration = const Duration(milliseconds: 300);

  var kCurve = Curves.ease;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      var hasShownUpdateScreen = prefs.getBool("hasShownUpdateScreen2");
      if (hasShownUpdateScreen == null || !hasShownUpdateScreen) {
        prefs.setBool("hasShownUpdateScreen2", true);
        Future.microtask(() {
          showUpdatedDialog(context);
        });
      }
    });
  }

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
        drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Theme.of(context)
                .accentColor, //This will change the drawer background to blue.
            //other styles
          ),
          child: Drawer(
            child: ListView(
              children: <Widget>[
                //
                UserAccountsDrawerHeader(
                  accountName: Text("Seth Goldin"),
                  accountEmail: Text("s27097328@stu.palmbeachschools.org"),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Theme.of(context).accentColor,
                    // Theme.of(context).platform == TargetPlatform.iOS
                    //     ? Colors.blue
                    //     : Colors.white,
                    child: Text(
                      "S",
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    ),
                  ),
                ),

                ListTile(
                    leading: Icon(Icons.assignment, color: Colors.white),
                    title: Text(
                      "Grades",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        // fontWeight: FontWeight.bold,
                      ),
                    )),
                ListTile(
                    leading: Icon(Icons.person, color: Colors.white),
                    title: Text(
                      "Academic Information",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        // fontWeight: FontWeight.bold,
                      ),
                    )),
                ListTile(
                    leading: Icon(Icons.settings, color: Colors.white),
                    title: Text(
                      "Settings",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        // fontWeight: FontWeight.bold,
                      ),
                    )),
              ],
            ),
          ),
        ),
        body: PageView.builder(
          controller: controller,
          itemCount: pages.length,
          onPageChanged: (page) {
            setState(() {
              if (page == 1) {
                title = "RECENT";
              } else {
                title = "COURSES";
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
      )
    ]);
  }
}
