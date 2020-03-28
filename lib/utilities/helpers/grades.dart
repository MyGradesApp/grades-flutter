// TODO: Support +/- systems
String letterGradeForPercent(double percent) {
  if (percent >= 90) {
    return 'A';
  } else if (percent >= 80) {
    return 'B';
  } else if (percent >= 70) {
    return 'C';
  } else if (percent >= 60) {
    return 'D';
  } else {
    return 'F';
  }
}
