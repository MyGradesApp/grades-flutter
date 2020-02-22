import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sis_loader/sis_loader.dart';

class GradePersistence extends ChangeNotifier {
  // TODO: Implement some types in sis-loader
  // Grade = Map<String, String>
  // Map<class name, list of grades>
  Map<String, List<Grade>> _originalData = {};
  Map<String, List<Grade>> _data = {};
  SharedPreferences _prefs;

  Map<String, List<Grade>> get originalData => _originalData;

  GradePersistence(SharedPreferences prefs) {
    _prefs = prefs;
    _originalData = _load();
    _data = Map.from(_originalData);
    notifyListeners();
  }

  void insert(String key, List<Grade> data) {
    _data[key] = data;
    _save();
    notifyListeners();
  }

  List<Grade> getData(String key) {
    return _data[key] ?? [];
  }

  List<Grade> getOriginalData(String key) {
    return _originalData[key] ?? [];
  }

  void _save() {
    _prefs.setString("persisted_grades_v3", jsonEncode(_data));
  }

  Map<String, List<Grade>> _load() {
    var gradesStr = _prefs.getString("persisted_grades_v3");
    if (gradesStr == null || gradesStr.isEmpty) {
      gradesStr = "{}";
    }

    Map<String, List<Grade>> out = {};

    Map<String, dynamic> dynCourses = Map<String, dynamic>.from(
        jsonDecode(gradesStr) as Map<String, dynamic>);
    dynCourses.forEach((String course, dynamic gradesListDyn) {
      List<Grade> grades = [];
      List<dynamic> gradesList = List.from(gradesListDyn as List);

      gradesList.forEach((dynamic grade) {
        // TODO: Is this all needed now that we have `Grade`?
        Map<String, dynamic> dynGrade = grade as Map<String, dynamic>;
        grades.add(
          Grade(dynGrade.map((key, value) => MapEntry(key, value.toString()))),
        );
      });

      out[course] = grades;
    });

    return out;
  }

  void clearSaved() {
    _data = {};
    _prefs.remove("persisted_grades_v3");
    notifyListeners();
  }
}
