part of 'course_grades_bloc.dart';

@immutable
abstract class CourseGradesState extends Equatable {
  const CourseGradesState();

  @override
  List<Object> get props => [];
}

class CourseGradesLoading extends CourseGradesState {
  const CourseGradesLoading();
}

class CourseGradesLoaded extends CourseGradesState {
  final List<Grade> grades;

  const CourseGradesLoaded(this.grades);

  @override
  List<Object> get props => [grades];

  @override
  String toString() {
    return 'CourseGradesLoaded{count(grades) = ${grades.length}';
  }
}

class CourseGradesError extends CourseGradesState {}
