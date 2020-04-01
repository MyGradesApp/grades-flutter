import 'package:flutter/cupertino.dart';
import 'package:grades/providers/current_session.dart';
import 'package:grades/utilities/patches/wrapped_secure_storage.dart';
import 'package:provider/provider.dart';

import 'helpers/auth.dart';

void attemptSwitchToOnline(
    BuildContext context, Function(bool) loginStateCallback) async {
  var secure = const WrappedSecureStorage();
  var email = await secure.read(key: 'sis_email');
  var password = await secure.read(key: 'sis_password');
  var session = await secure.read(key: 'sis_session');

  loginStateCallback?.call(true);

  try {
    var loader = await attemptLogin(
      context,
      email,
      password,
      session,
    );
    Provider.of<CurrentSession>(context, listen: false).setSisLoader(loader);
    Provider.of<CurrentSession>(context, listen: false).setOfflineStatus(false);
    loginStateCallback(false);
  } catch (_) {}
  loginStateCallback(false);
}
