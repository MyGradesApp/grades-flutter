import 'package:equatable/equatable.dart';

class Absences extends Equatable {
  final int periods;
  final int days;

  Absences({this.periods, this.days});

  @override
  String toString() {
    return '{periods: ${periods}, days: ${days}}';
  }

  @override
  List<Object> get props => [periods, days];
}
