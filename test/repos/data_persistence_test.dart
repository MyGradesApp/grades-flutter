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
<<<<<<< Updated upstream
      var targetCourse =
          '[{"gradesUrl":"Spam","courseName":"courseName","periodString":"Bar",'
          '"teacherName":"Foo","gradePercent":"Eggs","gradeLetter":"Baz"}]';
      when(prefs.getString(DataPersistence.GRADES_KEY))
          .thenReturn('{"foo": $targetCourse}');
      when(prefs.getString(DataPersistence.COURSES_KEY))
          .thenReturn(targetCourse);
=======
      when(prefs.getString('persisted_grades_v2'))
          .thenReturn('{"foo": [{"key":"success"}]}');
      when(prefs.getString('persisted_courses_v3'))
          .thenReturn('[{"key":"success"}]');
>>>>>>> Stashed changes
      DataPersistence(prefs);
    });

    test('course with empty grades', () {
      var prefs = MockSharedPrefs();
      when(prefs.getString(DataPersistence.GRADES_KEY))
          .thenReturn('{"foo": []}');
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
          '{"foo":[{"raw":{"thisisa":"grade"}}]}');

      persist.grades = {
        'foo': [
          Grade({'bar': 'baz'}),
        ]
      };

      expect(prefs.getString(DataPersistence.GRADES_KEY),
          '{"foo":[{"raw":{"bar":"baz"}}]}');
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
<<<<<<< Updated upstream
          prefs.getString(DataPersistence.COURSES_KEY),
          '[{"gradesUrl":"Spam","courseName":"courseName","periodString":"Bar",'
          '"teacherName":"Foo","gradePercent":"Eggs","gradeLetter":"Baz"}]');
=======
          prefs.getString('persisted_courses_v3'),
          '[{"gradesUrl":null,"courseName":"courseName","periodString":null,'
          '"teacherName":null,"gradePercent":null,"gradeLetter":null}]');
>>>>>>> Stashed changes
    });
  });
}
