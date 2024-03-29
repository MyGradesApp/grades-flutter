import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grade_core/grade_core.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sis_loader/sis_loader.dart';

class MockSharedPrefs extends Mock implements SharedPreferences {}

class MockDataPersistence extends Mock implements DataPersistence {}

class MockOfflineBloc extends Mock implements OfflineBloc {}

class MockSISLoader extends Mock implements SISLoader {}

class MockCourseService extends Mock implements CourseService {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, dynamic>{});

  var offlineBloc = MockOfflineBloc();
  var dataPersist = MockDataPersistence();
  when(dataPersist.grades).thenAnswer((_) => {});

  test('smoke test', () async {
    var repo = SISRepository(offlineBloc, dataPersist);
    // Internal testing credentials
    await repo.login('s2558161d', 'figure51');
  });

  test('session token', () async {
    var repo = SISRepository(offlineBloc, dataPersist);
    var token = '{"SESSID":"SESSID=fooBarBaz; Path=/home; Secure; HttpOnly"}';
    await repo.login('s2558161d', 'figure51', token);
    expect(repo.sisLoader.sessionCookies, token);
  });

  group('online', () {
    test('courses', () async {
      var repo = SISRepository(offlineBloc, dataPersist);
      await repo.login('s2558161d', 'figure51');
      var _ = await repo.getCourses();
      // TODO: Check courses
    });

    test('grades', () async {
      var repo = SISRepository(offlineBloc, dataPersist);
      await repo.login('s2558161d', 'figure51');
      var _ = await repo.getCourseGrades(Course((c) => c
        ..courseName = 'US History'
        ..teacherName = 'Foo'
        ..periodString = 'Bar'
        ..gradeLetter = 'Baz'
        ..gradesUrl = 'Spam'
        ..gradePercent = StringOrInt('Eggs')));
      // TODO: Check grades
    });

    test('academic info', () async {
      var repo = SISRepository(offlineBloc, dataPersist);
      await repo.login('s2558161d', 'figure51');
      var info = await repo.getAcademicInfo();
      expect(
          info.absences,
          Absences((a) => a
            ..days = 2
            ..periods = 3));
      expect(
        info.profile,
        Profile((p) => p
          ..cumulative_gpa = 3.9
          ..cumulative_weighted_gpa = 4.1
          ..class_rank_numerator = 44
          ..class_rank_denominator = 801),
      );
    });
  });

  group('offline', () {
    test('courses', () async {
      var loader = MockSISLoader();
      when(loader.getCourses())
          .thenAnswer((_) => Future.error(HttpException('Fake exception')));
      var repo = SISRepository(offlineBloc, dataPersist,
          sisLoaderBuilder: () => loader);
      await repo.login('s2558161d', 'figure51');
      var _ = await repo.getCourses();
      // TODO: Check courses
    });

    test('grades', () async {
      // TODO
    });

    group('reauth', () {
      void offlineTest<T>(
        MockSISLoader loader,
        Future<T> Function(SISRepository) test,
      ) async {
        var offlineBloc = MockOfflineBloc();
        whenListen(offlineBloc, Stream.value(OfflineState(true, false)));

        var repo = SISRepository(offlineBloc, dataPersist,
            sisLoaderBuilder: () => loader);
        await repo.login('s2558161d', 'figure51');
        await test(repo);
      }

      test('courses', () async {
        var loader = MockSISLoader();
        when(loader.getCourses()).thenAnswer((_) => Future.value([]));
        await offlineTest(loader, (repo) => repo.getCourses());
      });
    });
  });
}
