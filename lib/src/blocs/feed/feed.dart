import 'package:grade_core/grade_core.dart';
import 'package:sis_loader/sis_loader.dart';

import 'feed_event.dart';

Stream<FeedEvent> fetchCourseGrades(
    SISRepository sisRepository,
    List<Course> courses,
    bool Function(Grade element) test,
    bool refresh) async* {
  for (var course in courses) {
    var grades = await sisRepository.getCourseGrades(course, refresh: refresh);
    grades = grades.where(test).toList();

    yield GradesLoaded(course: course, grades: grades);
  }
  yield DoneLoading();
}
