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
  SISLoader _sisLoader = SISLoader(client: CookieClient());

  SISRepository(
      OfflineBloc offlineBloc, DataPersistence dataPersistence, this.prefs)
      : assert(offlineBloc != null),
        assert(dataPersistence != null),
        _offlineBloc = offlineBloc,
        _dataPersistence = dataPersistence {
    _offlineBloc.listen((offline) {
      _offline = offline;
    });
  }

  SISLoader get sisLoader => _sisLoader;

  Future<void> login(String username, String password, [String session]) async {
    var loader = SISLoader(client: CookieClient());
    if (session != null) {
      loader.sessionCookies = session;
    }
    await loader.login(username, password);
    _sisLoader = loader;
  }

  Future<List<Course>> getCourses() async {
    return await _offlineWrapper(
      _sisLoader.getCourses(),
      whenOffline: () => _dataPersistence.courses,
    );
  }

  Future<AcademicInfo> getAcademicInfo() async {
    return await _offlineWrapper(
      Future.value(AcademicInfo(
        await sisLoader.getUserProfile(),
        await sisLoader.getAbsences(),
      )),
      whenOffline: () => null,
    );
  }

  Future<List<Grade>> getCourseGrades(Course course) async {
    return await _offlineWrapper(
      _sisLoader.courseService.getGrades(course),
      whenOffline: () => _dataPersistence.grades[course.courseName],
    );
  }

  Future<T> _offlineWrapper<T>(Future<T> it,
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
      return await (it.timeout(TIMEOUT).then((T v) {
        return v;
      }));
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
      // TODO: Prefs should be abstracted out
      var username = prefs.getString('sis_username');
      var password = prefs.getString('sis_password');
      await login(username, password);
      _offlineBloc.add(NetworkOnlineEvent());
      return true;
    } catch (e) {
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
}
