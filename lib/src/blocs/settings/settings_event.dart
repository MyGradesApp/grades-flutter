part of 'settings_bloc.dart';

abstract class SettingsEvent {
  const SettingsEvent();
}

class ToggleSettingsGroupingMode extends SettingsEvent{ }
