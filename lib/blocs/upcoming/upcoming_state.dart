part of 'upcoming_bloc.dart';

@immutable
abstract class UpcomingState extends Equatable {
  const UpcomingState();
}

class UpcomingLoading extends UpcomingState {
  final Map<Course, List<Grade>> partialCourses;

  const UpcomingLoading(this.partialCourses);

  factory UpcomingLoading.empty() {
    return UpcomingLoading({});
  }

  UpcomingLoaded complete() {
    return UpcomingLoaded(partialCourses);
  }

  @override
  List<Object> get props => [partialCourses];
}

class UpcomingLoaded extends UpcomingState {
  final Map<Course, List<Grade>> courses;

  const UpcomingLoaded(this.courses);

  @override
  List<Object> get props => [courses];
}

class UpcomingError extends UpcomingState {
  @override
  List<Object> get props => [];
}
