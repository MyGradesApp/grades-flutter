// TODO: Implement "unread" grades
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:grades/repos/sis_repository.dart';
import 'package:sis_loader/sis_loader.dart';

part 'upcoming_event.dart';
part 'upcoming_state.dart';

class UpcomingBloc extends Bloc<UpcomingEvent, UpcomingState> {
  final SISRepository _sisRepository;

  StreamSubscription<UpcomingEvent> _courseFetchingSubscription;

  UpcomingBloc({@required SISRepository sisRepository})
      : assert(sisRepository != null),
        _sisRepository = sisRepository;

  @override
  UpcomingState get initialState => UpcomingLoading.empty();

  @override
  Stream<UpcomingState> mapEventToState(
    UpcomingEvent event,
  ) async* {
    if (event is FetchData) {
      yield* _mapFetchDataToState();
    } else if (event is RefreshData) {
      if (state is UpcomingLoaded) {
        // Preserve the currently loaded courses, we will update the underlying map
        // with new data
        yield UpcomingLoading((state as UpcomingLoaded).courses);
        var courses = await _sisRepository.getCourses();

        await _courseFetchingSubscription?.cancel();
        _courseFetchingSubscription =
            _fetchCourseGrades(courses).listen((event) => add(event));
      } else {
        // We probably shouldn't be able to get a RefreshData if we are still loading
        throw Exception('Unexpected state');
      }
    } else if (event is GradeLoaded) {
      yield* _mapGradeLoadedToState(event);
    } else if (event is DoneLoading) {
      yield* _mapDoneLoadingToState();
    }
  }

  Stream<UpcomingState> _mapFetchDataToState() async* {
    yield UpcomingLoading.empty();
    var courses = await _sisRepository.getCourses();

    await _courseFetchingSubscription?.cancel();
    _courseFetchingSubscription =
        _fetchCourseGrades(courses).listen((event) => add(event));
  }

  Stream<UpcomingState> _mapGradeLoadedToState(GradeLoaded event) async* {
    if (state is UpcomingLoading) {
      var grades = Map.of((state as UpcomingLoading).partialCourses);
      grades[event.course] = event.grades;
      yield UpcomingLoading(grades);
    } else {
      // We probably shouldn't be able to get a GradeLoaded if we are already
      // fully loaded
      throw Exception('Unexpected state');
    }
  }

  Stream<UpcomingState> _mapDoneLoadingToState() async* {
    if (state is UpcomingLoading) {
      yield (state as UpcomingLoading).complete();
    } else {
      // We probably shouldn't be able to get a DoneLoaded if we are already
      // fully loaded
      throw Exception('Unexpected state');
    }
  }

  Stream<UpcomingEvent> _fetchCourseGrades(List<Course> courses) async* {
    for (var course in courses) {
      var grades = await course.getGrades();
      grades = grades.where(isGradeRecent).toList();

      yield GradeLoaded(course: course, grades: grades);
    }
    yield DoneLoading();
  }

  @override
  Future<void> close() {
    _courseFetchingSubscription?.cancel();
    return super.close();
  }
}

bool isGradeRecent(Grade grade) {
  if (grade.dateLastModified != null && grade.dateLastModified is DateTime) {
    var gradeDate = grade.dateLastModified;
    return gradeDate.isAfter(DateTime.now().subtract(const Duration(days: 1)));
  } else {
    return false;
  }
}
