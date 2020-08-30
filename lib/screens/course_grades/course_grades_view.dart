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

  CourseGradesView(this._groupingMode);

  @override
  _CourseGradesViewState createState() => _CourseGradesViewState(_groupingMode);
}

class _CourseGradesViewState extends State<CourseGradesView> {
  Completer<void> _refreshCompleter = Completer<void>();
  GroupingMode _currentGroupingMode;
  bool _hasCategories = true;
  StringOrInt _sisPercent;
  List<DummyGrade> dummyGrades = [];
  BuiltMap<String, String> _weights;

  _CourseGradesViewState(this._currentGroupingMode);

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<CourseGradesBloc>(context);
    _sisPercent = bloc.course.gradePercent;
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

              // for (var weight in state.data.weights){
              //   double.tryParse(weights[group.raw()]
              //                 .substring(0, weights[group.raw()].indexOf('%'))) /
              //             100.0
              // }
              var groupKeys = <ToHeader>[];
              groupKeys = groupedGrades.keys.toList()..sort();

              if (groupKeys.isEmpty && dummyGrades.isEmpty) {
                return FullscreenSimpleIconMessage(
                  icon: FontAwesomeIcons.inbox,
                  text: 'No grades available',
                );
              }

              _weights = state.data.weights;

              if (_weights.isNotEmpty) {
                var keys = <String>[];
                for (var group in groupKeys) {
                  keys.add(group.toHeader());
                  for (var dummy in dummyGrades) {
                    if (group.toHeader().contains(dummy.category)) {
                      groupedGrades[group].add(dummy);
                    }
                  }
                }
                for (var weight in _weights.entries) {
                  if (!(keys.contains(weight.key))) {
                    var temp = <Grade>[];
                    for (var dummy in dummyGrades) {
                      if (weight.key.contains(dummy.category)) {
                        temp.add(dummy);
                      }
                    }
                    print('temp' + temp.toString());
                    groupKeys.add(StringHeader(weight.key, weight.key));
                    groupedGrades
                        .addAll({StringHeader(weight.key, weight.key): temp});
                  }
                }
              }
              return Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: getClassPercentageWidget(
                          groupedGrades, state.data.weights)),
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
                              builder: (Grade grade) {
                                return GradeItemCard(
                                  grade: grade,
                                  onTap: () {
                                    if (grade.name
                                        .contains('Dummy Assignment')) {
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
                ],
              );
            }
            return Container();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 1.0,
          child: Icon(FontAwesomeIcons.calculator),
          backgroundColor: Colors.pink,
          onPressed: () {
            addDummyGrade(context, _weights);
          }),
    );
  }

  Widget getClassPercentageWidget(Map<ToHeader, List<Grade>> groupedGrades,
      BuiltMap<String, String> weights) {
    var classPercentWithDecimal =
        calculateClassPercent(groupedGrades, weights, dummyGrades);

    if (classPercentWithDecimal.round() ==
            int.tryParse(_sisPercent.toString()) &&
        dummyGrades.isEmpty) {
      return Center(
        child: Text(
          classPercentWithDecimal.toStringAsFixed(2) + '%',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      );
    } else if (dummyGrades.isNotEmpty) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _sisPercent.toString() + '%',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ),
          Text(
            classPercentWithDecimal.toStringAsFixed(2) + '%',
            style: TextStyle(
                color: Colors.pink, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ],
      );
    } else {
      return Center(
        child: Text(
          _sisPercent.toString() + '%',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      );
    }
  }

  void addDummyGrade(BuildContext context, BuiltMap<String, String> weights) {
    var GradePickerArray = <List<dynamic>>[];
    var percentList = <int>[];
    for (var i = 100; i >= 0; i--) {
      percentList.add(i);
    }
    GradePickerArray.add(percentList);
    if (weights != null) {
      if (weights.entries.isNotEmpty) {
        var categoryList = <String>[];
        for (var weight in weights.entries) {
          print('${weight.key} = ${weight.value}');
          categoryList.add(weight.key);
        }
        GradePickerArray.add(categoryList);
      }
    }

    Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: GradePickerArray, isArray: true),
        hideHeader: true,
        title: Column(children: [
          Padding(
            padding: EdgeInsets.only(bottom: 7),
            child: Center(
              child: Text('Grade Calculator'),
            ),
          ),
          Row(children: [
            Icon(Icons.info_outline),
            Expanded(
              child: Text(
                'The data presented by this utility may not be entirely accurate.',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ),
          ]),
          Text(
            'Use at your own risk.',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ]),
        confirmText: 'Create Dummy Assignment',
        onConfirm: (Picker picker, List value) {
          var values = picker.getSelectedValues();
          print(values);
          var grade = DummyGrade((values[0].toString() + '%'),
              values[1].toString(), dummyGrades.length);
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
