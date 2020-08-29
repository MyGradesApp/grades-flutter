import 'package:built_collection/built_collection.dart';
import 'package:grades/screens/course_grades/course_grades_view.dart';
import 'package:sis_loader/sis_loader.dart';

double calculateClassPercent(Map<ToHeader, List<Grade>> groupedGrades,
    BuiltMap<String, String> weights) {
  var groupKeys = groupedGrades.keys.toList()..sort();
  var classPercent = 0.0;
  for (var group in groupKeys) {
    var groupTotal = 0.0;
    var grades = groupedGrades[group];
    for (var gradeItem in grades) {
      var index = gradeItem.grade.indexOf('%');
      if (index != -1) {
        var gradePercent = double.tryParse(gradeItem.grade.substring(0, index));
        groupTotal += gradePercent;
      }
    }
    groupTotal = (groupTotal / grades.length) *
        ((weights != null)
            ? (double.tryParse(weights[group.raw()]
                    .substring(0, weights[group.raw()].indexOf('%'))) /
                100.0)
            : 1.0);
    classPercent += groupTotal;
  }
  return classPercent;
}

class DummyGrade {
  String _gradePercent;
  String _category;

  DummyGrade(String grade, String cat) {
    _gradePercent = grade;
    _category = cat;
  }

  String get grade => _gradePercent;

  String get name => 'Dummy Assignment';

  String get category => _category;

  String get points => '${_gradePercent} / ${_gradePercent}';
}
