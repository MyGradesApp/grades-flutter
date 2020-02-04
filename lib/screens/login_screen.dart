import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grades/models/current_session.dart';
import 'package:grades/utilities/auth.dart';
import 'package:grades/utilities/error.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:grades/widgets/loader_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sis_loader/sis_loader.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loggingIn = false;

  @override
  initState() {
    super.initState();
    _loadSavedCreds();
  }

  Future<void> _loadSavedCreds() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('sis_email');
    var password = prefs.getString('sis_password');
    _emailController.value = _emailController.value.copyWith(text: email);
    _passwordController.value =
        _passwordController.value.copyWith(text: password);
  }

  void _handleLoginPressed() async {
    // removes keyboard on click
    FocusScope.of(context).unfocus();
    var email = _emailController.text;
    var password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      return;
    }

    try {
      setState(() {
        _loggingIn = true;
      });
      var loader = await attemptLogin(email, password);
      setState(() {
        _loggingIn = false;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('sis_email', email);
      await prefs.setString('sis_password', password);
      await prefs.setString('sis_session', loader.sessionCookies);

      Provider.of<CurrentSession>(context, listen: false).setSisLoader(loader);
      Navigator.pop(context);
    } on InvalidAuthException catch (e) {
      showErrorSnackbar(_scaffoldKey.currentState, e.message);
    } on UnknownInvalidAuthException catch (e, stackTrace) {
      // TODO: Until we understand this, report it
      await reportException(
        exception: e.message,
        stackTrace: stackTrace,
      );
      showErrorSnackbar(_scaffoldKey.currentState, e.message);
    } on SocketException catch (_) {
      showErrorSnackbar(_scaffoldKey.currentState, 'Issue connecting to SIS');
    } on HttpException catch (_) {
      showErrorSnackbar(_scaffoldKey.currentState, 'Issue connecting to SIS');
    } on HandshakeException catch (_) {
      showErrorSnackbar(_scaffoldKey.currentState, 'Issue connecting to SIS');
    } on OSError catch (_) {
      showErrorSnackbar(_scaffoldKey.currentState, 'Issue connecting to SIS');
    } catch (e, stackTrace) {
      showErrorSnackbar(_scaffoldKey.currentState, 'An unknown error occurred');
      await reportException(
        exception: e,
        stackTrace: stackTrace,
      );
    } finally {
      setState(() {
        _loggingIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xff2d3d54),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SizedBox.expand(
            child: SingleChildScrollView(
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
                  const Text(
                    'Your grades at a glance',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 45.0),
                  Column(
                    children: <Widget>[
                      _buildEmailTF(),
                      const SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      Visibility(
                        visible: !_loggingIn,
                        child: _buildLoginBtn(),
                        replacement: Padding(
                          padding: const EdgeInsets.only(top: 32.0),
                          child: LoaderWidget(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'District Username',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: boxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'District Password',
              hintStyle: hintTextStyle,
            ),
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          width: double.infinity,
          child: RaisedButton(
            elevation: 5.0,
            onPressed: _handleLoginPressed,
            padding: const EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: const Color(0xff2a84d2),
            // background: linear-gradient(100deg, #4cc6b9, #07b5d0);
            child: const Text(
              'LOGIN',
              style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

final hintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final labelStyle = const TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final boxDecorationStyle = BoxDecoration(
  color: const Color(0xFF3f5573),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: const Offset(0, 2),
    ),
  ],
);
