import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grades/blocs/course_grades/course_grades_bloc.dart';
import 'package:sis_loader/sis_loader.dart';

import 'course_grades_view.dart';

class CourseGradesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final course = ModalRoute.of(context).settings.arguments as Course;

    return Scaffold(
      appBar: AppBar(title: Text('Course grades')),
      body: Column(
        children: <Widget>[
          Text('Grades for: ${course.courseName}'),
          BlocProvider<CourseGradesBloc>(
            create: (context) => CourseGradesBloc(
              course: course,
            )..add(FetchGrades()),
            child: CourseGradesView(),
          ),
        ],
      ),
    );
  }
}
