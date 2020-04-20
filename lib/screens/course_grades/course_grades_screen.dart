import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';
import 'package:sis_loader/sis_loader.dart';

import 'course_grades_view.dart';

class CourseGradesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final course = ModalRoute.of(context).settings.arguments as Course;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Course grades'),
      ),
      body: Column(
        children: <Widget>[
          Text('Grades for: ${course.courseName}'),
          Expanded(
            child: BlocProvider<CourseGradesBloc>(
              create: (_) => CourseGradesBloc(
                course: course,
                sisRepository: RepositoryProvider.of<SISRepository>(context),
              )..add(FetchNetworkData()),
              child: CourseGradesView(),
            ),
          ),
        ],
      ),
    );
  }
}
