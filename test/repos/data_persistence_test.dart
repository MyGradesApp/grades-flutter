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
      when(prefs.getString(DataPersistence.GRADES_KEY))
          .thenReturn('{"foo": [{"key":"success"}]}');
      when(prefs.getString(DataPersistence.COURSES_KEY))
          .thenReturn('[{"key":"success"}]');
      DataPersistence(prefs);
    });

    test('course with empty grades', () {
      var prefs = MockSharedPrefs();
      when(prefs.getString(DataPersistence.GRADES_KEY))
          .thenReturn('{"foo": []}');
      DataPersistence(prefs);
    });

    test('course with null grades', () {
      var prefs = MockSharedPrefs();
      when(prefs.getString(DataPersistence.GRADES_KEY))
          .thenReturn('{"foo": null}');
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

      expect(prefs.getString(DataPersistence.GRADES_KEY),
          '{"foo":[{"thisisa":"grade"}]}');

      persist.grades = {
        'foo': [
          Grade({'bar': 'baz'}),
        ]
      };

      expect(prefs.getString(DataPersistence.GRADES_KEY),
          '{"foo":[{"bar":"baz"}]}');
    });

    test('courses', () async {
      SharedPreferences.setMockInitialValues(<String, dynamic>{});
      var prefs = await SharedPreferences.getInstance();
      var persist = DataPersistence(prefs);
      persist.courses = [
        Course((c) => c
          ..courseName = 'courseName'
          ..teacherName = 'Foo'
          ..periodString = 'Bar'
          ..gradeLetter = 'Baz'
          ..gradesUrl = 'Spam'
          ..gradePercent = StringOrInt('Eggs'))
      ];

      expect(
          prefs.getString(DataPersistence.COURSES_KEY),
          '[{"gradesUrl":null,"courseName":"courseName","periodString":null,'
          '"teacherName":null,"gradePercent":null,"gradeLetter":null}]');
    });
  });
}
