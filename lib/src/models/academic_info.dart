import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:sis_loader/sis_loader.dart';

part 'academic_info.g.dart';

abstract class AcademicInfo
    implements Built<AcademicInfo, AcademicInfoBuilder> {
  Profile get profile;

  Absences get absences;

  AcademicInfo._();

  factory AcademicInfo([void Function(AcademicInfoBuilder) updates]) =
      _$AcademicInfo;

  static Serializer<AcademicInfo> get serializer => _$academicInfoSerializer;
}
