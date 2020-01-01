import 'package:flutter/material.dart';
import 'package:grades/utilities/grades.dart';

class CourseGradesMinimalDisplay extends StatelessWidget {
  final List<Map<String, dynamic>> _data;

  CourseGradesMinimalDisplay(this._data);

  Widget _buildCard(Map<String, dynamic> grade) {
    var gradeString = grade["Grade"].toString();
    var percentIndex = gradeString.indexOf('%');
    var gradeLetter;
    if (percentIndex != -1) {
      gradeLetter = letterGradeForPercent(
          double.parse(gradeString.substring(0, percentIndex)));
    }
    return Card(
      color: Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                grade["Assignment"],
                style: TextStyle(color: Colors.black),
              ),
            ),
            if (gradeLetter != null)
              Text(
                gradeLetter,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            Container(
              width: 50,
              alignment: Alignment.centerRight,
              child: Text(
                gradeString,
                textAlign: TextAlign.end,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(_data.length);
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _data.length,
        itemBuilder: (context, i) {
          return _buildCard(_data[i]);
        });
  }
}
