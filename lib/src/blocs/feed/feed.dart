import 'package:grade_core/grade_core.dart';
import 'package:sis_loader/sis_loader.dart';

import 'feed_event.dart';

Stream<FeedEvent> fetchCourseGrades(
    SISRepository sisRepository,
    List<Course> courses,
    bool Function(Grade element) test,
    bool refresh) async* {
  for (var course in courses) {
    var gradeData =
        await sisRepository.getCourseGrades(course, refresh: refresh);
    // TODO: Propagate null once we get null checks
    var grades = gradeData?.grades?.where(test)?.toList() ?? [];

    yield GradesLoaded(course: course, grades: grades);
  }
  yield DoneLoading();
}
