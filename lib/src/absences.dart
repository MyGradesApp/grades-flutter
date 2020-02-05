class Absences {
  final int periods;
  final int days;

  Absences({this.periods, this.days});

  @override
  String toString() {
    return '{periods: ${periods}, days: ${days}}';
  }
}
