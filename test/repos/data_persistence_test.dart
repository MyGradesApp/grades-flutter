import 'package:flutter_test/flutter_test.dart';
import 'package:grade_core/grade_core.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sis_loader/sis_loader.dart';

class MockSharedPrefs extends Mock implements SharedPreferences {}

void main() {
  test('smoke test', () {
    var prefs = MockSharedPrefs();
    DataPersistence(prefs);
  });

  group('deserialization', () {
    test('smoke test', () {
      var prefs = MockSharedPrefs();
      when(prefs.getString('persisted_grades_v2'))
          .thenReturn('{"foo": [{"key":"success"}]}');
      when(prefs.getString('persisted_courses_v2'))
          .thenReturn('[{"key":"success"}]');
      DataPersistence(prefs);
    });

    test('course with empty grades', () {
      var prefs = MockSharedPrefs();
      when(prefs.getString('persisted_grades_v2')).thenReturn('{"foo": []}');
      DataPersistence(prefs);
    });

    test('course with null grades', () {
      var prefs = MockSharedPrefs();
      when(prefs.getString('persisted_grades_v2')).thenReturn('{"foo": null}');
      DataPersistence(prefs);
    });
  });

  group('serialization', () {
    test('grades', () async {
      SharedPreferences.setMockInitialValues(<String, dynamic>{});
      var prefs = await SharedPreferences.getInstance();
      var persist = DataPersistence(prefs);
      persist.setGradesForCourse('foo', [
        Grade({'thisisa': 'grade'}),
      ]);

      expect(prefs.getString('persisted_grades_v2'),
          '{"foo":[{"thisisa":"grade"}]}');

      persist.grades = {
        'foo': [
          Grade({'bar': 'baz'}),
        ]
      };

      expect(prefs.getString('persisted_grades_v2'), '{"foo":[{"bar":"baz"}]}');
    });

    test('courses', () async {
      SharedPreferences.setMockInitialValues(<String, dynamic>{});
      var prefs = await SharedPreferences.getInstance();
      var persist = DataPersistence(prefs);
      persist.courses = [Course(courseName: 'courseName')];

      expect(
          prefs.getString('persisted_courses_v2'),
          '[{"gradesUrl":null,"courseName":"courseName","periodString":null,'
          '"teacherName":null,"gradePercent":null,"gradeLetter":null}]');
    });
  });
}
