import 'package:flutter/cupertino.dart';
import 'package:grades/blocs/network_action_bloc/network_action_bloc.dart';
import 'package:sis_loader/sis_loader.dart';

class CourseGradesBloc extends NetworkActionBloc<List<Grade>> {
  final Course _course;

  CourseGradesBloc({@required Course course})
      : assert(course != null),
        _course = course;

  @override
  Future<List<Grade>> fetch() async {
    return await _course.getGrades();
  }
}
