part of 'course_list_bloc.dart';

@immutable
abstract class CourseListState {
  const CourseListState();
}

class CourseListLoading extends CourseListState {
  const CourseListLoading();

  @override
  String toString() {
    return 'CourseListLoading{}';
  }
}

class CourseListLoaded extends CourseListState {
  final List<Course> data;

  const CourseListLoaded(this.data);

  @override
  String toString() {
    return 'CourseListLoaded{length: ${data.length}}';
  }
}

class CourseListError extends CourseListState {
  final dynamic error;
  final StackTrace stackTrace;

  CourseListError(this.error, this.stackTrace);

  @override
  String toString() {
    return 'CourseListError{error: $error, stackTrace: $stackTrace}';
  }
}
