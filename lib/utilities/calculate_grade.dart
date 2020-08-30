import 'package:built_collection/built_collection.dart';
import 'package:grades/screens/course_grades/course_grades_view.dart';
import 'package:sis_loader/sis_loader.dart';

double calculateClassPercent(Map<ToHeader, List<Grade>> groupedGrades,
    BuiltMap<String, String> weights, List<DummyGrade> dummyGrades) {
  var groupKeys = groupedGrades.keys.toList()..sort();
  var classPercent = 0.0;

  for (var group in groupKeys) {
    var groupTotal = 0.0;
    var grades = [...groupedGrades[group]];
    if (grades.isNotEmpty) {
      if (dummyGrades != null) {
        for (var dummy in dummyGrades) {
          if (group.toHeader().contains(dummy.category)) {
            grades.add(dummy);
          }
        }
      }
      for (var gradeItem in grades) {
        var index = gradeItem.grade.indexOf('%');
        if (index != -1) {
          var gradePercent =
              double.tryParse(gradeItem.grade.substring(0, index));
          groupTotal += gradePercent;
        }
      }
      groupTotal = (groupTotal / grades.length);
    } else {
      groupTotal = 100;
    }
    groupTotal = groupTotal *
        ((weights != null)
            ? (double.tryParse(weights[group.raw()]
                    .substring(0, weights[group.raw()].indexOf('%'))) /
                100.0)
            : 1.0);
    classPercent += groupTotal;
  }
  return classPercent;
}

class DummyGrade implements Grade {
  String _gradePercent;
  String _category;
  String _name;

  @override
  DummyGrade(String grade, String cat, int index) {
    _gradePercent = grade;
    _category = cat;
    _name = 'Dummy Assignment ' + (index + 1).toString();
  }

  @override
  String get grade => _gradePercent;

  @override
  String get name => _name;

  @override
  String get category => _category;

  @override
  String get points => '${_gradePercent} / ${_gradePercent}';

  @override
  BuiltMap<String, String> get raw => throw UnimplementedError();

  @override
  GradeBuilder toBuilder() {
    throw UnimplementedError();
  }

  @override
  DateTime get assignedDate => DateTime.now();

  @override
  DateTime get dateLastModified => DateTime.now();

  @override
  DateTime get dueDate => DateTime.now();

  @override
  Grade rebuild(any) {
    throw UnimplementedError();
  }
}
