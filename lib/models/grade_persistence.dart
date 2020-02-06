import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GradeStatus {
//  Updated,
  New,
  NoChange,
}

class GradePersistence extends ChangeNotifier {
  Map<String, String> _data = {};
  SharedPreferences _prefs;

  GradePersistence(SharedPreferences prefs) {
    _prefs = prefs;
    _data = _load();
    notifyListeners();
  }

  void insert(String key, dynamic data) {
    _data[key] = jsonEncode(data, toEncodable: (value) => value.toString());
    _save();
    notifyListeners();
  }

  GradeStatus getDiff(String key, dynamic data) {
    var d;
    if (data is String) {
      d = data;
    } else {
      d = jsonEncode(data, toEncodable: (v) => v.toString());
    }
    if (_data[key] != d) {
      return GradeStatus.New;
    }
    return GradeStatus.NoChange;
  }

  void _save() {
    _prefs.setString("persisted_grades", jsonEncode(_data));
  }

  Map<String, String> _load() {
    var gradesStr = _prefs.getString("persisted_grades");
    if (gradesStr == null || gradesStr.isEmpty) {
      gradesStr = "{}";
    }

    return Map<String, String>.from(jsonDecode(gradesStr));
  }

  void clearSaved() {
    _data = {};
    _prefs.remove("persisted_grades");
    notifyListeners();
  }
}
