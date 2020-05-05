part of 'settings_bloc.dart';

class GroupingMode extends EnumClass {
  static const GroupingMode date = _$date;
  static const GroupingMode category = _$category;

  static Serializer<GroupingMode> get serializer => _$groupingModeSerializer;

  const GroupingMode._(String name) : super(name);

  static BuiltSet<GroupingMode> get values => _$values;
  static GroupingMode valueOf(String name) => _$valueOf(name);

  GroupingMode toggled() {
    if (this == GroupingMode.category) {
      return GroupingMode.date;
    } else {
      return GroupingMode.category;
    }
  }
}

abstract class SettingsState
    implements Built<SettingsState, SettingsStateBuilder> {
  GroupingMode get groupingMode;

  SettingsState._();

  factory SettingsState([void Function(SettingsStateBuilder) updates]) =
      _$SettingsState;

  static SettingsState defaultSettings() {
    return SettingsState((s) => s..groupingMode = GroupingMode.category);
  }

  static Serializer<SettingsState> get serializer => _$settingsStateSerializer;
}
