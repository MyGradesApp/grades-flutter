import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:grades/blocs/feed/feed.dart';
import 'package:grades/blocs/feed/feed_event.dart';
import 'package:grades/repos/sis_repository.dart';
import 'package:grades/utilties/date.dart';
import 'package:sis_loader/sis_loader.dart';
import 'package:tuple/tuple.dart';

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
      yield* _fetchCourseData();
    } else if (event is RefreshData) {
      if (state is UpcomingLoaded) {
        // Preserve the currently loaded courses, we will update the underlying map
        // with new data
        yield UpcomingLoading((state as UpcomingLoaded).groups);
        yield* _fetchCourseData();
      } else {
        // We probably shouldn't be able to get a RefreshData if we are still loading
        throw Exception('Unexpected state');
      }
    } else if (event is GradesLoaded) {
      yield* _mapGradeLoadedToState(event);
    } else if (event is DoneLoading) {
      yield* _mapDoneLoadingToState();
    }
  }

  Stream<UpcomingState> _fetchCourseData() async* {
    var courses = await _sisRepository.getCourses();

    await _courseFetchingSubscription?.cancel();
    _courseFetchingSubscription = fetchCourseGrades(courses, isGradeUpcoming)
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
        (groups[group] ??= <Grade>{})..add(grade);
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
