import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sis_loader/sis_loader.dart';

part 'course_grades_event.dart';
part 'course_grades_state.dart';

class CourseGradesBloc extends Bloc<CourseGradesEvent, CourseGradesState> {
  final Course _course;

  CourseGradesBloc({@required Course course})
      : assert(course != null),
        _course = course;

  @override
  CourseGradesState get initialState => CourseGradesLoading();

  @override
  Stream<CourseGradesState> mapEventToState(
    CourseGradesEvent event,
  ) async* {
    if (event is FetchGrades) {
      yield CourseGradesLoading();
      var grades = await _course.getGrades();
      yield CourseGradesLoaded(grades);
    } else if (event is RefreshGrades) {
      var grades = await _course.getGrades();
      yield CourseGradesLoaded(grades);
    }
  }
}
