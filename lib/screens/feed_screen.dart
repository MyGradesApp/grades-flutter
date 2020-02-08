import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grades/models/current_session.dart';
import 'package:grades/models/grade_persistence.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:grades/utilities/stacked_future_builder.dart';
import 'package:grades/widgets/class_list_item_widget.dart';
import 'package:grades/widgets/loader_widget.dart';
import 'package:grades/widgets/refreshable_error_message.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';
import 'package:sis_loader/sis_loader.dart';

class FeedScreen extends StatefulWidget {
  FeedScreen({Key key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Map<String, String> _newgrades = {};

  // Future<List<Course>> _init() {
  //   if (_newgrades == null) {
  //     _newgrades = _setup();
  //   }
  //   return _newgrades;
  // }

  // Future<List<Course>> _setup() async {
  //   var courses = await Provider.of<CurrentSession>(context, listen: false)
  //       .sisLoader
  //       .getCourses();

  //   unawaited(
  //     Future.wait(courses.map((course) async {
  //       var grades = await course.getGrades();
  //       setState(() {
  //         _currentGrades[course.courseName] =
  //             jsonEncode(grades, toEncodable: (v) => v.toString());
  //       });
  //     })),
  //   );
  //   return courses;
  // }

  // Future<List<Course>> _callback() async {
  //   return Provider.of<CurrentSession>(context, listen: false)
  //       .sisLoader
  //       .getCourses(force: true);
  // }

  @override
  Widget build(BuildContext context) {
    final gradePersistence = Provider.of<GradePersistence>(context);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            title: const Text('Recent'),
            leading: IconButton(
              tooltip: "Profile",
              icon: Icon(
                Icons.person,
              ),
              onPressed: () => Navigator.pushNamed(context, '/academic_info'),
            )),
        body: StackedFutureBuilder<List<Course>>(
          // future: _init(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                // onRefresh: _callback,
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var course = snapshot.data[index];
                    return ClassListItemWidget(
                      onTap: () {
                        Navigator.pushNamed(context, '/course_grades',
                            arguments: course);
                      },
                      course: course.courseName,
                      letterGrade: course.gradeLetter,
                      teacher: course.teacherName,
                      percent: course.gradePercent,
                    );
                  },
                ),
              );
            }
            return Center(
              child: LoaderWidget(),
            );
          },
        ),
      ),
    );
  }
}
