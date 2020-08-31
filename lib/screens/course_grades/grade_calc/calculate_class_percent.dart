import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grades/screens/course_grades/course_grades_view.dart';
import 'package:grades/screens/course_grades/grade_calc/dummy_grades.dart';
import 'package:sis_loader/sis_loader.dart';

double calculateClassPercent(Map<ToHeader, List<Grade>> groupedGrades,
    BuiltMap<String, String> weights, List<DummyGrade> dummyGrades) {
  var groupKeys = groupedGrades.keys.toList()..sort();
  var classPercent = 0.0;

  for (var group in groupKeys) {
    print(group);
    var groupTotal = 0.0;
    var grades = [...groupedGrades[group]];
    if (grades.isNotEmpty) {
      if (dummyGrades.isNotEmpty) {
        for (var dummy in dummyGrades) {
          if (group.toHeader().contains(dummy.category)) {
            grades.add(dummy);
          }
        }
      }
      for (var gradeItem in grades) {
        if (gradeItem != null) {
          var index = gradeItem.grade.indexOf('%');
          if (index != -1) {
            var gradePercent =
                double.tryParse(gradeItem.grade.substring(0, index));
            groupTotal += gradePercent;
          }
        }
      }
      groupTotal = (groupTotal / grades.length);
    } else {
      groupTotal = 100;
    }
    dynamic cat = group.raw();
    groupTotal = groupTotal *
        ((weights != null && cat != null)
            ? (double.tryParse(
                    weights[cat].substring(0, weights[cat].indexOf('%'))) /
                100.0)
            : 1.0);
    classPercent += groupTotal;
  }
  print(classPercent);
  return classPercent;
}

Widget getClassPercentageWidget(
    Map<ToHeader, List<Grade>> groupedGrades,
    BuiltMap<String, String> weights,
    List<DummyGrade> dummyGrades,
    StringOrInt sisPercent) {
  var classPercentWithDecimal =
      calculateClassPercent(groupedGrades, weights, dummyGrades);

  if (classPercentWithDecimal.round() == int.tryParse(sisPercent.toString()) &&
      dummyGrades.isEmpty) {
    return Center(
      child: Text(
        classPercentWithDecimal.toStringAsFixed(2) + '%',
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  } else if (dummyGrades.isNotEmpty) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          sisPercent.toString() + '%',
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Icon(
            Icons.arrow_forward,
            color: Colors.white,
          ),
        ),
        Text(
          classPercentWithDecimal.toStringAsFixed(2) + '%',
          style: TextStyle(
              color: Colors.pink, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ],
    );
  } else {
    return Center(
      child: Text(
        sisPercent.toString() + '%',
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}
