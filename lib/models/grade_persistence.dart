import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GradePersistence extends ChangeNotifier {
  // TODO: Implement some types in sis-loader
  // Grade = Map<String, String>
  // Map<class name, list of grades>
  Map<String, List<Map<String, String>>> _originalData = {};
  Map<String, List<Map<String, String>>> _data = {};
  SharedPreferences _prefs;

  Map<String, List<Map<String, String>>> get originalData => _originalData;

  GradePersistence(SharedPreferences prefs) {
    _prefs = prefs;
    _originalData = _load();
    _data = Map.from(_originalData);
    notifyListeners();
  }

  void insert(String key, List<Map<String, dynamic>> data) {
    List<Map<String, String>> stringyData = data
        .map((e) => e.map((key, value) => MapEntry(key, value.toString())))
        .toList();
    _data[key] = stringyData;
    _save();
    notifyListeners();
  }

  List<Map<String, String>> getData(String key) {
    return _data[key] ?? [];
  }

  List<Map<String, String>> getOriginalData(String key) {
    return _originalData[key] ?? [];
  }

  void _save() {
    _prefs.setString("persisted_grades_v2", jsonEncode(_data));
  }

  Map<String, List<Map<String, String>>> _load() {
    var gradesStr = _prefs.getString("persisted_grades_v2");
    if (gradesStr == null || gradesStr.isEmpty) {
      gradesStr = "{}";
    }
    var out = {};
    Map<String, List<dynamic>>.from(jsonDecode(gradesStr))
        .forEach((key, value) {
      List<Map<String, String>> grades = [];
      grades = value.map((e) => Map<String, String>.from(e)).toList();
      out[key] = grades;
    });

    return Map<String, List<Map<String, String>>>.from(out);
  }

  void clearSaved() {
    _data = {};
    _prefs.remove("persisted_grades_v2");
    notifyListeners();
  }
}
