import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:intl/intl.dart';
import 'package:sis_loader/sis_loader.dart';

part 'grade.g.dart';

final shortMonthDateFormat = DateFormat('MMM dd, yyyy hh:mm aa');
final shortMonthDayDateFormat = DateFormat('EEE, MMM dd, yyyy hh:mm aa');
final longMonthDateFormat = DateFormat('MMMM dd, yyyy, hh:mm aa');
final longMonthDayDateFormat = DateFormat('EEEE, MMM dd, yyyy hh:mm aa');
final shortDayTerseDateTimeFormat = DateFormat('EEE, MM/dd/yy hh:mm aa');
final terseNewDateFormat = DateFormat('EEE, dd MMM yyyy');
final terseNewDateTimeFormat = DateFormat('EEE, dd MMM yyyy hh:mm aa');
final mockDataFormat = DateFormat('yyyy-MM-dd hh:mm:ss');

DateTime _parseDateTimeCascade(String src, [bool performRegexPass = true]) {
  try {
    return terseNewDateFormat.parseLoose(src);
  } catch (_) {}
  try {
    return terseNewDateTimeFormat.parseLoose(src);
  } catch (_) {}
  // try {
  //   return shortMonthDateFormat.parseLoose(src);
  // } catch (_) {}
  // try {
  //   return longMonthDateFormat.parseLoose(src);
  // } catch (_) {}
  // try {
  //   return shortMonthDayDateFormat.parseLoose(src);
  // } catch (_) {}
  // try {
  //   return shortDayTerseDateTimeFormat.parseLoose(src);
  // } catch (_) {}
  // try {
  //   return longMonthDayDateFormat.parseLoose(src);
  // } catch (_) {}
  // try {
  //   return mockDataFormat.parseLoose(src);
  // } catch (_) {}
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
  Grade._();

  factory Grade([void Function(GradeBuilder) updates]) = _$Grade;

  static Serializer<Grade> get serializer => _$gradeSerializer;

  @BuiltValueField(wireName: 'ASSIGNMENT_TITLE')
  String get name;

  @nullable
  @BuiltValueField(wireName: 'POINTS_EARNED')
  StringOrNum get pointsEarnedRaw;

  @BuiltValueField(serialize: false)
  String get pointsEarned {
    return pointsPossibleRaw?.maybeString() ;
  }

  @nullable
  @BuiltValueField(wireName: 'POINTS_POSSIBLE')
  StringOrNum get pointsPossibleRaw;

  @BuiltValueField(serialize: false)
  String get pointsPossible {
    return pointsPossibleRaw?.maybeString() ;
  }

  @BuiltValueField(serialize: false)
  String get displayGrade {
    if (pointsEarned != null && pointsPossible != null) {
      var earned = double.tryParse(pointsEarned);
      var possible = double.tryParse(pointsPossible);
      if (earned != null && possible != null && possible != 0) {
        return '${((earned / possible) * 100).toInt()}%';
      } else {
        return '$pointsEarned / $pointsPossible';
      }
    } else {
      return letter;
    }
  }

  @BuiltValueField(serialize: false)
  double get percentage {
    if (pointsEarned != null && pointsPossible != null) {
      var earned = double.tryParse(pointsEarned);
      var possible = double.tryParse(pointsPossible);
      possible = possible == 0 ? 1 : possible;
      if (earned != null && possible != null) {
        return ((earned / possible) * 100);
      } else if (earned != null) {
        return earned;
      }
    }
    return null;
  }

  @BuiltValueField(wireName: 'LETTER')
  String get rawLetter;

  String get normalLetter {
    if (RegExp(r'^[A-Fa-f]$').hasMatch(rawLetter)) {
      return rawLetter;
    }
    return null;
  }

  String get letter {
    if (rawLetter.contains(r'<i class="ui check icon')) {
      return 'Complete';
    } else if (rawLetter == r'<i class="ui x icon"></i>') {
      return 'Incomplete';
    } else {
      return rawLetter;
    }
  }

  @BuiltValueField(wireName: 'DUE_DATE')
  String get rawDueDate;

  @BuiltValueField(serialize: false)
  DateTime get dueDate {
    if (rawDueDate != null) {
      return _parseDateTimeCascade(rawDueDate);
    } else {
      return null;
    }
  }

  @BuiltValueField(wireName: 'ASSIGNED_DATE')
  String get rawAssignedDate;

  @BuiltValueField(serialize: false)
  DateTime get assignedDate {
    if (rawAssignedDate != null) {
      return _parseDateTimeCascade(rawAssignedDate);
    } else {
      return null;
    }
  }

  @nullable
  @BuiltValueField(wireName: 'UPDATED_AT')
  String get rawUpdatedAt;

  @BuiltValueField(serialize: false)
  DateTime get dateLastModified {
    if (rawUpdatedAt != null) {
      return _parseDateTimeCascade(rawUpdatedAt);
    } else {
      return null;
    }
  }

  @BuiltValueField(wireName: 'CATEGORY_TITLE')
  String get category;

  @nullable
  @BuiltValueField(wireName: 'COMMENT')
  String get comment;
}
