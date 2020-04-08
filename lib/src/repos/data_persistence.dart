import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sis_loader/sis_loader.dart';

class DataPersistence {
  final SharedPreferences prefs;
  Map<Course, List<Grade>> grades;
  List<Course> _courses;

  List<Course> get courses => _courses;

  set courses(List<Course> value) {
    _courses = value;
    _saveCourses();
  }

  DataPersistence(this.prefs) {
    _courses = _loadCourses();
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
