import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:sis_loader/src/grade.dart';
import 'package:sis_loader/src/mock_data.dart' as mock_data;
import 'package:sis_loader/src/utilities.dart';

import '../sis_loader.dart' show SISLoader, debugMocking, serializers;
import 'cookie_client.dart';

part 'course.g.dart';

abstract class GradeData implements Built<GradeData, GradeDataBuilder> {
  @nullable
  BuiltList<Grade> get grades;

  @nullable
  BuiltMap<String, String> get weights;

  @nullable
  int get classPercent;

  GradeData._();

  factory GradeData([void Function(GradeDataBuilder) updates]) = _$GradeData;

  static Serializer<GradeData> get serializer => _$gradeDataSerializer;
}

class CourseService {
  final SISLoader sisLoader;

  CourseService(this.sisLoader);

  Future<String> _gradeRawData(Course course) async {
    if (course.gradesUrl == null) {
      // This feels weird, perhaps null-safe bubbling would be better?
      return '';
    }

    var gradeRequest = await sisLoader.client.get(Uri.parse(course.gradesUrl));
    var gradesBody = await gradeRequest.bodyAsString();
    var bearerToken =
        RegExp(r'static get session_id\(\) {[\w\W]+?return "(.+?)";')
            .firstMatch(gradesBody)
            .group(1);

    var requestToken = RegExp(r'__Module__\.token = "(.+?)"')
        .allMatches(gradesBody)
        .last
        .group(1);

    var userId = RegExp(r'"USERNAME":"(.+?)"').firstMatch(gradesBody).group(1);

    var requestData =
        '{"requests":[{"controller":"StudentGBGradesController","method":"getGradebookGrid","args":[${course.coursePeriodId}]}]}';
    var dataRequest = await sisLoader.client.post(
        Uri.https(
            'sis.palmbeachschools.org', 'focus/classes/FocusModule.class.php', {
          'modname': 'Grades/StudentGBGrades.php',
          'force_package': 'SIS',
          'student_id': userId,
          'course_period_id': course.coursePeriodId.toString(),
        }),
        '--FormBoundary\r\nContent-Disposition: form-data; name="course_period_id"\r\n\r\n${course.coursePeriodId}\r\n--FormBoundary\r\nContent-Disposition: form-data; name="__call__"\r\n\r\n$requestData\r\n--FormBoundary\r\nContent-Disposition: form-data; name="__token__"\r\n\r\n$requestToken\r\n--FormBoundary--\r\n',
        headers: {
          'authorization': 'Bearer ' + bearerToken,
          'content-type': 'multipart/form-data; boundary=FormBoundary',
        });
    return dataRequest.bodyAsString();
  }

  Future<GradeData> getGrades(Course course) async {
    if (debugMocking) {
      return Future.value(GradeData((d) => d
        ..grades.replace(mock_data.GRADES[course.courseName])
        ..weights.replace(mock_data.CATEGORY_WEIGHTS[course.courseName])));
    }

    var gradeRawData = await _gradeRawData(course);
    var gradeDataResponse = jsonDecode(gradeRawData)[0];

    if (gradeDataResponse['error'] != null) {
      throw Exception(gradeDataResponse['error']);
    }

    var gradeData = (gradeDataResponse['result']['data'] as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .map((e) =>
            serializers.deserializeWith(Grade.serializer, e)); //as Grade;

    Map<String, String> weights;
    if (gradeDataResponse['result']['weighted_categories'] != null) {
      weights = Map.fromEntries((gradeDataResponse['result']
              ['weighted_categories'] as Map<dynamic, dynamic>)
          .entries
          .map((e) => MapEntry(e.value['title'] as String,
              '${e.value['final_grade_percent']}%')));
    } else {
      weights = {};
      // weights = Map.fromEntries(Set.from(gradeData.map((e) => e.category))
      //     .map((e) => MapEntry(e as String, '')));
    }

    var rawCourseGrade =
        gradeDataResponse['result']['weighted_grade'] as String;
    int coursePercent;
    if (rawCourseGrade != null) {
      var classGrade = rawCourseGrade.replaceAll('&nbsp;', ' ');
      var percentMatch = RegExp(r'(\d+)%').firstMatch(classGrade);
      if (percentMatch != null) {
        coursePercent = int.parse(percentMatch.group(1));
      }
    }

    return GradeData((b) => b
      ..grades.replace(gradeData)
      ..weights.replace(weights)
      ..classPercent = coursePercent);
  }
}

abstract class Course implements Built<Course, CourseBuilder> {
  // Course+term id
  int get coursePeriodId;

  @nullable
  String get gradesUrl;

  String get courseName;

  String get periodString;

  String get teacherName;

  @nullable
  StringOrInt get gradePercent;

  @nullable
  String get gradeLetter;

  Course._();

  factory Course([void Function(CourseBuilder) updates]) = _$Course;

  static Serializer<Course> get serializer => _$courseSerializer;
}
