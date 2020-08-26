import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:grade_core/grade_core.dart';
import 'package:meta/meta.dart';
import 'package:pedantic/pedantic.dart';
import 'package:sis_loader/sis_loader.dart';

part 'course_list_event.dart';
part 'course_list_state.dart';

class CourseListBloc extends Bloc<CourseListEvent, CourseListState> {
  final SISRepository _sisRepository;

  CourseListBloc({@required SISRepository sisRepository})
      : assert(sisRepository != null),
        _sisRepository = sisRepository,
        super(CourseListLoading());

  @override
  Stream<CourseListState> mapEventToState(CourseListEvent event) async* {
    bool refresh;
    if (event is FetchCourseList) {
      yield CourseListLoading();
      refresh = false;
    } else if (event is RefreshCourseList) {
      refresh = true;
    }
    try {
      var courses = await _sisRepository.getCourses(refresh: refresh);
      yield CourseListLoaded(courses);

      for (var x = 0; x < courses.length; x++) {
        try {
          var grades = await _sisRepository.getCourseGrades(courses[x]);
          courses[x] = courses[x].rebuild((c) {
            if (grades.classPercent != null) {
              c.gradePercent = StringOrInt(grades.classPercent);
            }
          });
        } catch (e, st) {
          unawaited(reportException(exception: e, stackTrace: st));
        }
      }
      yield CourseListLoaded(courses);
    } catch (e, st) {
      yield CourseListError(e, st);
      unawaited(
        reportBlocException(exception: e, stackTrace: st, bloc: this),
      );
    }
  }
}
