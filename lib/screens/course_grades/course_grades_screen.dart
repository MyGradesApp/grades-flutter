import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';
import 'package:sis_loader/sis_loader.dart';

import 'course_grades_view.dart';

class CourseGradesScreen extends StatelessWidget {
  final SISRepository _sisRepository;

  CourseGradesScreen({@required SISRepository sisRepository})
      : assert(sisRepository != null),
        _sisRepository = sisRepository;

  @override
  Widget build(BuildContext context) {
    final course = ModalRoute.of(context).settings.arguments as Course;

    return Scaffold(
      appBar: AppBar(title: Text('Course grades')),
      body: Column(
        children: <Widget>[
          Text('Grades for: ${course.courseName}'),
          BlocProvider<CourseGradesBloc>(
            create: (_) => CourseGradesBloc(
              course: course,
              sisRepository: _sisRepository,
            )..add(FetchNetworkData()),
            child: CourseGradesView(),
          ),
        ],
      ),
    );
  }
}
