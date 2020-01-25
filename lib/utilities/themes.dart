import 'package:flutter/material.dart';

enum MyThemeKeys { LIGHT, DARK, DARKER }

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xff2a84d2),
    accentColor: const Color(0xff216bac),
    cardColor: const Color(0xffffffff),
    primaryColorLight: Colors.black,
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xff195080),
    accentColor: const Color(0xff216bac),
    cardColor: const Color(0xff2a84d2),
    brightness: Brightness.dark,
    primaryColorLight: Colors.white,
  );

  static final ThemeData darkerTheme = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      case MyThemeKeys.DARKER:
        return darkerTheme;
      default:
        return lightTheme;
    }
  }
}
