import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// provides the currently selected theme, saves changed theme preferences to disk
class ThemeController extends ChangeNotifier {
  static const themePrefKey = 'theme';

  ThemeController(this._prefs) {
    // load theme from preferences on initialization
    _currentTheme = _prefs.getString(themePrefKey) ?? 'light';
  }

  final SharedPreferences _prefs;
  String _currentTheme;

  /// get the current theme
  String get currentTheme => _currentTheme;

  void setTheme(String theme) {
    _currentTheme = theme;

    // notify the app that the theme was changed
    notifyListeners();

    // store updated theme on disk
    _prefs.setString(themePrefKey, theme);
  }
}
