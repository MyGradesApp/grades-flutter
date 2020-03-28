import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:grades/sis-cache/sis_loader.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sis_loader/sis_loader.dart';

// TODO: Make this less of a hack
DataPersistence GLOBAL_DATA_PERSISTENCE;

class DataPersistence extends ChangeNotifier {
  // Map<class name, list of grades>
  Map<String, List<Grade>> _originalGrades = {};
  Map<String, List<Grade>> _grades = {};
  Map<String, String> _weights = {};
  List<CachedCourse> _courses = [];
  SharedPreferences _prefs;

  DataPersistence(SharedPreferences prefs) {
    _prefs = prefs;
    _originalGrades = _loadGrades();
    _grades = Map.from(_originalGrades);
    _weights = _loadWeights();
    _courses = _loadCourses();
    notifyListeners();
  }

  UnmodifiableListView<CachedCourse> get courses =>
      UnmodifiableListView(_courses);

  void setCourses(List<CachedCourse> value) {
    _courses = value;
    _saveCourses();
    notifyListeners();
  }

  UnmodifiableMapView<String, String> get weights =>
      UnmodifiableMapView(_weights);

  void setWeights(Map<String, String> weights) {
    _weights = weights;
    _saveWeights();
    notifyListeners();
  }

  Map<String, List<Grade>> get originalGrades => _originalGrades;

  void insertGrades(String key, List<Grade> grades) {
    _grades[key] = grades;
    _saveGrades();
    notifyListeners();
  }

  void markOldAsRead(String key) {
    _originalGrades[key] = _grades[key];
    notifyListeners();
  }

  List<Grade> getGrades(String key) {
    return _grades[key] ?? [];
  }

  List<Grade> getOriginalGrades(String key) {
    return _originalGrades[key] ?? [];
  }

  void _saveGrades() {
    _prefs.setString('persisted_grades_v2', jsonEncode(_grades));
  }

  Map<String, List<Grade>> _loadGrades() {
    var gradesStr = _prefs.getString('persisted_grades_v2');
    if (gradesStr == null || gradesStr.isEmpty || gradesStr == 'null') {
      gradesStr = '{}';
    }

    var out = <String, List<Grade>>{};

    try {
      var dynCourses = Map<String, dynamic>.from(
          jsonDecode(gradesStr) as Map<String, dynamic>);
      dynCourses.forEach((String course, dynamic gradesListDyn) {
        var grades = <Grade>[];
        var gradesList = List<dynamic>.from(gradesListDyn as List);

        gradesList.forEach((dynamic grade) {
          var dynGrade = grade as Map<String, dynamic>;
          grades.add(
            Grade(dynGrade.map((key, value) => MapEntry(key, value as String))),
          );
        });

        out[course] = grades;
      });
    } catch (e, stackTrace) {
      reportException(exception: e, stackTrace: stackTrace);
      return {};
    }

    return out;
  }

  void _saveCourses() {
    _prefs.setString('persisted_courses_v2', jsonEncode(_courses));
  }

  List<CachedCourse> _loadCourses() {
    var coursesString = _prefs.getString('persisted_courses_v2');
    if (coursesString == null ||
        coursesString.isEmpty ||
        coursesString == 'null') {
      coursesString = '[]';
    }

    try {
      var loadedCourses = (jsonDecode(coursesString) as List<dynamic>)
          .map(
              (course) => CachedCourse.fromJson(course as Map<String, dynamic>))
          .toList();
      return loadedCourses;
    } catch (e, stackTrace) {
      reportException(exception: e, stackTrace: stackTrace);
      return [];
    }
  }

  Map<String, String> _loadWeights() {
    var weightsString = _prefs.getString('persisted_weights_v2');
    if (weightsString == null ||
        weightsString.isEmpty ||
        weightsString == 'null') {
      weightsString = '{}';
    }

    try {
      var loadedWeights =
          Map<String, String>.from(jsonDecode(weightsString) as Map);

      return loadedWeights;
    } catch (e, stackTrace) {
      reportException(exception: e, stackTrace: stackTrace);
      return {};
    }
  }

  void _saveWeights() {
    _prefs.setString('persisted_weights_v2', jsonEncode(_weights));
  }

  void clearSaved() {
    _grades = {};
    _prefs.remove('persisted_grades_v2');
    _prefs.remove('persisted_courses_v2');
    _prefs.remove('persisted_weights_v2');
    notifyListeners();
  }
}
