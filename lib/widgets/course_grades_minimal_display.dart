import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:grades/utilities/date.dart';
import 'package:grades/utilities/grades.dart';
import 'package:grades/widgets/colored_grade_dot.dart';
import 'package:intl/intl.dart';

enum GroupingMode { Date, Category }

class CourseGradesMinimalDisplay extends StatelessWidget {
  final List<Map<String, dynamic>> _data;
  final GroupingMode _groupingMode;

  CourseGradesMinimalDisplay._(this._data, this._groupingMode);

  factory CourseGradesMinimalDisplay(
      List<Map<String, dynamic>> data, GroupingMode groupingMode) {
    if (groupingMode == GroupingMode.Category) {
      var copy = List.of(data);
      mergeSort(copy, compare: _gradeCmp);
      return CourseGradesMinimalDisplay._(copy, groupingMode);
    } else {
      return CourseGradesMinimalDisplay._(data, groupingMode);
    }
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> grade,
      Color textColor, Color cardColor) {
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
                child: Text(
                  grade["Assignment"] as String,
                  style: TextStyle(color: textColor),
                ),
              ),
              if (grade != null && gradeLetter != null)
                ColoredGradeDot.grade(gradeLetter),
              const SizedBox(width: 4),
              if (gradeLetter != null)
                Text(
                  gradeLetter,
                  style:
                      TextStyle(color: textColor, fontWeight: FontWeight.bold),
                ),
              Container(
                width: gradeSize,
                alignment: Alignment.centerRight,
                child: Text(
                  gradeString,
                  textAlign: TextAlign.end,
                  style:
                      TextStyle(color: textColor, fontWeight: FontWeight.bold),
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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _data.length,
        itemBuilder: (context, i) {
          var card = _buildCard(
            context,
            _data[i],
            Theme.of(context).primaryColorLight,
            Theme.of(context).cardColor,
          );

          var category = _data[i]["Category"];
          DateTime date = _data[i]["Assigned"];
          var oldCategory;
          DateTime oldDate;
          if (i > 0) {
            oldCategory = _data[i - 1]["Category"];
            oldDate = _data[i - 1]["Assigned"];
          }
          if (_groupingMode == GroupingMode.Category) {
            var cat = ('${category[0].toUpperCase()}${category.substring(1)}');
            if (oldCategory != category) {
              return _buildHeaderedItem(
                text: cat,
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

  Widget _buildHeaderedItem({Widget child, String text}) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 11.0, top: 10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

int _gradeCmp(Map<String, dynamic> a, Map<String, dynamic> b) {
  return (a["Category"] as String)?.compareTo(b["Category"]) ?? 0;
}

String _dateRangeHeaderForWeek(DateTime date) {
  var first = firstDayOfWeek(date);
  var last = lastDayOfWeek(date);
  if (first.month == last.month) {
    return "${DateFormat.MMMMd().format(first)} - ${DateFormat.d().format(last)}";
  }
  return "${DateFormat.MMMMd().format(first)} - ${DateFormat.MMMMd().format(last)}";
}
