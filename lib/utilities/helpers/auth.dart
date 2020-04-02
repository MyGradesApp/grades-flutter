import 'package:flutter/widgets.dart';
import 'package:grades/providers/current_session.dart';
import 'package:grades/providers/data_persistence.dart';
import 'package:grades/sis-cache/sis_loader.dart';
import 'package:grades/utilities/patches/wrapped_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:sis_loader/sis_loader.dart';

Future<CachedSISLoader> attemptLogin(
    BuildContext context, String email, String password,
    [String session]) async {
  assert(email != null && email.isNotEmpty);
  assert(password != null && password.isNotEmpty);
  var client = CookieClient();
  Provider.of<DataPersistence>(context, listen: false).setClient(client);
  Provider.of<CurrentSession>(context, listen: false).setClient(client);
  var loader = CachedSISLoader(SISLoader(client: client), email);

  if (session != null) {
    loader.sessionCookies = session;
  }

  await loader.login(email, password);
  if (loader.sessionCookies != null) {
    await const WrappedSecureStorage()
        .write(key: 'sis_session', value: loader.sessionCookies);
  }

  return loader;
}
