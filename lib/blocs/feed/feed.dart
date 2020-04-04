import 'package:sis_loader/sis_loader.dart';

import 'feed_event.dart';

Stream<FeedEvent> fetchCourseGrades<E>(
    List<Course> courses, bool Function(Grade element) test) async* {
  for (var course in courses) {
    var grades = await course.getGrades();
    grades = grades.where(test).toList();

    yield GradesLoaded(course: course, grades: grades);
  }
  yield DoneLoading();
}
