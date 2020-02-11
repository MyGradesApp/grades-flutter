import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum GroupingMode { Date, Category }

// TODO: Change to extensions when they become viable
String groupingModeToString(GroupingMode mode) {
  if (mode == GroupingMode.Date) {
    return "date";
  } else {
    return "category";
  }
}

GroupingMode groupingModeFromString(String src) {
  if (src == "date") {
    return GroupingMode.Date;
  } else if (src == "category") {
    return GroupingMode.Category;
  } else {
    throw FormatException("Invalid value: ${src}");
  }
}

/// provides the currently selected theme, saves changed theme preferences to disk
class ThemeController extends ChangeNotifier {
  static const themePrefKey = 'theme';
  static const defaultGroupKey = 'default_grouping_mode';

  ThemeController(this._prefs) {
    // load theme from preferences on initialization
    _currentTheme = _prefs.getString(themePrefKey) ?? 'light';
    var defaultGroupModeStr = _prefs.getString(defaultGroupKey) ?? 'category';
    var defaultGroupMode;
    try {
      defaultGroupMode = groupingModeFromString(defaultGroupModeStr);
    } catch (_) {
      defaultGroupMode = GroupingMode.Category;
    }
    _defaultGroupMode = defaultGroupMode;
    _currentGroupMode = defaultGroupMode;
  }

  final SharedPreferences _prefs;
  String _currentTheme;
  GroupingMode _defaultGroupMode;
  GroupingMode _currentGroupMode;

  String get currentTheme => _currentTheme;

  GroupingMode get defaultGroupMode => _defaultGroupMode;

  GroupingMode get currentGroupMode => _currentGroupMode;

  void setTheme(String theme) {
    _currentTheme = theme;

    notifyListeners();

    _prefs.setString(themePrefKey, theme);
  }

  void setDefaultGroupingMode(GroupingMode mode) {
    _defaultGroupMode = mode;
    // Update the current value as well
    _currentGroupMode = mode;

    notifyListeners();

    _prefs.setString(defaultGroupKey, groupingModeToString(mode));
  }

  void setCurrentGroupingMode(GroupingMode mode) {
    _currentGroupMode = mode;

    notifyListeners();
  }

  void toggleGroupingMode() {
    if (_currentGroupMode == GroupingMode.Category) {
      _currentGroupMode = GroupingMode.Date;
    } else {
      _currentGroupMode = GroupingMode.Category;
    }

    notifyListeners();
  }
}
