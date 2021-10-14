import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:sis_loader/sis_loader.dart';

@immutable
abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class FetchData extends FeedEvent {}

class RefreshData extends FeedEvent {}

class GradesLoaded extends FeedEvent {
  final Course course;
  final List<Grade> grades;

  const GradesLoaded({@required this.course, @required this.grades});

  @override
  List<Object> get props => [course, grades];

  @override
  String toString() {
    return 'GradesLoaded{course: ${course.courseName}, grades.length = ${grades.length}}';
  }
}

class DoneLoading extends FeedEvent {}
