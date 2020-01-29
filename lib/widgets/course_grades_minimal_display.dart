import 'package:flutter/material.dart';
import 'package:grades/utilities/grades.dart';
import 'package:grades/widgets/colored_grade_dot.dart';

class CourseGradesMinimalDisplay extends StatelessWidget {
  final List<Map<String, dynamic>> _data;

  CourseGradesMinimalDisplay(this._data);

  Widget _buildCard(BuildContext context, Map<String, dynamic> grade,
      Color textColor, Color cardColor) {
    var gradeString = grade["Grade"].toString();
    var percentIndex = gradeString.indexOf('%');
    var gradeLetter;
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
          if (grade != null && gradeLetter != null) {
            Navigator.pushNamed(context, '/grades_detail', arguments: grade);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  grade["Assignment"],
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
              if (grade != null && gradeLetter != null)
                Icon(
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
          return _buildCard(context, _data[i],
              Theme.of(context).primaryColorLight, Theme.of(context).cardColor);
        });
  }
}
