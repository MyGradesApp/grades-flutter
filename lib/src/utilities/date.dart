int daysUntil(DateTime dateTime) {
  var now = DateTime.now();

  var diff = dateTime.difference(now);
  return diff.inDays;
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
    return 'Unreachable';
  }
}
