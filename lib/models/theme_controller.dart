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

GroupingMode getToggledGroupingMode(GroupingMode mode) {
  if (mode == GroupingMode.Category) {
    return GroupingMode.Date;
  } else {
    return GroupingMode.Category;
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
    GroupingMode defaultGroupMode;
    try {
      defaultGroupMode = groupingModeFromString(defaultGroupModeStr);
    } catch (_) {
      defaultGroupMode = GroupingMode.Category;
    }
    _defaultGroupMode = defaultGroupMode;
  }

  final SharedPreferences _prefs;
  String _currentTheme;
  GroupingMode _defaultGroupMode;

  String get currentTheme => _currentTheme;

  GroupingMode get defaultGroupMode => _defaultGroupMode;

  void setTheme(String theme) {
    _currentTheme = theme;

    notifyListeners();

    _prefs.setString(themePrefKey, theme);
  }

  void setDefaultGroupingMode(GroupingMode mode) {
    _defaultGroupMode = mode;

    notifyListeners();

    _prefs.setString(defaultGroupKey, groupingModeToString(mode));
  }
}
