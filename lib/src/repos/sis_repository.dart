import 'dart:async';

import 'package:grade_core/grade_core.dart';
import 'package:grade_core/src/errors.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sis_loader/sis_loader.dart';

import '../blocs/offline/offline_bloc.dart';

const Duration TIMEOUT = Duration(seconds: 5);

class SISRepository {
  final SharedPreferences prefs;
  final OfflineBloc _offlineBloc;
  final DataPersistence _dataPersistence;
  bool _offline = false;
  SISLoader Function() sisLoaderBuilder;
  SISLoader _sisLoader;

  @visibleForTesting
  bool get offline => _offline;

  SISRepository(
      OfflineBloc offlineBloc, DataPersistence dataPersistence, this.prefs,
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

  Future<List<Course>> getCourses() async {
    return await _offlineWrapper(
      () => _sisLoader.getCourses(),
      whenOffline: () => _dataPersistence.courses,
    );
  }

  Future<AcademicInfo> getAcademicInfo() async {
    return await _offlineWrapper(
      () async {
        var academicInfo = AcademicInfo(
          await sisLoader.getUserProfile(),
          await sisLoader.getAbsences(),
        );
        _dataPersistence.setAcademicInfo(academicInfo);
        return academicInfo;
      },
      whenOffline: () => _dataPersistence.academicInfo,
    );
  }

  Future<List<Grade>> getCourseGrades(Course course) async {
    return await _offlineWrapper(
      () => _sisLoader.courseService.getGrades(course),
      whenOffline: () => _dataPersistence.grades[course.courseName],
    );
  }

  Future<T> _offlineWrapper<T>(Future<T> Function() it,
      {@required T Function() whenOffline}) async {
    assert(whenOffline != null);
    if (_offline) {
      var loggedIn = await _attemptLogin();
      if (!loggedIn) {
        // Return offline data
        return whenOffline();
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
      // TODO: Prefs should be abstracted out
      var username = prefs.getString('sis_username');
      var password = prefs.getString('sis_password');
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
