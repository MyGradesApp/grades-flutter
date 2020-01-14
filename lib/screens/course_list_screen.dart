import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grades/models/current_session.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:grades/widgets/class_list_item_widget.dart';
import 'package:grades/widgets/loader_widget.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
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

  _fetchCourses() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: const Text('COURSES'),
        leading: IconButton(
          tooltip: "Logout",
          icon: Icon(
            // TODO: Find a better icon for "logout"
            Icons.exit_to_app,
          ),
          onPressed: () {
            Alert(
              context: context,
              // type: AlertType.error,
              title: "Confirmation",
              desc: "You will no longer automatically log in",
              buttons: [
                DialogButton(
                  child: Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/login').then((result) {
                    Navigator.of(context).pop();
                  }),
                  width: 120,
                )
              ],
            ).show();

            // Navigator.pop(context, true);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/academic_info'),
          )
        ],
      ),
      body: FutureBuilder<List<Course>>(
        future: _courses,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () {
                _fetchCourses();
                return _courses;
              },
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
              // TODO: Error message rewrite
              return const Center(
                  child: Text("There was an issue connecting to SIS"));
            }

            sentry.captureException(exception: snapshot.error);

            return Center(
                child: Text(
                    "An error occured loading courses:\n${snapshot.error}"));
          }
          return Center(
            child: LoaderWidget(),
          );
        },
      ),
    );
  }
}
