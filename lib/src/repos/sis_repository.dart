import 'dart:async';

import 'package:grade_core/grade_core.dart';
import 'package:grade_core/src/errors.dart';
import 'package:grade_core/src/utilities/consts.dart';
import 'package:grade_core/src/utilities/wrapped_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:sis_loader/sis_loader.dart';

import '../blocs/offline/offline_bloc.dart';

const Duration TIMEOUT = Duration(seconds: 20);

const COURSES = 'courses';
const ACADEMIC_INFO = 'academic_info';

String keyForGrade(Course course) {
  return 'grades_${course.courseName}';
}

class SISRepository {
  final OfflineBloc _offlineBloc;
  final DataPersistence _dataPersistence;
  bool _offline = false;
  SISLoader Function() sisLoaderBuilder;
  SISLoader _sisLoader;

  final Map<String, bool> _fetchedState = {};

  @visibleForTesting
  bool get offline => _offline;

  void clearCache() {
    _fetchedState.clear();
  }

  SISRepository(OfflineBloc offlineBloc, DataPersistence dataPersistence,
      {this.sisLoaderBuilder})
      : assert(offlineBloc != null),
        assert(dataPersistence != null),
        _offlineBloc = offlineBloc,
        _dataPersistence = dataPersistence {
    if (sisLoaderBuilder != null) {
      _sisLoader = sisLoaderBuilder();
    }
    _offlineBloc.listen((state) {
      _offline = state.offline;
    });
  }

  SISLoader get sisLoader => _sisLoader;

  Future<void> login(String username, String password, [String session]) async {
    SISLoader loader;
    if (sisLoaderBuilder != null) {
      loader = sisLoaderBuilder();
    } else {
      loader = SISLoader(client: CookieClient());
    }
    if (session != null) {
      loader.sessionCookies = session;
    }
    await loader.login(username, password);
    _sisLoader = loader;
  }

  Future<List<Course>> getCourses({bool refresh = false}) async {
    return await _fetchWrapper(
      () async {
        var courses = await _sisLoader.getCourses();
        _dataPersistence.courses = courses;
        return courses;
      },
      fetchPersisted: () => _dataPersistence.courses,
      cacheKey: COURSES,
      refresh: refresh,
    );
  }

  Future<AcademicInfo> getAcademicInfo({bool refresh = false}) async {
    return await _fetchWrapper(
      () async {
        var profile = await sisLoader.getUserProfile();
        var absences = await sisLoader.getAbsences();
        var academicInfo = AcademicInfo(
          (a) => a
            ..profile = profile.toBuilder()
            ..absences = absences.toBuilder(),
        );
        _dataPersistence.setAcademicInfo(academicInfo);
        return academicInfo;
      },
      fetchPersisted: () => _dataPersistence.academicInfo,
      cacheKey: ACADEMIC_INFO,
      refresh: refresh,
    );
  }

  Future<GradeData> getCourseGrades(Course course,
      {bool refresh = false}) async {
    return await _fetchWrapper(
      () async {
        var grades = await _sisLoader.courseService.getGrades(course);
        _dataPersistence.setGradesForCourse(course.courseName, grades);
        return grades;
      },
      fetchPersisted: () => _dataPersistence.grades[course.courseName],
      cacheKey: keyForGrade(course),
      refresh: refresh,
    );
  }

  Future<T> _fetchWrapper<T>(
    Future<T> Function() it, {
    @required T Function() fetchPersisted,
    @required String cacheKey,
    @required bool refresh,
  }) async {
    assert(fetchPersisted != null);
    if (_offline) {
      var loggedIn = await _attemptLogin();
      if (!loggedIn) {
        // Return offline data
        return fetchPersisted();
      }
    }
    if ((_fetchedState[cacheKey] ?? false) && !refresh) {
      var offlineData = fetchPersisted();
      if (offlineData != null) {
        return offlineData;
      }
    }
    try {
      var val = await (it()?.timeout(TIMEOUT));
      _fetchedState[cacheKey] = true;
      return val;
    } catch (e) {
      if (isHttpError(e)) {
        _offlineBloc.add(NetworkOfflineEvent());
        return fetchPersisted();
      } else {
        rethrow;
      }
    }
  }

  Future<bool> _attemptLogin() async {
    try {
      _offlineBloc.add(LoggingInEvent());
      // TODO: Storage should be abstracted out
      var secureStorage = WrappedSecureStorage();
      var username = await secureStorage.read(key: AuthConst.SIS_USERNAME_KEY);
      var password = await secureStorage.read(key: AuthConst.SIS_PASSWORD_KEY);
      var session = await secureStorage.read(key: AuthConst.SIS_SESSION_KEY);
      await login(username, password, session);
      _offlineBloc.add(NetworkOnlineEvent());
      return true;
    } catch (e) {
      _offlineBloc.add(StoppedLoggingInEvent());
      if (isHttpError(e)) {
        return false;
      }
      rethrow;
    }
  }
}
