import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grades/screens/course_grades/course_grades_view.dart';
import 'package:grades/screens/course_grades/grade_calc/dummy_grades.dart';
import 'package:sis_loader/sis_loader.dart';

double calculateClassPercent(Map<ToHeader, List<Grade>> groupedGrades,
    BuiltMap<String, String> weights) {
  var groupKeys = groupedGrades.keys.toList()..sort();
  var classPercent = 0.0, gradesCount = 0.0, weightedDenominatorList = <int>[];
  var weightedGradeList = <Map<String, Map<String, Grade>>>[];

  for (var group in groupKeys) {
    for (var gradeItem in groupedGrades[group]) {
      if (weights != null) {
        for (var weight in weights.entries) {
          if (weight.value != '0%') {
            if (weight.key.contains(
                gradeItem.category) /*&& gradeIsNumeric(gradeItem.grade)*/) {
              if (weightedGradeList
                  .every((item) => !(item.containsKey(weight.key)))) {
                weightedDenominatorList.add(int.tryParse(
                    weight.value.substring(0, weight.value.indexOf('%'))));
              }

              weightedGradeList.add({
                weight.key: {weight.value: gradeItem}
              });
            }
          }
        }
      } else {
        if (gradeItem.percentage != null) {
          classPercent += gradeItem.percentage * 100;
          gradesCount++;
        }
      }
    }
  }
  classPercent = classPercent / (gradesCount != 0 ? gradesCount : 1);

  // print(weightedGradeList);
  // print(weightedDenominatorList);

  if (weights != null && weightedDenominatorList.isNotEmpty) {
    weightedDenominatorList.forEach((weight) {
      var groupTotal = 0.0;
      gradesCount = 0;
      weightedGradeList.forEach((weightedItem) {
        if (weightedItem.values.first.containsKey(weight.toString() + '%')) {
          if (weightedItem.values.last.values.last.percentage != null) {
            groupTotal += weightedItem.values.last.values.last.percentage;
            gradesCount++;
          }
        }
      });
      groupTotal = groupTotal / (gradesCount != 0 ? gradesCount : 1);
      if (weights.entries.length != weightedDenominatorList.length) {
        groupTotal = groupTotal *
            (weight / weightedDenominatorList.fold(0, (num p, c) => p + c));
        // print((weight.toString() +
        //     '/' +
        //     (weightedDenominatorList.fold(0, (num p, c) => p + c).toString())));
      } else {
        groupTotal = groupTotal * (weight / 100);
      }
      classPercent += groupTotal;
    });
  }

  if (classPercent == 0.0 &&
      weightedGradeList.every((item) => item.containsKey('Conduct'))) {
    classPercent = -1;
  }

  // print(classPercent);
  return classPercent;
}

bool gradeIsNumeric(String s) {
  if (s == null) {
    return false;
  }
  var index = s.indexOf('%');
  return double.tryParse(s.substring(0, index != -1 ? index : s.length)) !=
      null;
}

Widget getClassPercentageWidget(
    Map<ToHeader, List<Grade>> groupedGrades,
    BuiltMap<String, String> weights,
    List<DummyGrade> dummyGrades,
    StringOrInt sisPercent) {
  var classPercentWithDecimal = calculateClassPercent(groupedGrades, weights);
  if ((classPercentWithDecimal.round() ?? 0) ==
          int.tryParse(sisPercent.toString()) &&
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
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xff216bac),
          ),
          child: Text(
            (sisPercent ?? 'NG').toString() +
                (gradeIsNumeric(sisPercent.toString()) ? '%' : ''),
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Icon(
            FontAwesomeIcons.arrowRight,
            color: Colors.white,
          ),
        ),
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color.fromARGB(255, 211, 117, 116),
          ),
          child: Text(
            (classPercentWithDecimal.round() != -1
                    ? classPercentWithDecimal.toStringAsFixed(2)
                    : 'NG') +
                (classPercentWithDecimal != -1 ? '%' : ''),
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  } else {
    return Center(
      child: Text(
        (sisPercent ?? 'NG').toString() +
            (gradeIsNumeric(sisPercent.toString()) ? '%' : ''),
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}
