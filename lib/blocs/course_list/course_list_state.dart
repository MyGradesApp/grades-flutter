part of 'course_list_bloc.dart';

@immutable
abstract class CourseListState extends Equatable {
  const CourseListState();

  @override
  List<Object> get props => [];
}

class CourseListLoading extends CourseListState {
  const CourseListLoading();
}

class CourseListLoaded extends CourseListState {
  final List<Course> courses;

  const CourseListLoaded(this.courses);

  @override
  List<Object> get props => [courses];
}

class CourseListError extends CourseListState {}
