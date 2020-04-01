int isoWeekNumber(DateTime date) {
  var daysToAdd = DateTime.thursday - date.weekday;
  var thursdayDate = daysToAdd > 0
      ? date.add(Duration(days: daysToAdd))
      : date.subtract(Duration(days: daysToAdd.abs()));
  var dayOfYearThursday = dayOfYear(thursdayDate);
  return 1 + ((dayOfYearThursday - 1) / 7).floor();
}

int dayOfYear(DateTime date) {
  return date.difference(DateTime(date.year, 1, 1)).inDays;
}

DateTime firstDayOfWeek(DateTime day) {
  /// Handle Daylight Savings by setting hour to 12:00 Noon
  /// rather than the default of Midnight
  day = DateTime.utc(day.year, day.month, day.day, 12);

  /// Weekday is on a 1-7 scale Monday - Sunday,
  /// This Calendar works from Sunday - Monday
  var decreaseNum = day.weekday % 7;
  return day.subtract(Duration(days: decreaseNum));
}

DateTime lastDayOfWeek(DateTime day) {
  /// Handle Daylight Savings by setting hour to 12:00 Noon
  /// rather than the default of Midnight
  day = DateTime.utc(day.year, day.month, day.day, 12);

  /// Weekday is on a 1-7 scale Monday - Sunday,
  /// This Calendar's Week starts on Sunday
  var increaseNum = day.weekday % 7;
  return day.add(Duration(days: 6 - increaseNum));
}

String timeUntilHumanized(DateTime date) {
  var days = daysUntil(date);
  if (days == 0) {
    return 'Today';
  } else if (days == 1) {
    return 'Tomorrow';
  } else {
    return 'In ${days} days';
  }
}

String timeUntilHumanizedForCard(DateTime date) {
  var days = daysUntil(date);
  if (days == 0) {
    return '';
  } else if (days == 1) {
    return 'In 1 day';
  } else {
    return 'In ${days} days';
  }
}

int daysUntil(DateTime dateTime) {
  var now = DateTime.now();

  var diff = dateTime.difference(now);
  return diff.inDays;
}

enum DateGrouping {
  Today,
  Tomorrow,
  Next7Days,
  Next14Days,
  Future,
}

extension DateGroupingExt on DateGrouping {
  static DateGrouping fromDate(DateTime date) {
    var daysLeft = daysUntil(date);
    if (daysLeft == 0) {
      return DateGrouping.Today;
    } else if (daysLeft == 1) {
      return DateGrouping.Tomorrow;
    } else if (daysLeft <= 7) {
      return DateGrouping.Next7Days;
    } else if (daysLeft <= 14) {
      return DateGrouping.Next14Days;
    } else {
      return DateGrouping.Future;
    }
  }

  String toHumanFormat() {
    switch (this) {
      case DateGrouping.Today:
        return 'Today';
      case DateGrouping.Tomorrow:
        return 'Tomorrow';
      case DateGrouping.Next7Days:
        return 'Next 7 Days';
      case DateGrouping.Next14Days:
        return 'Next 14 Days';
      case DateGrouping.Future:
        return 'After 14 Days';
    }
  }
}
