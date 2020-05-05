import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/material.dart' hide Builder;
import 'package:meta/meta.dart';

part 'settings_bloc.g.dart';
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
    stateSaver(state);
  }

  Stream<SettingsState> _mapToggleGroupingModeToState() async* {
    yield state.rebuild((s) => s
      ..groupingMode = state.groupingMode == GroupingMode.category
          ? GroupingMode.date
          : GroupingMode.category);
  }
}
