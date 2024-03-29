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
      var courseData =
          '[{"gradesUrl":"Spam","courseName":"courseName","periodString":"Bar",'
          '"teacherName":"Foo","gradePercent":"Eggs","gradeLetter":"Baz"}]';
      var gradeData = '{"grades":[{"raw":{"foo":"Bar"}}]}';
      when(prefs.getString(DataPersistence.GRADES_KEY))
          .thenReturn('{"foo": $gradeData}');
      when(prefs.getString(DataPersistence.COURSES_KEY)).thenReturn(courseData);
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
      persist.setGradesForCourse(
          'foo',
          GradeData((d) => d
            ..grades.replace(<Grade>[
              Grade((g) => g
                ..name = 'test'
                ..letter = 'A'
                ..rawDueDate = 'Tue, 24 Aug 2021 12:00 am'
                ..rawAssignedDate = 'Tue, 24 Aug 2021 12:00 am'
                ..category = 'Test'),
            ])));

      expect(prefs.getString(DataPersistence.GRADES_KEY),
          '{"foo":{"grades":[{"raw":{"thisisa":"grade"}}]}}');

      persist.grades = {
        'foo': GradeData((d) => d
          ..grades.replace(<Grade>[
            Grade((g) => g
              ..name = 'test'
              ..letter = 'A'
              ..rawDueDate = 'Tue, 24 Aug 2021 12:00 am'
              ..rawAssignedDate = 'Tue, 24 Aug 2021 12:00 am'
              ..category = 'Test'),
          ]))
      };

      expect(prefs.getString(DataPersistence.GRADES_KEY),
          '{"foo":{"grades":[{"raw":{"bar":"baz"}}]}}');
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
          ..gradePercent = StringOrInt('Eggs')
          ..coursePeriodId = 1)
      ];

      expect(
          prefs.getString(DataPersistence.COURSES_KEY),
          '[{"coursePeriodId":1,"courseName":"courseName","periodString":"Bar",'
          '"teacherName":"Foo","gradesUrl":"Spam","gradePercent":"Eggs",'
          '"gradeLetter":"Baz"}]');
    });
  });
}
