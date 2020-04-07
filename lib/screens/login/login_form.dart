import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _usernameController.addListener(_onFormChanged);
    _passwordController.addListener(_onFormChanged);
  }

  bool get _isPopulated =>
      _usernameController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (BuildContext context, state) {
        if (state.isFailure) {
          // TODO: Show more failure info
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(
                'An error occured',
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.red,
            ));
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Column(
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.only(top: 14.0),
                  hintText: 'District Username',
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.only(top: 14.0),
                  hintText: 'District Password',
                ),
              ),
              RaisedButton(
                color: Colors.blue,
                onPressed: _loginButtonEnabled(state) ? _onFormSubmitted : null,
                child: Text('Login'),
              ),
              if (state.isLoading) CircularProgressIndicator(),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onFormSubmitted() async {
    var username = _username;
    var password = _password;
    _loginBloc.add(LoginPressed(username: username, password: password));
  }

  bool _loginButtonEnabled(LoginState state) {
    return !state.isLoading && _isPopulated;
  }

  void _onFormChanged() {
    setState(() {});
  }

  String get _password => _passwordController.text.trim();

  String get _username => _usernameController.text.trim();
}
