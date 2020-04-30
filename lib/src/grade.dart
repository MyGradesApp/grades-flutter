import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:intl/intl.dart';

part 'grade.g.dart';

final shortMonthDateFormat = DateFormat('MMM dd, yyyy hh:mm aa');
final shortMonthDayDateFormat = DateFormat('EEE, MMM dd, yyyy hh:mm aa');
final longMonthDateFormat = DateFormat('MMMM dd, yyyy, hh:mm aa');
final longMonthDayDateFormat = DateFormat('EEEE, MMM dd, yyyy hh:mm aa');
final shortDayTerseDateTimeFormat = DateFormat('EEE, MM/dd/yy hh:mm aa');

DateTime _parseDateTimeCascade(String src, [bool performRegexPass = true]) {
  try {
    return shortMonthDateFormat.parseLoose(src);
  } catch (_) {}
  try {
    return longMonthDateFormat.parseLoose(src);
  } catch (_) {}
  try {
    return shortMonthDayDateFormat.parseLoose(src);
  } catch (_) {}
  try {
    return shortDayTerseDateTimeFormat.parseLoose(src);
  } catch (_) {}
  try {
    return longMonthDayDateFormat.parseLoose(src);
  } catch (_) {}
  if (performRegexPass) {
    return _parseDateTimeCascade(
      src.replaceAllMapped(RegExp(r'\b(\d{1,2})(?:st|nd|rd|th)\b'), (match) {
        return '${match.group(1)}';
      }),
      false,
    );
  }

  return null;
}

abstract class Grade implements Built<Grade, GradeBuilder> {
  BuiltMap<String, String> get raw;

  Grade._();

  factory Grade(Map<String, String> raw) =>
      _$Grade._(raw: (raw..removeWhere((_, v) => v == null)).build());

  static Serializer<Grade> get serializer => _$gradeSerializer;

  String get grade => raw['Grade'];

  String get name => raw['Assignment'];

  String get category => raw['Category'];

  String get points => raw['Points'];

  DateTime get dateLastModified {
    if (raw['Date Last Modified'] != null) {
      return _parseDateTimeCascade(raw['Date Last Modified']);
    } else {
      return null;
    }
  }

  DateTime get assignedDate {
    if (raw['Assigned'] != null) {
      return _parseDateTimeCascade(raw['Assigned']);
    } else {
      return null;
    }
  }

  DateTime get dueDate {
    if (raw['Due'] != null) {
      return _parseDateTimeCascade(raw['Due']);
    } else {
      return null;
    }
  }
}
