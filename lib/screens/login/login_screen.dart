import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/screens/login/login_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final SharedPreferences prefs;

  LoginScreen({@required this.prefs});

  @override
  _LoginScreenState createState() => _LoginScreenState(prefs: prefs);
}

class _LoginScreenState extends State<LoginScreen> {
  final SharedPreferences prefs;

  _LoginScreenState({@required this.prefs});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Screen')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(
                sisRepository: RepositoryProvider.of<SISRepository>(context),
                prefs: prefs),
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}
