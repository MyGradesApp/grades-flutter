import 'package:flutter/material.dart';

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
      String topText, String bottomText, CrossAxisAlignment alignment) {
    return Expanded(
        child: Column(crossAxisAlignment: alignment, children: <Widget>[
      Text(
        topText,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
      ),
      Padding(
        child: Text(bottomText),
        padding: EdgeInsets.only(top: 30),
      ),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      elevation: 3,
      margin: EdgeInsets.all(15),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 25, bottom: 15),
          child: Row(children: <Widget>[
            _buildColumn(this.course, this.teacher, CrossAxisAlignment.start),
            _buildColumn('$percent%', this.letterGrade, CrossAxisAlignment.end)
          ]),
        ),
      ),
    );
  }
}
