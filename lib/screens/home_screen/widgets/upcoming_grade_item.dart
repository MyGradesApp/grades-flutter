import 'package:flutter/material.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/utilities/string.dart';
import 'package:sis_loader/sis_loader.dart';

class UpcomingGradeItem extends StatelessWidget {
  final Grade grade;
  final String courseName;

  UpcomingGradeItem({
    @required this.grade,
    @required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onTap: () {
          Navigator.pushNamed(context, '/grades_info', arguments: grade);
        },
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(17.0),
                child: Text(
                  grade.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  // TODO: Make it less aggressive about trimming
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            getColumn(grade, courseName),
            const Icon(
              Icons.chevron_right,
              color: Colors.black26,
              size: 18.0,
            ),
          ],
        ),
      ),
    );
  }
}

Widget getColumn(Grade grade, String courseName) {
  var text = Text(smartCourseTitleCase(courseName));
  var daysLeft = daysUntil(grade.dueDate);
  if (daysLeft > 0) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                '${humanizedDaysLeft(daysLeft)}',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        text,
      ],
    );
  } else {
    return text;
  }
}

String humanizedDaysLeft(int days) {
  if (days == 0) {
    return 'Today';
  } else if (days == 1) {
    return 'In 1 day';
  } else {
    return 'In ${days} days';
  }
}
