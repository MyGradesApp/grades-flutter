import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:grades/models/grade_persistence.dart';
import 'package:grades/models/theme_controller.dart';
import 'package:grades/utilities/date.dart';
import 'package:grades/utilities/grades.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'colored_grade_dot.dart';

class CourseGradesMinimalDisplay extends StatelessWidget {
  final List<Map<String, dynamic>> _data;
  final Map<String, String> _weights;
  final GroupingMode _groupingMode;
  final String _courseName;

  CourseGradesMinimalDisplay._(
      this._data, this._weights, this._groupingMode, this._courseName);

  factory CourseGradesMinimalDisplay(
    List<Map<String, dynamic>> data,
    Map<String, String> weights,
    GroupingMode groupingMode,
    String courseName,
  ) {
    if (groupingMode == GroupingMode.Category) {
      var copy = List.of(data);
      mergeSort(copy, compare: _gradeCmp);
      return CourseGradesMinimalDisplay._(
          copy, weights, groupingMode, courseName);
    } else {
      return CourseGradesMinimalDisplay._(
          data, weights, groupingMode, courseName);
    }
  }

  @override
  Widget build(BuildContext context) {
    var oldGrades = Provider.of<GradePersistence>(context, listen: false)
        .getOriginalData(_courseName);

    return ListView.builder(
        // scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        // physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _data.length,
        itemBuilder: (context, i) {
          var isNewGrade = !oldGrades.any(
              (element) => element["Assignment"] == _data[i]["Assignment"]);

          var card = buildGradeItemCard(
            context,
            _data[i],
            Theme.of(context).primaryColorLight,
            Theme.of(context).cardColor,
            isNewGrade,
          );

          String category = _data[i]["Category"] as String;
          DateTime date = _data[i]["Assigned"] as DateTime;
          var oldCategory;
          DateTime oldDate;
          if (i > 0) {
            oldCategory = _data[i - 1]["Category"];
            oldDate = _data[i - 1]["Assigned"] as DateTime;
          }
          if (_groupingMode == GroupingMode.Category) {
            if (oldCategory != category) {
              return _buildHeaderedItem(
                text: _titlecase(category),
                subText: _weights != null ? _weights[category] : null,
                child: card,
              );
            }
          } else {
            if ((oldDate != null ? isoWeekNumber(oldDate) : null) !=
                isoWeekNumber(date)) {
              return _buildHeaderedItem(
                text: _dateRangeHeaderForWeek(date),
                child: card,
              );
            }
          }
          return card;
        });
  }

  Widget _buildHeaderedItem({Widget child, String text, String subText}) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 11.0, top: 10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (subText != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 11.0),
                    child: Text(
                      '${subText}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }
}

int _gradeCmp(Map<String, dynamic> a, Map<String, dynamic> b) {
  return (a["Category"] as String)?.compareTo(b["Category"] as String) ?? 0;
}

String _dateRangeHeaderForWeek(DateTime date) {
  var first = firstDayOfWeek(date);
  var last = lastDayOfWeek(date);
  if (first.month == last.month) {
    return "${DateFormat.MMMMd().format(first)} - ${DateFormat.d().format(last)}";
  }
  return "${DateFormat.MMMMd().format(first)} - ${DateFormat.MMMMd().format(last)}";
}

String _titlecase(String src) {
  return src.replaceAllMapped(RegExp(r'\b([a-z])([a-z]*?)\b'),
      (match) => match.group(1).toUpperCase() + match.group(2));
}

Widget buildGradeItemCard(BuildContext context, Map<String, dynamic> grade,
    Color textColor, Color cardColor, bool showIndicator) {
  var gradeString = grade["Grade"].toString();
  var percentIndex = gradeString.indexOf('%');
  String gradeLetter;
  if (percentIndex != -1) {
    var extractedGradePercent =
        double.tryParse(gradeString.substring(0, percentIndex));

    if (extractedGradePercent != null) {
      gradeLetter = letterGradeForPercent(extractedGradePercent);
    }
  }
  double gradeSize;
  if (grade != null && gradeLetter != null) {
    gradeSize = 50;
  } else {
    gradeSize = 100;
  }

  return Card(
    color: cardColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/grades_detail', arguments: grade);
      },
      child: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Text(
                    grade["Assignment"] as String,
                    style: TextStyle(color: textColor),
                  ),
                  const SizedBox(width: 6),
                  // if (showIndicator)
                  //   Container(
                  //     height: 6,
                  //     width: 6,
                  //     decoration: BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       color: Colors.indigoAccent,
                  //     ),
                  //   ),
                ],
              ),
            ),
            if (grade != null && gradeLetter != null)
              ColoredGradeDot.grade(gradeLetter),
            const SizedBox(width: 4),
            if (gradeLetter != null)
              Text(
                gradeLetter,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
            Container(
              width: gradeSize,
              alignment: Alignment.centerRight,
              child: Text(
                gradeString,
                textAlign: TextAlign.end,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Colors.black26,
              size: 18.0,
            ),
          ],
        ),
      ),
    ),
  );
}
