import 'package:sis_loader/sis_loader.dart';

Future<SISLoader> attemptLogin(String email, String password,
    [String session]) async {
  assert(email != null && email.isNotEmpty);
  assert(password != null && password.isNotEmpty);
  var loader = SISLoader();

  if (session != null) {
    loader.sessionCookies = session;
  }

  await loader.login(email, password);

  return loader;
}
