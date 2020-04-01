import 'package:flutter/material.dart';
import 'package:grades/utilities/helpers/date.dart';
import 'package:grades/utilities/strings.dart';
import 'package:sis_loader/sis_loader.dart';

class UpcomingGradeItem extends StatelessWidget {
  final Grade grade;
  final String courseName;
  final Color textColor;
  final Color cardColor;
  final bool showIndicator;

  UpcomingGradeItem(this.grade, this.textColor, this.cardColor,
      this.showIndicator, this.courseName);

  @override
  Widget build(BuildContext context) {
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
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(17.0),
                child: Text(
                  grade.name,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                  // TODO: Make it less aggressive about trimming
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            getColumn(textColor, grade, courseName),
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

Widget getColumn(Color textColor, Grade grade, String courseName) {
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
                  color: textColor,
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
