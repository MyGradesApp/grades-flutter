part of 'upcoming_bloc.dart';

@immutable
abstract class UpcomingEvent extends Equatable {
  const UpcomingEvent();

  @override
  List<Object> get props => [];
}

class FetchData extends UpcomingEvent {}

class RefreshData extends UpcomingEvent {}

class GradeLoaded extends UpcomingEvent {
  final Course course;
  final List<Grade> grades;

  const GradeLoaded({@required this.course, @required this.grades});

  @override
  List<Object> get props => [course, grades];

  @override
  String toString() {
    return 'GradeLoaded{course: ${course.courseName}, grades.length = ${grades.length}';
  }
}

class DoneLoading extends UpcomingEvent {}
