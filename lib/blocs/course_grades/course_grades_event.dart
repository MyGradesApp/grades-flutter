part of 'course_grades_bloc.dart';

@immutable
abstract class CourseGradesEvent extends Equatable {
  const CourseGradesEvent();

  @override
  List<Object> get props => [];
}

class FetchGrades extends CourseGradesEvent {}

class RefreshGrades extends CourseGradesEvent {}
