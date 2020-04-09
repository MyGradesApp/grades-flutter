import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grade_core/grade_core.dart';
import 'package:mockito/mockito.dart';
import 'package:sis_loader/sis_loader.dart';

import 'helpers.dart';

class MockSISRepo extends Mock implements SISRepository {}

void main() async {
  var course = Course(
    gradesUrl: '/foo/bar.php',
    courseName: 'US Gov',
    periodString: '02 02',
    teacherName: 'Daniel Henderson',
    gradePercent: 87,
    gradeLetter: 'B',
  );

  void testCourseGradesBloc(List<Grade> data) async {
    var sisRepo = MockSISRepo();
    when(sisRepo.getCourseGrades(course)).thenAnswer((_) => Future.value(data));
    var bloc = CourseGradesBloc(sisRepository: sisRepo, course: course);
    bloc.add(FetchNetworkData());

    await testNetworkBlocFetch<NetworkLoaded<List<Grade>>>(
      bloc,
      (e) => listEquals(e.data, data),
    );

    bloc = CourseGradesBloc(sisRepository: sisRepo, course: course);
    bloc.add(RefreshNetworkData());

    await testNetworkBlocRefresh<NetworkLoaded<List<Grade>>>(
      bloc,
      (e) => listEquals(e.data, data),
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
      expect(bloc.format([]), 'grades.length: 0');
      expect(bloc.format([Grade({})]), 'grades.length: 1');
    });
  });

  test('network failure', () async {
    var sisRepo = MockSISRepo();
    when(sisRepo.getCourseGrades(course))
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
      await testCourseGradesBloc(null);
    });

    test('empty data', () async {
      await testCourseGradesBloc([]);
    });

    test('normal data', () async {
      await testCourseGradesBloc([
        Grade({'key': 'success'})
      ]);
    });
  });
}
