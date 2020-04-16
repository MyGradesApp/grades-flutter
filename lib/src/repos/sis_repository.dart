import 'dart:async';

import 'package:grade_core/grade_core.dart';
import 'package:grade_core/src/errors.dart';
import 'package:grade_core/src/utilities/consts.dart';
import 'package:grade_core/src/utilities/wrapped_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:sis_loader/sis_loader.dart';

import '../blocs/offline/offline_bloc.dart';

const Duration TIMEOUT = Duration(seconds: 5);

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
      whenOffline: () => _dataPersistence.courses,
      key: COURSES,
      refresh: refresh,
    );
  }

  Future<AcademicInfo> getAcademicInfo({bool refresh = false}) async {
    return await _fetchWrapper(
      () async {
        var academicInfo = AcademicInfo(
          await sisLoader.getUserProfile(),
          await sisLoader.getAbsences(),
        );
        _dataPersistence.setAcademicInfo(academicInfo);
        return academicInfo;
      },
      whenOffline: () => _dataPersistence.academicInfo,
      key: ACADEMIC_INFO,
      refresh: refresh,
    );
  }

  Future<List<Grade>> getCourseGrades(Course course,
      {bool refresh = false}) async {
    return await _fetchWrapper(
      () async {
        var grades = await _sisLoader.courseService.getGrades(course);
        _dataPersistence.setGradesForCourse(course.courseName, grades);
        return grades;
      },
      whenOffline: () => _dataPersistence.grades[course.courseName],
      key: keyForGrade(course),
      refresh: refresh,
    );
  }

  Future<T> _fetchWrapper<T>(Future<T> Function() it,
      {@required T Function() whenOffline,
      @required String key,
      @required bool refresh}) async {
    assert(whenOffline != null);
    if (_offline) {
      var loggedIn = await _attemptLogin();
      if (!loggedIn) {
        // Return offline data
        return whenOffline();
      }
    }
    if (_fetchedState[key] ?? false || !refresh) {
      var offlineData = whenOffline();
      if (offlineData != null) {
        return offlineData;
      }
    }
    try {
      return await (it()?.timeout(TIMEOUT));
    } catch (e) {
      if (isHttpError(e)) {
        _offlineBloc.add(NetworkOfflineEvent());
        return whenOffline();
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
      await login(username, password);
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

class AcademicInfo {
  final Profile profile;
  final Absences absences;

  const AcademicInfo(this.profile, this.absences);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'profile': {
        'class_rank_numerator': profile.class_rank_numerator,
        'class_rank_denominator': profile.class_rank_denominator,
        'cumulative_gpa': profile.cumulative_gpa,
        'cumulative_weighted_gpa': profile.cumulative_weighted_gpa,
      },
      'absences': {
        'days': absences.days,
        'periods': absences.periods,
      },
    };
  }

  factory AcademicInfo.fromJson(Map<String, dynamic> json) {
    return AcademicInfo(
      Profile(
        class_rank_denominator:
            json['profile']['class_rank_denominator'] as int,
        class_rank_numerator: json['profile']['class_rank_numerator'] as int,
        cumulative_gpa: json['profile']['cumulative_gpa'] as double,
        cumulative_weighted_gpa:
            json['profile']['cumulative_weighted_gpa'] as double,
      ),
      Absences(
        days: json['absences']['days'] as int,
        periods: json['absences']['periods'] as int,
      ),
    );
  }

  @override
  String toString() {
    return 'AcademicInfo{profile: $profile, absences: $absences}';
  }
}
