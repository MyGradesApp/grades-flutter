import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:grades/blocs/offline/offline_bloc.dart';
import 'package:grades/errors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sis_loader/sis_loader.dart';

class SISRepository {
  final OfflineBloc _offlineBloc;
  bool _offline = false;
  SISLoader _sisLoader = SISLoader(client: CookieClient());

  SISRepository(OfflineBloc offlineBloc)
      : assert(offlineBloc != null),
        _offlineBloc = offlineBloc {
    _offlineBloc.listen((state) {
      _offline = state.offline;
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
      _sisLoader.getCourses().timeout(Duration(seconds: 5)),
      whenOffline: () => [],
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
      return await (it.then((T v) {
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
      var prefs = await SharedPreferences.getInstance();
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
