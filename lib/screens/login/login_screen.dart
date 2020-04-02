import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grades/blocs/login/login_bloc.dart';
import 'package:grades/repos/authentication_repository.dart';
import 'package:grades/screens/login/login_form.dart';

class LoginScreen extends StatefulWidget {
  final SISRepository _sisRepository;

  LoginScreen({@required SISRepository sisRepository})
      : assert(sisRepository != null),
        _sisRepository = sisRepository;

  @override
  _LoginScreenState createState() =>
      _LoginScreenState(sisRepository: _sisRepository);
}

class _LoginScreenState extends State<LoginScreen> {
  final SISRepository _sisRepository;

  _LoginScreenState({@required SISRepository sisRepository})
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
                LoginBloc(sisRepository: _sisRepository),
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}
