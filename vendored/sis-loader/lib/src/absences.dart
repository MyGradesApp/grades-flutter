import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'absences.g.dart';

abstract class Absences implements Built<Absences, AbsencesBuilder> {
  int get periods;

  int get days;

  Absences._();

  factory Absences([void Function(AbsencesBuilder) updates]) = _$Absences;

  static Serializer<Absences> get serializer => _$absencesSerializer;
}
