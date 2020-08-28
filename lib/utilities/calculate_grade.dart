import 'package:built_collection/built_collection.dart';
import 'package:grades/screens/course_grades/course_grades_view.dart';
import 'package:sis_loader/sis_loader.dart';

String calculateGradePercent(Map<ToHeader, List<Grade>> groupedGrades,
    BuiltMap<String, String> weights) {
  var groupKeys = groupedGrades.keys.toList()..sort(), _classPercent = 0.0;
  for (var i = 0; i < groupKeys.length; i++) {
    var _groupTotal = 0.0;
    var cat = groupKeys[i], grades = groupedGrades[cat];
    for (var j = 0; j < grades.length; j++) {
      var gradeString = grades[j].grade;
      if (gradeString.indexOf('%') != -1) {
        var gradePercent =
            double.tryParse(gradeString.substring(0, gradeString.indexOf('%')));
        _groupTotal += gradePercent;
        print('points ' + grades[j].points);
        print('percent ' + gradePercent.toString());
      }
    }
    print(double.tryParse(
            weights[cat.raw()].substring(0, weights[cat.raw()].indexOf('%'))) /
        100.0);
    _groupTotal = (_groupTotal / grades.length) *
        ((weights != null)
            ? (double.tryParse(weights[cat.raw()]
                    .substring(0, weights[cat.raw()].indexOf('%'))) /
                100.0)
            : 1.0);
    print('group ' + _groupTotal.toString());
    _classPercent += _groupTotal;
  }
  return _classPercent.toStringAsFixed(2);
}
