part of 'upcoming_bloc.dart';

class CourseGrade extends Equatable {
  final Course course;
  final Grade grade;

  CourseGrade(this.course, this.grade);

  @override
  List<Object> get props => [course, grade];
}

class UpcomingViewGroup {
  final DateGrouping grouping;
  final List<Grade> grades;

  UpcomingViewGroup(this.grouping, this.grades);
}

@immutable
abstract class UpcomingState extends Equatable {
  const UpcomingState();
}

class UpcomingLoading extends UpcomingState {
  final Map<DateGrouping, Set<CourseGrade>> partialGroups;

  const UpcomingLoading(this.partialGroups);

  factory UpcomingLoading.empty() {
    return UpcomingLoading({});
  }

  List<Tuple2<DateGrouping, List<CourseGrade>>> sortedGroups() {
    return _flattenAndSortGroups(partialGroups);
  }

  UpcomingLoaded complete() {
    return UpcomingLoaded(partialGroups);
  }

  @override
  List<Object> get props => [partialGroups];
}

class UpcomingLoaded extends UpcomingState {
  final Map<DateGrouping, Set<CourseGrade>> groups;

  const UpcomingLoaded(this.groups);

  List<Tuple2<DateGrouping, List<CourseGrade>>> sortedGroups() {
    return _flattenAndSortGroups(groups);
  }

  @override
  List<Object> get props => [groups];
}

class UpcomingError extends UpcomingState {
  @override
  List<Object> get props => [];
}

List<Tuple2<DateGrouping, List<CourseGrade>>> _flattenAndSortGroups(
  Map<DateGrouping, Set<CourseGrade>> groups,
) {
  var groupsList = groups.entries
      .map((e) => Tuple2(
            e.key,
            e.value.toList()
              ..sort((grade, other) =>
                  grade.grade.dueDate.compareTo(other.grade.dueDate)),
          ))
      .toList()
        ..sort((lh, rh) => lh.item1.index.compareTo(rh.item1.index));
  return groupsList;
}
