import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:sis_loader/sis_loader.dart';
import 'package:sis_loader/src/utilities.dart';

part 'serializers.g.dart';

@SerializersFor([
  Absences,
  Course,
  Grade,
  Profile,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..add(StringOrIntSerializer())
      ..addPlugin(StandardJsonPlugin()))
    .build();
