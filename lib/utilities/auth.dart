import 'package:grades/sis-cache/sis_loader.dart';
import 'package:sis_loader/sis_loader.dart';

Future<CachedSISLoader> attemptLogin(String email, String password,
    [String session]) async {
  assert(email != null && email.isNotEmpty);
  assert(password != null && password.isNotEmpty);
  var loader = CachedSISLoader(SISLoader(), email);

  if (session != null) {
    loader.sessionCookies = session;
  }

  await loader.login(email, password);

  return loader;
}
