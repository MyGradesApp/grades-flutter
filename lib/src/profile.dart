import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final double cumulative_gpa;
  final double cumulative_weighted_gpa;
  final int class_rank_numerator;
  final int class_rank_denominator;

  Profile(
      {this.cumulative_gpa,
      this.cumulative_weighted_gpa,
      this.class_rank_numerator,
      this.class_rank_denominator});

  @override
  List<Object> get props => [
        cumulative_gpa,
        cumulative_weighted_gpa,
        class_rank_numerator,
        class_rank_denominator
      ];

  @override
  String toString() {
    return 'Profile{cumulative_gpa: $cumulative_gpa, cumulative_weighted_gpa: $cumulative_weighted_gpa, class_rank_numerator: $class_rank_numerator, class_rank_denominator: $class_rank_denominator}';
  }
}
