import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:grades/providers/current_session.dart';
import 'package:grades/utilities/helpers/auth.dart';
import 'package:grades/utilities/patches/wrapped_secure_storage.dart';
import 'package:provider/provider.dart';

class OfflineStatusBar extends StatefulWidget {
  OfflineStatusBar({Key key}) : super(key: key);

  @override
  _OfflineStatusBarState createState() => _OfflineStatusBarState();
}

class _OfflineStatusBarState extends State<OfflineStatusBar> {
  bool _loggingIn = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: double.infinity,
        color: Colors.orange,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'No Network Connection',
                ),
                const SizedBox(width: 40),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    color: Colors.orangeAccent,
                    onPressed: () async {
                      var secure = const WrappedSecureStorage();
                      var email = await secure.read(key: 'sis_email');
                      var password = await secure.read(key: 'sis_password');
                      var session = await secure.read(key: 'sis_session');

                      if (mounted) {
                        setState(() {
                          _loggingIn = true;
                        });
                      }

                      try {
                        var loader = await attemptLogin(
                          context,
                          email,
                          password,
                          session,
                        );
                        Provider.of<CurrentSession>(context, listen: false)
                            .setSisLoader(loader);
                        Provider.of<CurrentSession>(context, listen: false)
                            .setOfflineStatus(false);
                      } catch (_) {}
                      if (mounted) {
                        setState(() {
                          _loggingIn = false;
                        });
                      }
                    },
                    child: Row(
                      children: <Widget>[
                        const Text(
                          'Refresh',
                          style: TextStyle(color: Colors.white),
                        ),
                        if (_loggingIn)
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: SpinKitRing(
                              color: Colors.white,
                              lineWidth: 3,
                              size: 20.0,
                            ),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
