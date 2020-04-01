import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:grades/providers/data_persistence.dart';
import 'package:grades/providers/theme_controller.dart';
import 'package:grades/utilities/helpers/date.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sis_loader/sis_loader.dart';

import 'grade_item_card.dart';

class CourseGradesDisplay extends StatelessWidget {
  final List<Grade> _grades;
  final Map<String, String> _weights;
  final GroupingMode _groupingMode;
  final String _courseName;

  CourseGradesDisplay._(
    this._grades,
    this._weights,
    this._groupingMode,
    this._courseName,
  );

  factory CourseGradesDisplay(
    List<Grade> grades,
    Map<String, String> weights,
    GroupingMode groupingMode,
    String courseName,
  ) {
    if (groupingMode == GroupingMode.Category) {
      var copy = List.of(grades);
      mergeSort(copy, compare: _gradeCmp);
      return CourseGradesDisplay._(copy, weights, groupingMode, courseName);
    } else {
      return CourseGradesDisplay._(grades, weights, groupingMode, courseName);
    }
  }

  @override
  Widget build(BuildContext context) {
    var oldGrades = Provider.of<DataPersistence>(context, listen: false)
        .getOriginalGrades(_courseName);

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _grades.length,
      itemBuilder: (context, i) {
        var isNewGrade =
            !oldGrades.any((element) => element.name == _grades[i].name);

        var card = GradeItemCard(
          grade: _grades[i],
          textColor: Theme.of(context).primaryColorLight,
          cardColor: Theme.of(context).cardColor,
          showIndicator: isNewGrade,
        );

        var category = _grades[i].category;
        var date = _grades[i].assignedDate;
        var oldCategory;
        DateTime oldDate;
        if (i > 0) {
          oldCategory = _grades[i - 1].category;
          oldDate = _grades[i - 1].assignedDate;
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
          if (date != null &&
              (oldDate != null ? isoWeekNumber(oldDate) : null) !=
                  isoWeekNumber(date)) {
            return _buildHeaderedItem(
              text: _dateRangeHeaderForWeek(date),
              child: card,
            );
          }
        }
        return card;
      },
    );
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
                    style: const TextStyle(
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

int _gradeCmp(Grade a, Grade b) {
  return a.category?.compareTo(b.category) ?? 0;
}

String _dateRangeHeaderForWeek(DateTime date) {
  var first = firstDayOfWeek(date);
  var last = lastDayOfWeek(date);
  if (first.month == last.month) {
    return '${DateFormat.MMMMd().format(first)} - ${DateFormat.d().format(last)}';
  }
  return '${DateFormat.MMMMd().format(first)} - ${DateFormat.MMMMd().format(last)}';
}

String _titlecase(String src) {
  return src.replaceAllMapped(RegExp(r'\b([a-z])([a-z]*?)\b'),
      (match) => match.group(1).toUpperCase() + match.group(2));
}
