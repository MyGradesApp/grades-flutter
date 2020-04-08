import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sis_loader/sis_loader.dart';

class DataPersistence {
  final SharedPreferences prefs;
  Map<String, List<Grade>> _grades;
  List<Course> _courses;

  DataPersistence(this.prefs) {
    _grades = _loadGrades();
    _courses = _loadCourses();
  }

  Map<String, List<Grade>> get grades => _grades;

  set grades(Map<String, List<Grade>> grades) {
    _grades = grades;
    _saveGrades();
  }

  void setGradesForCourse(String course, List<Grade> grades) {
    _grades[course] = grades;
    _saveGrades();
  }

  List<Course> get courses => _courses;

  set courses(List<Course> courses) {
    _courses = courses;
    _saveCourses();
  }

  Map<String, List<Grade>> _loadGrades() {
    var gradesStr = prefs.getString('persisted_grades_v2');
    if (gradesStr == null || gradesStr.isEmpty || gradesStr == 'null') {
      gradesStr = '{}';
    }

    var out = <String, List<Grade>>{};

    var dynCourses = Map<String, dynamic>.from(
        jsonDecode(gradesStr) as Map<String, dynamic>);
    dynCourses.forEach((String course, dynamic gradesListDyn) {
      var grades = <Grade>[];
      var gradesList = List<dynamic>.from(gradesListDyn as List);

      gradesList.forEach((dynamic grade) {
        var dynGrade = grade as Map<String, dynamic>;
        grades.add(
          Grade(dynGrade.map((k, dynamic v) => MapEntry(k, v as String))),
        );
      });

      out[course] = grades;
    });

    return out;
  }

  void _saveGrades() {
    prefs.setString('persisted_grades_v2', jsonEncode(grades));
  }

  List<Course> _loadCourses() {
    var coursesString = prefs.getString('persisted_courses_v2');
    if (coursesString == null ||
        coursesString.isEmpty ||
        coursesString == 'null') {
      coursesString = '[]';
    }

    return (jsonDecode(coursesString) as List<dynamic>)
        .map((dynamic data) => Course.fromJson(data as Map<String, dynamic>))
        .toList();
  }

  void _saveCourses() {
    prefs.setString('persisted_courses_v2', jsonEncode(courses));
  }
}
