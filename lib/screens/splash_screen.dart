import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grades/models/current_session.dart';
import 'package:grades/utilities/auth.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _loadStoredAuth();
  }

  _loadStoredAuth({bool force = false}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var hasAcceptedTerms = prefs.getBool("accepted_terms") ?? false;

    if (!hasAcceptedTerms) {
      await Navigator.pushNamed(context, '/terms');
    }

    var email = prefs.getString('sis_email');
    var password = prefs.getString('sis_password');
    var session = prefs.getString('sis_session');

    // First time login flow
    if (email == null ||
        email.isEmpty ||
        password == null ||
        password.isEmpty ||
        force) {
      var loader = await Navigator.pushNamed(context, '/login');
      Provider.of<CurrentSession>(context, listen: false).setSisLoader(loader);

      await _showCourses(prefs);
      return;
    }

    // Re-auth flow
    try {
      var loader = await attemptLogin(
        email,
        password,
        session,
      );
      Provider.of<CurrentSession>(context, listen: false).setSisLoader(loader);

      await _showCourses(prefs);
      return;
    } on NoSuchMethodError catch (_) {
      // TODO: Pass login failure error message to login page
      _loadStoredAuth(force: true);
    } on InvalidAuthException catch (_) {
      // TODO: Pass login failure error message to login page
      _loadStoredAuth(force: true);
    } on HttpException catch (_) {
      _scaffoldKey.currentState.showSnackBar(
          errorSnackbar('Login failed due to connection issues.'));
      setState(() {
        _showError = true;
      });
    } on SocketException catch (_) {
      _scaffoldKey.currentState.showSnackBar(
          errorSnackbar('Login failed due to connection issues.'));
      setState(() {
        _showError = true;
      });
    } catch (e, stackTrace) {
      setState(() {
        _showError = true;
      });
      await sentry.captureException(
        exception: e,
        stackTrace: stackTrace,
      );
      print(e);
      print(stackTrace);
    }
  }

  Future _showCourses(SharedPreferences prefs) async {
    var logoff = await Navigator.pushNamed(context, '/courses');
    // We return true from courses if the logout button is pressed,
    // so we need to show the login screen and clear the session values
    if (logoff is bool && logoff) {
      await prefs.remove('sis_session');
      _loadStoredAuth();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2d3d54),
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xff2d3d54),
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
                      Text(
                        'SwiftGrade',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 25.0),
                      Text(
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
      ),
    );
  }

  SnackBar errorSnackbar(String message) {
    return SnackBar(
      backgroundColor: Colors.red,
      // HACK: Persistent display
      duration: const Duration(days: 1),
      action: SnackBarAction(
        label: "Try again",
        textColor: Colors.white,
        onPressed: () {
          setState(() {
            _showError = false;
          });
          _loadStoredAuth();
        },
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
