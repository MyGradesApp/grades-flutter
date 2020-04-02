import 'package:sis_loader/sis_loader.dart';

class SISRepository {
  SISLoader _sisLoader = SISLoader(client: CookieClient());

  SISLoader get sisLoader => _sisLoader;

  Future<void> login(String username, String password, [String session]) async {
    _sisLoader = SISLoader(client: CookieClient());
    if (session != null) {
      _sisLoader.sessionCookies = session;
    }
    return await _sisLoader.login(username, password);
  }

  Future<List<Course>> getCourses() async {
    return await _sisLoader.getCourses();
  }
}
