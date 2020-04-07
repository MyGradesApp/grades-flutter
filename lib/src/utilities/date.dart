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
    return 'Unreachable';
  }
}
