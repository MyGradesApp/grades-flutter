import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  // TODO: Make these into a class?
  final SettingsState Function() initialStateSource;
  final void Function(SettingsState) stateSaver;

  SettingsBloc({@required this.initialStateSource, @required this.stateSaver});

  @override
  SettingsState get initialState => initialStateSource();

  @override
  Stream<SettingsState> mapEventToState(
    SettingsEvent event,
  ) async* {
    if (event is ToggleSettingsGroupingMode) {
      yield* _mapToggleGroupingModeToState();
    }
  }

  Stream<SettingsState> _mapToggleGroupingModeToState() async* {
    yield state.update(
        groupingMode: state.groupingMode == GroupingMode.Category
            ? GroupingMode.Date
            : GroupingMode.Category);
  }
}
