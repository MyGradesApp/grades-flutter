import 'package:sis_loader/sis_loader.dart';

class CachedSISLoader {
  final SISLoader _loader;
  final String username;

  CachedSISLoader(this._loader, this.username);

  // Cache
  Future<List<Course>> _courses;
  Future<Profile> _userProfile;

  // Wrapping

  String get sessionCookies => _loader.sessionCookies;

  set sessionCookies(String cookies) => _loader.sessionCookies = cookies;

  void login(String username, String password) =>
      _loader.login(username, password);

  // TODO: Pull caching out of sis-loader `Course`s
  Future<List<Course>> getCourses({bool force = false}) {
    if (_courses != null && !force) {
      return _courses;
    }
    _courses = _loader.getCourses();
    return _courses;
  }

  Future<Profile> getUserProfile({bool force = false}) {
    if (_userProfile != null && !force) {
      return _userProfile;
    }
    _userProfile = _loader.getUserProfile();
    return _userProfile;
  }
}