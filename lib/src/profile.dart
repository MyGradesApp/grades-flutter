import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'profile.g.dart';

abstract class Profile implements Built<Profile, ProfileBuilder> {
  double get cumulative_gpa;

  double get cumulative_weighted_gpa;

  @nullable
  int get class_rank_numerator;

  @nullable
  int get class_rank_denominator;

  Profile._();

  factory Profile([void Function(ProfileBuilder) updates]) = _$Profile;

  static Serializer<Profile> get serializer => _$profileSerializer;
}
