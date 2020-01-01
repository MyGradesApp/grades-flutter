import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grades/models/current_session.dart';
import 'package:grades/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sis_loader/sis_loader.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  bool _forceUi = false;
  String _errorMessage;
  String _session;

  @override
  void initState() {
    _loadStoredAuth();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  _loadStoredAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('sis_email');
    var password = prefs.getString('sis_password');
    _emailController.value = _emailController.value.copyWith(text: email);
    _passwordController.value =
        _passwordController.value.copyWith(text: password);
    _attemptLogin(
      email,
      password,
    );
  }

  Future<void> _attemptLogin(
    String email,
    String password,
  ) async {
    var loader = SISLoader();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _session = prefs.getString('sis_session');
    });

    if (_session != null) {
      loader.sessionCookies = _session;
    }

    if ((email != null &&
            email.isNotEmpty &&
            password != null &&
            password.isNotEmpty) ||
        _session != null) {
      try {
        setState(() {
          _loading = true;
          _errorMessage = null;
        });
        await loader.login(email, password);
        prefs.setString('sis_session', loader.sessionCookies);

        Provider.of<CurrentSession>(context, listen: false)
            .setSisLoader(loader);
        var response = await Navigator.pushNamed(context, '/courses');
        print(response);
        if (response is bool) {
          setState(() {
            _forceUi = response;
          });
        }
      } on InvalidAuthException catch (e) {
        setState(() {
          _errorMessage = e.message;
        });
      } catch (e) {
        // If the session is invalid, clear it and force a normal login
        if (_session != null) {
          prefs.remove('sis_session');
          _attemptLogin(email, password);
          return;
        }
        setState(() {
          _errorMessage = "Unknown error:\n$e";
        });
        rethrow;
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  _handleLoginPressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = _emailController.text;
    var password = _passwordController.text;
    if (email != prefs.getString('sis_email') ||
        password != prefs.getString('sis_password')) {
      prefs.remove('sis_session');
    }
    prefs.setString('sis_email', email);
    prefs.setString('sis_password', password);
    _attemptLogin(email, password);
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Username',
              hintStyle: kHintTextStyle,
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
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: _handleLoginPressed,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color(0xff2a84d2),
        // background: linear-gradient(100deg, #4cc6b9, #07b5d0);
        child: Text(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff2d3d54),
                  // gradient: LinearGradient(
                  //   begin: Alignment.topCenter,
                  //   end: Alignment.bottomCenter,
                  //   colors: [
                  //     Color(0xFF73AEF5),
                  //     Color(0xFF61A4F1),
                  //     Color(0xFF478DE0),
                  //     Color(0xFF398AE5),
                  //   ],
                  //   stops: [0.1, 0.4, 0.7, 0.9],
                  // ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Grades to Go',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Text(
                        'Your grades at a glance',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 35.0),
                      Visibility(
                          visible: !_loading || _session == null || _forceUi,
                          // Fixes alignment issues
                          replacement: Container(),
                          child: Column(
                            children: <Widget>[
                              _buildEmailTF(),
                              SizedBox(
                                height: 30.0,
                              ),
                              _buildPasswordTF(),
                              _buildLoginBtn(),
                            ],
                          )),
                      Visibility(
                        visible: _errorMessage != null,
                        child: Text(
                          _errorMessage ?? "",
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: 'OpenSans',
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _loading,
                        child: CircularProgressIndicator(),
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
}
