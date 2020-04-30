import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:grade_core/src/utilities/date.dart';
import 'package:sis_loader/sis_loader.dart';
import 'package:tuple/tuple.dart';

import '../../../repos/sis_repository.dart';
import '../feed.dart';
import '../feed_event.dart';

part 'upcoming_state.dart';

class UpcomingBloc extends Bloc<FeedEvent, UpcomingState> {
  final SISRepository _sisRepository;

  StreamSubscription<FeedEvent> _courseFetchingSubscription;

  UpcomingBloc({@required SISRepository sisRepository})
      : assert(sisRepository != null),
        _sisRepository = sisRepository;

  @override
  UpcomingState get initialState => UpcomingLoading.empty();

  @override
  Stream<UpcomingState> mapEventToState(
    FeedEvent event,
  ) async* {
    if (event is FetchData) {
      yield UpcomingLoading.empty();
      yield* _fetchCourseData(refresh: false);
    } else if (event is RefreshData) {
      if (state is UpcomingLoaded) {
        // Preserve the currently loaded courses, we will update the underlying map
        // with new data
        yield UpcomingLoading((state as UpcomingLoaded).groups);
        yield* _fetchCourseData(refresh: true);
      }
    } else if (event is GradesLoaded) {
      yield* _mapGradeLoadedToState(event);
    } else if (event is DoneLoading) {
      yield* _mapDoneLoadingToState();
    }
  }

  Stream<UpcomingState> _fetchCourseData({@required bool refresh}) async* {
    var courses = await _sisRepository.getCourses();
    if (courses == null) {
      add(DoneLoading());
      return;
    }

    await _courseFetchingSubscription?.cancel();
    _courseFetchingSubscription =
        fetchCourseGrades(_sisRepository, courses, isGradeUpcoming, refresh)
            .listen((event) => add(event));
  }

  Stream<UpcomingState> _mapGradeLoadedToState(GradesLoaded event) async* {
    if (state is UpcomingLoading) {
      var groups = Map.of((state as UpcomingLoading).partialGroups);

      for (var grade in event.grades) {
        if (grade.dueDate == null) {
          return;
        }
        var group = DateGroupingExt.fromDate(grade.dueDate);
        (groups[group] ??= <CourseGrade>{})
          ..add(CourseGrade(event.course, grade));
      }
      yield UpcomingLoading(groups);
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

  @override
  Future<void> close() {
    _courseFetchingSubscription?.cancel();
    return super.close();
  }
}

bool isGradeUpcoming(Grade grade) {
  if (grade.dueDate != null && grade.dueDate is DateTime) {
    // We assume any "upcoming" grade will be "Not Graded"
    if (grade.grade != 'Not Graded') {
      return false;
    }
    var gradeDueDate = grade.dueDate;
    var n = DateTime.now();
    var now =
        DateTime(n.year, n.month, n.day).subtract(const Duration(seconds: 1));
    return gradeDueDate.isAfter(now);
  } else {
    return false;
  }
}
