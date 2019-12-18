import 'package:flutter/material.dart';

class ClassGradeWidget extends StatelessWidget {
  ClassGradeWidget({this.course, this.teacher, this.letterGrade, this.percent});

  final String course;
  final String teacher;
  final String letterGrade;
  final num percent;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            const EdgeInsets.only(left: 22, right: 22, top: 28, bottom: 16),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: new BorderRadius.all(const Radius.circular(10))),
        child: Row(children: <Widget>[
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                this.course,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              Padding(
                child: Text(this.teacher),
                padding: EdgeInsets.only(top: 30),
              )
            ],
          )),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '$percent%',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
              ),
              Padding(
                child: Text(this.letterGrade),
                padding: EdgeInsets.only(top: 30),
              )
            ],
          )),
        ]));
  }
}
