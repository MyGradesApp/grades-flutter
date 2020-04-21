import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grades/widgets/grade_item_card.dart';
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
              var grade = grades[i];
              return GradeItemCard(
                grade: grade,
                textColor: Theme.of(context).primaryColorLight,
                cardColor: Theme.of(context).cardColor,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/grade_info',
                    arguments: grade,
                  );
                },
              );
            },
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
