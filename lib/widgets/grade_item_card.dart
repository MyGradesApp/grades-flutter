import 'package:flutter/material.dart';
import 'package:grades/utilities/helpers/grades.dart';
import 'package:sis_loader/sis_loader.dart';

import 'indicator_dots/colored_grade_dot.dart';

class GradeItemCard extends StatelessWidget {
  final Grade grade;
  final Color textColor;
  final Color cardColor;
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    var gradeString = grade.grade;
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
                  grade.name,
                  style: TextStyle(color: textColor),
                  // TODO: Make it less aggressive about trimming
                  overflow: TextOverflow.ellipsis,
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

  GradeItemCard(
      {this.grade, this.textColor, this.cardColor, this.showIndicator});
}