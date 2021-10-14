import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';

extension ThemeModeExt on ThemeMode {
  static ThemeMode fromString(String str) {
    if (str == 'system') {
      return ThemeMode.system;
    } else if (str == 'light') {
      return ThemeMode.light;
    } else if (str == 'dark') {
      return ThemeMode.dark;
    }
    return null;
  }

  String toHumanString() {
    switch (this) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
    return null;
  }

  String toPrefsString() {
    switch (this) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
    return null;
  }
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  // TODO: Make these into a class?
  final ThemeMode Function() initialStateSource;
  final void Function(ThemeMode) stateSaver;

  ThemeBloc({@required this.initialStateSource, @required this.stateSaver})
      : super(initialStateSource());

  @override
  Stream<ThemeMode> mapEventToState(
    ThemeEvent event,
  ) async* {
    if (event is AdvanceTheme) {
      yield* _mapAdvanceThemeToState();
    }
    stateSaver(state);
  }

  Stream<ThemeMode> _mapAdvanceThemeToState() async* {
    if (state == ThemeMode.system) {
      yield ThemeMode.light;
    } else if (state == ThemeMode.light) {
      yield ThemeMode.dark;
    } else if (state == ThemeMode.dark) {
      yield ThemeMode.system;
    }
  }
}
