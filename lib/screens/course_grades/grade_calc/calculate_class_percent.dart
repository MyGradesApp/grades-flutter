import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grades/screens/course_grades/course_grades_view.dart';
import 'package:grades/screens/course_grades/grade_calc/dummy_grades.dart';
import 'package:sis_loader/sis_loader.dart';

double calculateClassPercent(Map<ToHeader, List<Grade>> groupedGrades,
    BuiltMap<String, String> weights) {
  var groupNumerators = <String, List<double>>{};
  var groupDenomonators = <String, List<double>>{};
  var categories = <String>{};
  for (var gradeGroup in groupedGrades.entries) {
    // TODO: Group
    var grades = gradeGroup.value;
    for (var grade in grades) {
      if (grade.pointsEarned == null || grade.pointsPossible == null) {
        continue;
      }
      categories.add(grade.category);
      var pointsEarned = double.tryParse(grade.pointsEarned);
      var pointsPossible = double.tryParse(grade.pointsPossible);
      if (pointsEarned == null || pointsPossible == null) {
        continue;
      }
      (groupNumerators[grade.category] ??= []).add(pointsEarned);
      (groupDenomonators[grade.category] ??= []).add(pointsPossible);
    }
  }

  var total = 0.0;
  for (var weightEntry in weights.entries) {
    var category = weightEntry.key;
    var rawWeight = weightEntry.value;
    var weight = 100.0;
    if (rawWeight != null) {
      weight = double.tryParse(rawWeight.substring(0, rawWeight.indexOf('%')));
      if (weight == 0 && weights.length == 1) {
        weight = 100.0;
      }
    }
    var numeratorSum = ((groupNumerators[category] ?? [1])
        .fold<double>(0, (previousValue, element) => previousValue + element));
    var denomSum = ((groupDenomonators[category] ?? [1])
        .fold<double>(0, (previousValue, element) => previousValue + element));
    if (denomSum == 0.0) {
      denomSum = 1.0;
    }
    total += (numeratorSum / denomSum) * weight;
  }

  if (weights.isEmpty) {
    var numeratorSum = 0.0;
    var denomSum = 0.0;
    for (var category in categories) {
      numeratorSum += ((groupNumerators[category] ?? [])
          .fold(0, (previousValue, element) => previousValue + element));
      denomSum += ((groupDenomonators[category] ?? [])
          .fold(0, (previousValue, element) => previousValue + element));
    }
    if (denomSum == 0.0) {
      denomSum = 1.0;
    }
    total += (numeratorSum / denomSum) * 100;
  }

  if (total == 0.0 && weights.keys.every((item) => item == 'Conduct')) {
    total = -1;
  }
  return total;
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
  if (!classPercentWithDecimal.isFinite) {
    return Center(
      child: Text(
        '??%',
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
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
