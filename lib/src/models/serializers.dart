import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:grade_core/grade_core.dart';
import 'package:sis_loader/sis_loader.dart' as sis_loader;
import 'package:sis_loader/sis_loader.dart'
    show Absences, Course, Grade, Profile;

part 'serializers.g.dart';

@SerializersFor([AcademicInfo])
final Serializers serializers = (_$serializers.toBuilder()
      ..merge(sis_loader.serializers)
      ..addBuilderFactory(
        DataPersistence.BUILT_COURSES_TYPE,
        () => ListBuilder<Course>(),
      )
      ..addBuilderFactory(
        FullType(BuiltList, [FullType(Grade)]),
        () => ListBuilder<Grade>(),
      )
      ..addBuilderFactory(
        DataPersistence.BUILT_GRADES_TYPE,
        () => MapBuilder<String, BuiltList<Grade>>(),
      )
      ..addPlugin(StandardJsonPlugin()))
    .build();
