part of 'course_list_bloc.dart';

@immutable
abstract class CourseListEvent {}

class FetchCourseList extends CourseListEvent {
  @override
  String toString() {
    return 'FetchCourseList{}';
  }
}

class RefreshCourseList extends CourseListEvent {
  @override
  String toString() {
    return 'RefreshCourseList{}';
  }
}
