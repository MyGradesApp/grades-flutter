import 'dart:async';
import 'dart:io';

import 'package:built_collection/built_collection.dart';
import 'package:collection/collection.dart' as collection;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:flutter_picker/flutter_picker.dart';

class CourseGradesView extends StatefulWidget {
  final GroupingMode _groupingMode;
  final StringOrInt _sisPercent;

  CourseGradesView(this._groupingMode, this._sisPercent);

  @override
  _CourseGradesViewState createState() =>
      _CourseGradesViewState(_groupingMode, _sisPercent);
}

class _CourseGradesViewState extends State<CourseGradesView> {
  Completer<void> _refreshCompleter = Completer<void>();
  GroupingMode _currentGroupingMode;
  bool _hasCategories = true;
  final StringOrInt _sisPercent;
  List<DummyGrade> dummyGrades = [];
  String _calculatedPercent;

  _CourseGradesViewState(this._currentGroupingMode, this._sisPercent);

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<CourseGradesBloc>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(bloc.course.courseName),
        centerTitle: true,
        actions: [
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

              _calculatedPercent =
                  determineClassPercentage(groupedGrades, state.data.weights);

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
                      child: Center(
                        child: Text(
                          _calculatedPercent,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  Expanded(
                    child: ListView.builder(
                      itemCount: groupKeys.length,
                      itemBuilder: (context, i) {
                        var group = groupKeys[i];
                        var grades = groupedGrades[group];
                        for (var dummy in dummyGrades) {
                          if (group.toHeader().contains(dummy.category)) {
                            grades.add(dummy);
                          }
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: HeaderedGroup(
                              title: group.toHeader(),
                              subtitle: ((state.data.weights != null)
                                  ? state.data.weights[group.raw()]?.toString()
                                  : null),
                              children: grades,
                              builder: (Grade grade) {
                                return GradeItemCard(
                                  grade: grade,
                                  onTap: () {
                                    if (grade.name == 'Dummy Assignment') {
                                      removeDummyGradePopup(context, grade);
                                    } else {
                                      Navigator.pushNamed(
                                        context,
                                        '/grade_info',
                                        arguments: grade,
                                      );
                                    }
                                  },
                                );
                              }),
                        );
                      },
                    ),
                  ),
                  Card(
                    color: Colors.pink,
                    borderOnForeground: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onTap: () {
                        addDummyGrade(context, groupKeys, groupedGrades);
                        setState(() {
                          _calculatedPercent = determineClassPercentage(
                              groupedGrades, state.data.weights);
                        });
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                            child: Text(
                              'Add Dummy Grade',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          )),
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

  String determineClassPercentage(Map<ToHeader, List<Grade>> groupedGrades,
      BuiltMap<String, String> weights) {
    String classPercent;
    var classPercentWithDecimal = calculateClassPercent(groupedGrades, weights);
    if (classPercentWithDecimal.round() ==
        int.tryParse(_sisPercent.toString())) {
      classPercent = classPercentWithDecimal.toStringAsFixed(2) + '%';
    } else {
      classPercent = _sisPercent.toString() + '%';
    }
    return classPercent;
  }

  void addDummyGrade(BuildContext context, List<ToHeader> groupKeys,
      Map<ToHeader, List<Grade>> groupedGrades) {
    var GradePickerArray = <List<dynamic>>[];
    var percentList = <int>[];
    for (var i = 100; i >= 0; i--) {
      percentList.add(i);
    }
    GradePickerArray.add(percentList);
    if (groupKeys.length > 1) {
      var categoryList = <String>[];
      for (var category in groupKeys) {
        categoryList.add(category.toHeader());
      }
      GradePickerArray.add(categoryList);
    }
    Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: GradePickerArray, isArray: true),
        hideHeader: true,
        title: Center(
          child: Text('Grade Calculator'),
        ),
        confirmText: 'Create Dummy Assignment',
        onConfirm: (Picker picker, List value) {
          var values = picker.getSelectedValues();
          print(values);
          var grade =
              DummyGrade((values[0].toString() + '%'), values[1].toString());
          setState(() {
            dummyGrades.add(grade);
          });
        }).showDialog(context);
  }

  void removeDummyGradePopup(BuildContext context, Grade grade) {
    if (Platform.isIOS) {
      showDialog<CupertinoAlertDialog>(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                title: Text('Remove Dummy Grade?'),
                // content:  Text(''),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text('Remove'),
                    onPressed: () {
                      setState(() {
                        dummyGrades.remove(grade);
                      });
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    } else {
      showDialog<AlertDialog>(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Remove Dummy Grade?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text('Remove'),
                    onPressed: () {
                      setState(() {
                        dummyGrades.remove(grade);
                      });
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }
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
