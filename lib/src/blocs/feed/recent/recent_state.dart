part of 'recent_bloc.dart';

@immutable
abstract class RecentState extends Equatable {
  const RecentState();
}

class RecentLoading extends RecentState {
  final Map<Course, List<Grade>> partialCourses;

  const RecentLoading(this.partialCourses);

  factory RecentLoading.empty() {
    return RecentLoading({});
  }

  RecentLoaded complete() {
    return RecentLoaded(partialCourses);
  }

  @override
  List<Object> get props => [partialCourses];
}

class RecentLoaded extends RecentState {
  final Map<Course, List<Grade>> courses;

  const RecentLoaded(this.courses);

  @override
  List<Object> get props => [courses];
}

class RecentError extends RecentState {
  final dynamic error;
  final StackTrace stackTrace;

  RecentError(this.error, this.stackTrace);

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'RecentError{error: $error, stackTrace: $stackTrace}';
  }
}
