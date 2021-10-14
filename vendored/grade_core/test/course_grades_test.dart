import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:grade_core/grade_core.dart';
import 'package:mockito/mockito.dart';
import 'package:sis_loader/sis_loader.dart';

import 'helpers.dart';

class MockSISRepo extends Mock implements SISRepository {}

void main() async {
  var course = Course((c) => c
    ..gradesUrl = '/foo/bar.php'
    ..courseName = 'US Gov'
    ..periodString = '02 02'
    ..teacherName = 'Daniel Henderson'
    ..gradePercent = StringOrInt(87)
    ..gradeLetter = 'B'
    ..coursePeriodId = 1);

  void testCourseGradesBloc(GradeData data) async {
    var sisRepo = MockSISRepo();
    when(sisRepo.getCourseGrades(course, refresh: anyNamed('refresh')))
        .thenAnswer((_) => Future.value(GradeData((d) => d.replace(data))));
    var bloc = CourseGradesBloc(sisRepository: sisRepo, course: course);
    bloc.add(FetchNetworkData());

    await testNetworkBlocFetch<NetworkLoaded<GradeData>>(
      bloc,
      (e) => e.data == data,
    );

    bloc = CourseGradesBloc(sisRepository: sisRepo, course: course);
    bloc.add(RefreshNetworkData());

    await testNetworkBlocRefresh<NetworkLoaded<GradeData>>(
      bloc,
      (e) => e.data == data,
    );
  }

  group('general', () {
    test('course getter', () {
      expect(
        CourseGradesBloc(sisRepository: MockSISRepo(), course: course).course,
        course,
      );
    });

    test('null assertions', () {
      var sisRepo = MockSISRepo();
      expect(() => CourseGradesBloc(sisRepository: null, course: course),
          throwsAssertionError);
      expect(() => CourseGradesBloc(sisRepository: sisRepo, course: null),
          throwsAssertionError);
    });

    test('format checks', () {
      var sisRepo = MockSISRepo();
      var bloc = CourseGradesBloc(sisRepository: sisRepo, course: course);
      expect(bloc.format(null), 'grades.length: null');
      expect(bloc.format(GradeData((d) => d..grades.replace(<Grade>[]))),
          'grades.length: 0');
      expect(
          bloc.format(GradeData((d) => d.grades
            ..replace(<Grade>[
              Grade((g) => g
                ..name = 'test'
                ..letter = 'A'
                ..rawDueDate = 'Tue, 24 Aug 2021 12:00 am'
                ..rawAssignedDate = 'Tue, 24 Aug 2021 12:00 am'
                ..category = 'Test')
            ]))),
          'grades.length: 1');
    });
  });

  test('network failure', () async {
    var sisRepo = MockSISRepo();
    when(sisRepo.getCourseGrades(course, refresh: anyNamed('refresh')))
        .thenThrow(TimeoutException('Fake exception'));
    var bloc = CourseGradesBloc(sisRepository: sisRepo, course: course);
    bloc.add(FetchNetworkData());

    testNetworkBlocFetchError(bloc);

    when(sisRepo.getCourseGrades(course))
        .thenThrow(TimeoutException('Fake exception'));
    bloc = CourseGradesBloc(sisRepository: sisRepo, course: course);
    bloc.add(RefreshNetworkData());

    testNetworkBlocRefreshError(bloc);
  });

  group('offline', () {
    test('no data', () async {
      await testCourseGradesBloc(GradeData(
        (d) => d
          ..grades = null
          ..weights = null,
      ));
    });

    test('empty data', () async {
      await testCourseGradesBloc(GradeData(
        (d) =>
            d..grades.replace(<Grade>[])..weights.replace(<String, String>{}),
      ));
    });
  });
}
