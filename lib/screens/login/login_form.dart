import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/utilities/status.dart';
import 'package:grades/utilities/update.dart';
import 'package:grades/widgets/loading_indicator.dart';
import 'package:sis_loader/sis_loader.dart';

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
      listener: (context, state) {
        if (state.isFailure) {
          if (state.error is InvalidAuthException) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(
                  'Incorrect username or password',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.red,
              ));
          } else {
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
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Container(
            height: double.infinity,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 40.0,
                right: 40.0,
                top: 120.0,
                bottom: 45.0,
              ),
              child: Column(
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
                  const Center(
                    child: Text(
                      'Your grades at a glance',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  const SizedBox(height: 25.0),
                  _buildInputField(
                    placeholder: 'District Username',
                    password: false,
                  ),
                  const SizedBox(height: 40.0),
                  _buildInputField(
                    placeholder: 'District Password',
                    password: true,
                  ),
                  const SizedBox(height: 35.0),
                  if (!state.isLoading) _buildLoginButton(state),
                  if (state.isLoading)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: LoadingIndicator(),
                    ),
                  const SizedBox(height: 20.0),
                  getStatusCard(),
                  getUpdateCard(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Column _buildInputField({
    @required String placeholder,
    @required bool password,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: const Color(0xFF3f5573),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextField(
            controller: password ? _passwordController : _usernameController,
            obscureText: password,
            style: textStyle,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                password ? FontAwesomeIcons.lock : FontAwesomeIcons.userAlt,
                color: Colors.white,
              ),
              hintText: placeholder,
              hintStyle: textStyle.copyWith(
                color: Colors.white54,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(LoginState state) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: _loginButtonEnabled(state) ? _onFormSubmitted : null,
        padding: const EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: const Color(0xff2a84d2),
        child: Text(
          'LOGIN',
          style: textStyle.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Future<void> _onFormSubmitted() async {
    var currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

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

final textStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'OpenSans',
);
