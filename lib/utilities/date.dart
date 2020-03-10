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
