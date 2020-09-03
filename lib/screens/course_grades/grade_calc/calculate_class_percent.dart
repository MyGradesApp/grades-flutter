import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grades/screens/course_grades/course_grades_view.dart';
import 'package:grades/screens/course_grades/grade_calc/dummy_grades.dart';
import 'package:quiver/pattern.dart';
import 'package:sis_loader/sis_loader.dart';

double calculateClassPercent(Map<ToHeader, List<Grade>> groupedGrades,
    BuiltMap<String, String> weights) {
  var groupKeys = groupedGrades.keys.toList()..sort();
  var classPercent = 0.0, gradesCount = 0.0, weightedDenominatorList = <int>[];
  var weightedList = <Map<String, Grade>>[];
  var containsOnlyConduct = false;

  // for every grade:
  for (var group in groupKeys) {
    for (var gradeItem in groupedGrades[group]) {
      if (weights != null) {
        // for each weight, add it to a "weighted" list
        for (var weight in weights.entries) {
          if (weight.value != '0%') {
            // print('we' + weight.value);

            if (weight.key.contains(gradeItem.category)) {
              // if a category is empty, use the following to determine new percentages

              var x = 0;
              weightedList.forEach((grade) {
                if (grade.containsKey(weight.key)) {
                  x++;
                }
              });

              if (x == 0) {
                weightedDenominatorList.add(int.tryParse(
                    weight.value.substring(0, weight.value.indexOf('%'))));
                print(weightedDenominatorList);
              }

              weightedList.add({weight.key: gradeItem});
            }
          } else {
            if (weightedList.isEmpty) {
              containsOnlyConduct = true;
            }
          }
        }
      } else {
        // if a class has no grades, add it to the class as normal
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
      if (weight.value != '0%' && weightedList.isNotEmpty) {
        var groupTotal = 0.0, weightedGroupCount = 0;
        for (var weightedItem in weightedList) {
          // print(weight.value);
          if (weightedItem.containsKey(weight.key)) {
            var index = weightedItem.values.last.grade.indexOf('%');
            if (index != -1) {
              var gradePercent = double.tryParse(
                  weightedItem.values.last.grade.substring(0, index));
              // print('grade');
              // print(gradePercent);
              groupTotal += gradePercent;
              weightedGroupCount++;
            }
          }
        }
        // TODO: determine accurate way of finding percentage when categories have no grades (for now, just multiply category weight by 100)
        if (weightedGroupCount > 0) {
          // print('group bef div' + groupTotal.toString());
          groupTotal = groupTotal / weightedGroupCount;
        }
        if (weights.entries.length != weightedDenominatorList.length) {
          var weightedDenominator = 0.0;
          for (var den in weightedDenominatorList) {
            weightedDenominator += den;
          }
          print('group');
          print(groupTotal);
          groupTotal = groupTotal *
              (double.tryParse(
                      weight.value.substring(0, weight.value.indexOf('%'))) /
                  weightedDenominator);
          print((weight.value.substring(0, weight.value.indexOf('%')))
                  .toString() +
              '/' +
              weightedDenominator.toString());
        } else {
          groupTotal = groupTotal *
              (double.tryParse(
                      weight.value.substring(0, weight.value.indexOf('%'))) /
                  100.0);
        }

        classPercent += groupTotal;
      }
    }

    if (classPercent == 0.0 &&
        weights.containsValue('0%') &&
        containsOnlyConduct) {
      classPercent = -1;
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
            classPercentWithDecimal.round() != -1
                ? classPercentWithDecimal.toStringAsFixed(2)
                : 'N/G' + (classPercentWithDecimal != -1 ? '%' : ''),
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
