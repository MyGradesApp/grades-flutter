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
  var classPercent = 0.0, gradesCount = 0.0;
  var weightedList = <Map<String, Grade>>[];
  for (var group in groupKeys) {
    for (var gradeItem in groupedGrades[group]) {
      if (weights != null) {
        if (weights.entries.isNotEmpty) {
          for (var weight in weights.entries) {
            if (weight.key.contains(gradeItem.category)) {
              weightedList.add({weight.key: gradeItem});
            }
          }
        }
      } else {
        var index = gradeItem.grade.indexOf('%');
        if (index != -1) {
          var gradePercent =
              double.tryParse(gradeItem.grade.substring(0, index));
          classPercent += gradePercent;
          gradesCount++;
        }
      }
    }
  }
  if (weights != null) {
    for (var weight in weights.entries) {
      var groupTotal = 0.0, weightedGroupCount = 0;
      for (var weightedItem in weightedList) {
        if (weightedItem.containsKey(weight.key)) {
          var index = weightedItem.values.last.grade.indexOf('%');
          if (index != -1) {
            var gradePercent = double.tryParse(
                weightedItem.values.last.grade.substring(0, index));
            groupTotal += gradePercent;
            weightedGroupCount++;
          }
        }
      }
      // TODO: determine accurate way of finding percentage when categories have no grades (for now, just multiply category weight by 100)
      if (weightedGroupCount > 0) {
        groupTotal = (groupTotal / weightedGroupCount);
      } else {
        groupTotal = 100.0;
      }
      groupTotal = groupTotal *
          (double.tryParse(
                  weight.value.substring(0, weight.value.indexOf('%'))) /
              100.0);
      classPercent += groupTotal;
      //TODO: Alternative method being considered - disregard category entirely if no grades present (appears to be closer to what SIS does?)
      // if (count > 0) {
      //   groupTotal = (groupTotal / count);
      //   groupTotal = groupTotal *
      //       (double.tryParse(
      //               weight.value.substring(0, weight.value.indexOf('%'))) /
      //           100.0);
      //   classPercent += groupTotal;
      // }
    }
  }

  if (gradesCount > 0) {
    classPercent = classPercent / gradesCount;
  }

  print(classPercent);
  return classPercent;
}

Widget getClassPercentageWidget(
    Map<ToHeader, List<Grade>> groupedGrades,
    BuiltMap<String, String> weights,
    List<DummyGrade> dummyGrades,
    StringOrInt sisPercent) {
  var classPercentWithDecimal = calculateClassPercent(groupedGrades, weights);
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
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xff216bac),
          ),
          child: Text(
            (sisPercent ?? 'N/G').toString() + (sisPercent != null ? '%' : ''),
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
            classPercentWithDecimal.toStringAsFixed(2) + '%',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  } else {
    return Center(
      child: Text(
        (sisPercent ?? 'N/G').toString() + (sisPercent != null ? '%' : ''),
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }
}
