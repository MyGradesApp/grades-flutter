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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 11.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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
      // No grades in this course, so we don't display anything
      return Container();
    }
  }
}
