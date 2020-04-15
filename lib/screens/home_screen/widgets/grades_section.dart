import 'package:flutter/widgets.dart';
import 'package:sis_loader/sis_loader.dart';

class CourseGrades extends StatelessWidget {
  final String title;
  final List<Grade> grades;

  CourseGrades(this.title, this.grades);

  @override
  Widget build(BuildContext context) {
    if (grades.isNotEmpty) {
      return Column(
        children: <Widget>[
          Text(title),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: grades.length,
            itemBuilder: (context, i) {
              return Text(grades[i].name);
            },
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
