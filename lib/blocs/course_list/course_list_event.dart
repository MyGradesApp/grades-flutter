part of 'course_list_bloc.dart';

@immutable
abstract class CourseListEvent extends Equatable {
  const CourseListEvent();

  @override
  List<Object> get props => [];
}

class FetchCourses extends CourseListEvent {}

class RefreshCourses extends CourseListEvent {}
