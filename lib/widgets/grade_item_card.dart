import 'package:flutter/material.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/widgets/colored_grade_dot.dart';
import 'package:sis_loader/sis_loader.dart';

class GradeItemCard extends StatelessWidget {
  final Grade grade;
  final void Function() onTap;

  GradeItemCard({
    @required this.grade,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var gradeString = grade.grade ?? grade.letter;
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

    Color bgColor, textColor, btnColor;
    IconData iconBtn;
    if (grade.name.contains('Dummy Assignment')) {
      bgColor = Color.fromARGB(255, 211, 117, 116);
      textColor = Colors.white;
      btnColor = Colors.white;
      iconBtn = Icons.close;
    } else {
      iconBtn = Icons.chevron_right;
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: bgColor,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  grade.name,
                  overflow: TextOverflow.ellipsis,
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
                      TextStyle(fontWeight: FontWeight.bold, color: textColor),
                ),
              Container(
                width: gradeSize,
                alignment: Alignment.centerRight,
                child: Text(
                  gradeString,
                  textAlign: TextAlign.end,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: textColor),
                ),
              ),
              Icon(
                iconBtn,
                color: btnColor,
                size: 18.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
