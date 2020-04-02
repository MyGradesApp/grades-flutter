import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:grades/repos/sis_repository.dart';
import 'package:sis_loader/sis_loader.dart';

import '../../errors.dart';

part 'course_list_event.dart';
part 'course_list_state.dart';

class CourseListBloc extends Bloc<CourseListEvent, CourseListState> {
  final SISRepository _sisRepository;

  CourseListBloc({@required SISRepository sisRepository})
      : assert(sisRepository != null),
        _sisRepository = sisRepository;

  @override
  CourseListState get initialState => CourseListLoading();

  @override
  Stream<CourseListState> mapEventToState(
    CourseListEvent event,
  ) async* {
    if (event is FetchCourses) {
      yield CourseListLoading();
      List<Course> courses;
      try {
        courses = await _sisRepository.getCourses();
      } catch (_) {
        yield CourseListError();
        return;
      }
      yield CourseListLoaded(courses);
    } else if (event is RefreshCourses) {
      List<Course> courses;
      try {
        courses = await _sisRepository.getCourses();
      } on GenericHttpException {
        yield CourseListError();
        return;
      }
      yield CourseListLoaded(courses);
    }
  }
}
