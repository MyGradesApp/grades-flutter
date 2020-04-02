import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:grades/repos/authentication_repository.dart';
import 'package:sis_loader/sis_loader.dart';

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
      var courses = await _sisRepository.getCourses();
      yield CourseListLoaded(courses);
    } else if (event is RefreshCourses) {
      var courses = await _sisRepository.getCourses();
      yield CourseListLoaded(courses);
    }
  }
}
