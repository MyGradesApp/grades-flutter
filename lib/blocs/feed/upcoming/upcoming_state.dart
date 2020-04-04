part of 'upcoming_bloc.dart';

@immutable
abstract class UpcomingState extends Equatable {
  const UpcomingState();
}

class UpcomingLoading extends UpcomingState {
  final Map<DateGrouping, Set<Grade>> partialGroups;

  const UpcomingLoading(this.partialGroups);

  factory UpcomingLoading.empty() {
    return UpcomingLoading({});
  }

  List<Tuple2<DateGrouping, List<Grade>>> sortedGroups() {
    return _flattenAndSortGroups(partialGroups);
  }

  UpcomingLoaded complete() {
    return UpcomingLoaded(partialGroups);
  }

  @override
  List<Object> get props => [partialGroups];
}

class UpcomingLoaded extends UpcomingState {
  final Map<DateGrouping, Set<Grade>> groups;

  const UpcomingLoaded(this.groups);

  List<Tuple2<DateGrouping, List<Grade>>> sortedGroups() {
    return _flattenAndSortGroups(groups);
  }

  @override
  List<Object> get props => [groups];
}

class UpcomingError extends UpcomingState {
  @override
  List<Object> get props => [];
}

List<Tuple2<DateGrouping, List<Grade>>> _flattenAndSortGroups(
    Map<DateGrouping, Set<Grade>> groups) {
  var groupsList = groups.entries
      .map((e) => Tuple2(
            e.key,
            e.value.toList()
              ..sort((grade, other) => grade.dueDate.compareTo(other.dueDate)),
          ))
      .toList()
        ..sort((lh, rh) => lh.item1.index.compareTo(rh.item1.index));
  return groupsList;
}
