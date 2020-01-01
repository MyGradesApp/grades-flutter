import 'package:flutter/material.dart';
import 'package:grades/widgets/colored_grade_dot.dart';

class ClassListItemWidget extends StatelessWidget {
  ClassListItemWidget(
      {@required this.course,
      @required this.teacher,
      @required this.letterGrade,
      @required this.percent,
      this.onTap});

  final String course;
  final String teacher;
  final String letterGrade;
  final num percent;
  final void Function() onTap;

  Widget _buildColumn(
      String topText, String bottomText, CrossAxisAlignment alignment,
      {bool chevron = false, String grade}) {
    return Column(crossAxisAlignment: alignment, children: <Widget>[
      Text(
        topText,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 19, color: Colors.black),
      ),
      Padding(
        child: Container(
          child: Row(
            children: <Widget>[
              if (grade != null) ColoredGradeDot.grade(grade),
              SizedBox(width: 3),
              Text(
                bottomText,
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              if (chevron)
                Icon(
                  Icons.chevron_right,
                  color: Colors.black26,
                )
            ],
          ),
        ),
        padding: EdgeInsets.only(top: 30),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Theme.of(context).primaryColor,
      color: Color(0xffffffff),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 15),
          child: Row(children: <Widget>[
            Expanded(
              child: _buildColumn(
                  this.course, this.teacher, CrossAxisAlignment.start),
            ),
            _buildColumn('$percent%', this.letterGrade, CrossAxisAlignment.end,
                chevron: true, grade: this.letterGrade),
          ]),
        ),
      ),
    );
  }
}
