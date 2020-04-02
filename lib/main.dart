import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grades/repos/authentication_repository.dart';
import 'package:grades/screens/course_grades/course_grades_screen.dart';
import 'package:grades/screens/grade_info_screen.dart';
import 'package:grades/screens/home_screen.dart';
import 'package:grades/screens/login/login_screen.dart';
import 'package:grades/screens/splash_screen.dart';
import 'package:grades/simple_bloc_delegate.dart';

import 'blocs/authentication/authentication_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  var sisRepository = SISRepository();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) =>
            AuthenticationBloc(sisRepository: sisRepository)..add(AppStarted()),
      ),
    ],
    child: MyApp(
      sisRepository: sisRepository,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final SISRepository _sisRepository;

  MyApp({@required SISRepository sisRepository})
      : assert(sisRepository != null),
        _sisRepository = sisRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwiftGrade',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/course_grades': (context) => CourseGradesScreen(),
        '/grade_info': (context) => GradeInfoScreen(),
      },
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (BuildContext context, AuthenticationState state) {
          if (state is Uninitialized) {
            return SplashScreen();
          } else if (state is Unauthenticated) {
            return LoginScreen(
              sisRepository: _sisRepository,
            );
          } else if (state is Authenticated) {
            return HomeScreen(
              sisRepository: _sisRepository,
            );
          }
          return null;
        },
      ),
    );
  }
}
