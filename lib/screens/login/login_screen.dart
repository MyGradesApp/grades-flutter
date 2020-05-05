import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/screens/login/login_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();

    // TODO: This should be moved, maybe into authentication_bloc
    () async {
      var prefs = await SharedPreferences.getInstance();
      var hasAcceptedTerms = prefs.getBool('accepted_terms') ?? false;

      if (!hasAcceptedTerms) {
        await Navigator.pushNamed(context, '/terms_query');
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2d3d54),
      body: Center(
        child: BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
              sisRepository: RepositoryProvider.of<SISRepository>(context)),
          child: LoginForm(),
        ),
      ),
    );
  }
}
