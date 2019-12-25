import 'package:flutter/material.dart';
import 'package:sis_loader/sis_loader.dart';

class CourseGradesScreen extends StatefulWidget {
  @override
  _CourseGradesScreenState createState() => _CourseGradesScreenState();
}

class _CourseGradesScreenState extends State<CourseGradesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Course course = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Grades for ${course.courseName}"),
      ),
    );
  }
}
