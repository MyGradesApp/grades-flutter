part of 'settings_bloc.dart';

enum GroupingMode { Date, Category }

extension GroupingModeMethods on GroupingMode {
  String asString() {
    if (this == GroupingMode.Date) {
      return 'date';
    } else {
      return 'category';
    }
  }

  GroupingMode toggled() {
    if (this == GroupingMode.Category) {
      return GroupingMode.Date;
    } else {
      return GroupingMode.Category;
    }
  }

  static GroupingMode groupingModeFromString(String src) {
    if (src == 'date') {
      return GroupingMode.Date;
    } else if (src == 'category') {
      return GroupingMode.Category;
    } else {
      throw FormatException('Invalid value: ${src}');
    }
  }
}

class SettingsState {
  final GroupingMode groupingMode;

  const SettingsState({
    @required this.groupingMode,
  });

  SettingsState update({GroupingMode groupingMode}) {
    return SettingsState(
      groupingMode: groupingMode ?? this.groupingMode,
    );
  }

  static SettingsState defaultSettings() {
    return SettingsState(groupingMode: GroupingMode.Category);
  }
}
