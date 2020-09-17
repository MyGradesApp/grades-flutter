import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/screens/login/login_form.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      // keeps fab from covering keyboard
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xff2a84d2),
          foregroundColor: Colors.white,
          onPressed: () {
            var _feedback = Uri(
                scheme: 'mailto',
                path: 'support@getswiftgrade.com',
                queryParameters: <String, String>{
                  'subject': 'SwiftGrade Inquiry'
                });
            launch(_feedback.toString());
          },
          label: Text('Support'),
          icon: Icon(FontAwesomeIcons.solidCommentAlt)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
