import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart' as collection;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/utilities/calculate_grade.dart';
import 'package:grades/widgets/grade_item_card.dart';
import 'package:grades/widgets/headered_group.dart';
import 'package:grades/widgets/loading_indicator.dart';
import 'package:grades/widgets/refreshable/fullscreen_error_message.dart';
import 'package:grades/widgets/refreshable/fullscreen_simple_icon_message.dart';
import 'package:intl/intl.dart';
import 'package:sis_loader/sis_loader.dart';

class CourseGradesView extends StatefulWidget {
  final GroupingMode _groupingMode;
  final StringOrInt _gradePercent;

  CourseGradesView(this._groupingMode, this._gradePercent);

  @override
  _CourseGradesViewState createState() =>
      _CourseGradesViewState(_groupingMode, _gradePercent);
}

class _CourseGradesViewState extends State<CourseGradesView> {
  Completer<void> _refreshCompleter = Completer<void>();
  GroupingMode _currentGroupingMode;
  bool _hasCategories = true;
  final StringOrInt _gradePercent;

  _CourseGradesViewState(this._currentGroupingMode, this._gradePercent);

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<CourseGradesBloc>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(bloc.course.courseName),
        centerTitle: true,
        actions: [
          // IconButton(
          //   icon: Icon(Icons.edit),
          //   onPressed: () {
          //     setState(() {
          //       openGradeCalculator();
          //     });
          //   },
          // ),
          if (_hasCategories)
            IconButton(
              icon: Icon(_currentGroupingMode == GroupingMode.category
                  ? Icons.format_list_bulleted
                  : Icons.today),
              onPressed: () {
                setState(() {
                  _currentGroupingMode = _currentGroupingMode.toggled();
                });
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          bloc.add(RefreshNetworkData());
          return _refreshCompleter.future;
        },
        child: BlocConsumer<CourseGradesBloc, NetworkActionState>(
          listener: (context, state) {
            if (state is NetworkLoaded || state is NetworkActionError) {
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            }

            if (state is NetworkLoaded<GradeData>) {
              setState(() {
                _hasCategories = (state.data?.grades ?? BuiltList())
                    .every((g) => g.raw.containsKey('Category'));
              });
            }
          },
          builder: (context, state) {
            if (state is NetworkLoading) {
              return Center(child: LoadingIndicator());
            }
            if (state is NetworkActionError) {
              return FullscreenErrorMessage(
                text: 'There was an unknown error',
              );
            }
            if (state is NetworkLoaded<GradeData>) {
              // Data persistence has no saved data for this course
              if (state.data == null) {
                return FullscreenSimpleIconMessage(
                  icon: FontAwesomeIcons.inbox,
                  text: 'No saved data for this course',
                );
              }

              Map<ToHeader, List<Grade>> groupedGrades;
              switch (
                  _hasCategories ? _currentGroupingMode : GroupingMode.date) {
                case GroupingMode.date:
                  groupedGrades = collection.groupBy(
                    state.data.grades,
                    (Grade e) => _dateRangeForWeek(e.assignedDate),
                  );
                  break;
                case GroupingMode.category:
                  groupedGrades = collection.groupBy(
                    state.data.grades,
                    (Grade e) =>
                        StringHeader(_titlecase(e.category ?? ''), e.category),
                  );
                  break;
              }

              var groupKeys = groupedGrades.keys.toList()..sort();

              if (groupKeys.isEmpty) {
                return FullscreenSimpleIconMessage(
                  icon: FontAwesomeIcons.inbox,
                  text: 'This course has no grades',
                );
              }
              return Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _gradePercent.toString() + '%',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' (' +
                                calculateGradePercent(
                                    groupedGrades, state.data.weights) +
                                '%)',
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 24,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )),
                  Expanded(
                    child: ListView.builder(
                      itemCount: groupKeys.length,
                      itemBuilder: (context, i) {
                        var group = groupKeys[i];
                        var grades = groupedGrades[group];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: HeaderedGroup(
                            title: group.toHeader(),
                            subtitle: ((state.data.weights != null)
                                ? state.data.weights[group.raw()]?.toString()
                                : null),
                            children: grades,
                            builder: (Grade grade) => GradeItemCard(
                              grade: grade,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/grade_info',
                                  arguments: grade,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

abstract class ToHeader {
  String toHeader();

  dynamic raw() {
    return null;
  }
}

class StringHeader extends Equatable
    implements ToHeader, Comparable<StringHeader> {
  final String inner;
  final String _raw;

  StringHeader(this.inner, [this._raw]);

  @override
  String toHeader() => inner;

  @override
  int compareTo(StringHeader other) {
    return inner.compareTo(other.inner);
  }

  @override
  List<Object> get props => [inner];

  @override
  String raw() {
    return _raw;
  }
}

class DateRange extends Equatable implements Comparable<DateRange>, ToHeader {
  final DateTime start;
  final DateTime end;

  DateRange(this.start, this.end);

  String formatHeader() {
    if (start.month == end.month) {
      return '${DateFormat.MMMMd().format(start)} - ${DateFormat.d().format(end)}';
    }
    return '${DateFormat.MMMMd().format(start)} - ${DateFormat.MMMMd().format(end)}';
  }

  @override
  int compareTo(DateRange other) => -start.compareTo(other.start);

  @override
  String toHeader() => formatHeader();

  @override
  List<Object> get props => [start, end];

  @override
  dynamic raw() {
    return null;
  }
}

DateRange _dateRangeForWeek(DateTime date) {
  var first = firstDayOfWeek(date);
  var last = lastDayOfWeek(date);
  return DateRange(first, last);
}

String _titlecase(String src) {
  return src.replaceAllMapped(
    RegExp(r'\b([a-z])([a-z]*?)\b'),
    (match) => match.group(1).toUpperCase() + match.group(2),
  );
}
