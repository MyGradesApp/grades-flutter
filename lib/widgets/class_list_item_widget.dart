import 'package:flutter/material.dart';
import 'package:grades/models/grade_persistence.dart';
import 'package:grades/widgets/colored_grade_dot.dart';
import 'package:grades/widgets/new_grade_course_indicator.dart';

class ClassListItemWidget extends StatelessWidget {
  ClassListItemWidget(
      {@required this.course,
      @required this.teacher,
      @required this.letterGrade,
      @required this.percent,
      this.status,
      this.onTap})
      : assert(percent is int || percent is String),
        assert(course != null),
        assert(teacher != null),
        assert(percent != null);

  final String course;
  final String teacher;
  final String letterGrade;
  // String | int
  final dynamic percent;
  final GradeStatus status;
  final void Function() onTap;

  Widget _buildColumn(String topText, String bottomText,
      CrossAxisAlignment alignment, Color textColor,
      {bool chevron = false, String grade, GradeStatus status}) {
    return Column(crossAxisAlignment: alignment, children: <Widget>[
      Row(
        children: <Widget>[
          Text(
            topText,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 19, color: textColor),
          ),
          if (status != null && status == GradeStatus.New)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: NewGradeCourseIndicator(),
            ),
        ],
      ),
      Padding(
        child: Container(
          child: Row(
            children: <Widget>[
              if (grade != null) ColoredGradeDot.grade(grade),
              const SizedBox(width: 3),
              Text(
                bottomText,
                style: TextStyle(fontSize: 15, color: textColor),
              ),
              if (chevron)
                Icon(
                  Icons.chevron_right,
                  color: Colors.black26,
                )
            ],
          ),
        ),
        padding: const EdgeInsets.only(top: 30),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    String fmt_percent;
    if (percent is int) {
      fmt_percent = '$percent%';
    } else {
      if (percent == "Not Graded") {
        fmt_percent = "N/A";
      } else {
        // Handle cases that aren't `Not Graded`
        fmt_percent = percent as String;
      }
    }

    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: onTap,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 15),
          child: Row(children: <Widget>[
            Expanded(
              child: _buildColumn(
                  this.course,
                  this.teacher.replaceAll('  ', ' '),
                  CrossAxisAlignment.start,
                  Theme.of(context).primaryColorLight,
                  status: status),
            ),
            _buildColumn(fmt_percent, this.letterGrade ?? "",
                CrossAxisAlignment.end, Theme.of(context).primaryColorLight,
                chevron: true, grade: this.letterGrade),
          ]),
        ),
      ),
    );
  }
}
