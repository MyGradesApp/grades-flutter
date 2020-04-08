import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/screens/login/login_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final SharedPreferences prefs;
  final SISRepository _sisRepository;

  LoginScreen({@required SISRepository sisRepository, @required this.prefs})
      : assert(sisRepository != null),
        _sisRepository = sisRepository;

  @override
  _LoginScreenState createState() =>
      _LoginScreenState(sisRepository: _sisRepository, prefs: prefs);
}

class _LoginScreenState extends State<LoginScreen> {
  final SharedPreferences prefs;
  final SISRepository _sisRepository;

  _LoginScreenState(
      {@required SISRepository sisRepository, @required this.prefs})
      : assert(sisRepository != null),
        _sisRepository = sisRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Screen')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocProvider<LoginBloc>(
            create: (BuildContext context) =>
                LoginBloc(sisRepository: _sisRepository, prefs: prefs),
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}
