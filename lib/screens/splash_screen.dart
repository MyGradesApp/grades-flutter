import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grades/providers/current_session.dart';
import 'package:grades/utilities/helpers/auth.dart';
import 'package:grades/utilities/patches/wrapped_secure_storage.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:grades/widgets/loader_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sis_loader/sis_loader.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _loadStoredAuth();
  }

  void _loadStoredAuth({bool force = false, bool freshSession = false}) async {
    var prefs = await SharedPreferences.getInstance();
    var hasAcceptedTerms = prefs.getBool('accepted_terms') ?? false;

    if (!hasAcceptedTerms) {
      await Navigator.pushNamed(context, '/terms');
    }

    var secure = const WrappedSecureStorage();
    var email = await secure.read(key: 'sis_email');
    var password = await secure.read(key: 'sis_password');
    var session = await secure.read(key: 'sis_session');

    // First time login flow
    if (email == null ||
        email.isEmpty ||
        password == null ||
        password.isEmpty ||
        force) {
      await Navigator.pushNamed(context, '/login');

      Provider.of<CurrentSession>(context, listen: false)
          .setOfflineStatus(false);
      await _showCourses(prefs);
      return;
    }

    // Re-auth flow
    try {
      var loader = await attemptLogin(
        context,
        email,
        password,
        freshSession ? null : session,
      );
      Provider.of<CurrentSession>(context, listen: false).setSisLoader(loader);
      Provider.of<CurrentSession>(context, listen: false)
          .setOfflineStatus(false);

      await _showCourses(prefs);
      return;
      // TODO: Actually return a login fail message here
    } on NoSuchMethodError catch (_) {
      // TODO: Pass login failure error message to login page
      if (!freshSession) {
        _loadStoredAuth(freshSession: true);
      } else {
        _loadStoredAuth(force: true);
      }
    } on InvalidAuthException catch (_) {
      // TODO: Pass login failure error message to login page
      _loadStoredAuth(force: true);
    } on HttpException catch (_) {
      Provider.of<CurrentSession>(context, listen: false)
          .setOfflineStatus(true);
    } on SocketException catch (_) {
      Provider.of<CurrentSession>(context, listen: false)
          .setOfflineStatus(true);
    } on HandshakeException catch (_) {
      Provider.of<CurrentSession>(context, listen: false)
          .setOfflineStatus(true);
    } on OSError catch (_) {
      Provider.of<CurrentSession>(context, listen: false)
          .setOfflineStatus(true);
    } catch (e, stackTrace) {
      setState(() {
        _showError = true;
      });
      await reportException(
        exception: e,
        stackTrace: stackTrace,
      );
      print(e);
      print(stackTrace);
    }
    if (Provider.of<CurrentSession>(context, listen: false).isOffline) {
      await _showCourses(prefs);
    }
  }

  Future _showCourses(SharedPreferences prefs) async {
    var logoff = await Navigator.pushNamed(context, '/home');

    // We return true from courses if the logout button is pressed,
    // so we need to show the login screen and clear the session values
    if (logoff is bool && logoff) {
      await const WrappedSecureStorage().delete(key: 'sis_session');
      await const WrappedSecureStorage().delete(key: 'sis_password');
      _loadStoredAuth(force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff195080),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xff195080),
              ),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 120.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'SwiftGrade',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    const Text(
                      'Your grades at a glance',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Visibility(
                      visible: !_showError,
                      child: LoaderWidget(),
                      replacement: Padding(
                        padding: const EdgeInsets.only(top: 55.0),
                        child: Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
