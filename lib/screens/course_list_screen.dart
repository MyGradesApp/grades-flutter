import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grades/models/current_session.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:grades/widgets/class_list_item_widget.dart';
import 'package:grades/widgets/loader_widget.dart';
import 'package:grades/widgets/refreshable_error_message.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sis_loader/sis_loader.dart';

class CourseListScreen extends StatefulWidget {
  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  Future<List<Course>> _courses;
  bool _complete = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_complete) {
      _fetchCourses();
    }
  }

  void _fetchCourses() {
    _courses = Provider.of<CurrentSession>(context, listen: false)
        .sisLoader
        .getCourses()
        .then((courses) {
      setState(() {
        _complete = true;
      });
      return courses;
    });
  }

  Future<List<Course>> _callback() {
    _fetchCourses();
    return _courses;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: const Text('COURSES'),
          leading: IconButton(
            tooltip: "Logout",
            icon: Icon(
              Icons.person,
            ),
            onPressed: () => Navigator.pushNamed(context, '/academic_info'),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            )
          ],
        ),
        body: FutureBuilder<List<Course>>(
          future: _courses,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return RefreshIndicator(
                onRefresh: _callback,
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      var course = snapshot.data[index];
                      return ClassListItemWidget(
                          onTap: () {
                            Navigator.pushNamed(context, '/course_grades',
                                arguments: course);
                          },
                          // course: course.courseName.titleCase,
                          course: course.courseName,
                          letterGrade: course.gradeLetter,
                          teacher: course.teacherName,
                          percent: course.gradePercent);
                    }),
              );
            } else if (snapshot.hasError) {
              if (snapshot.error is SocketException ||
                  snapshot.error is HttpException) {
                return RefreshableErrorMessage(
                  onRefresh: _callback,
                  text: "There was an issue connecting to SIS",
                );
              }

              sentry.captureException(exception: snapshot.error);

              return RefreshableErrorMessage(
                onRefresh: _callback,
                text: "An error occured loading courses:\n\n${snapshot.error}",
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
