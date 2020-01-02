import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grades/screens/academic_information_screen.dart';
import 'package:grades/screens/course_grades_screen.dart';
import 'package:grades/screens/course_list_screen.dart';
import 'package:grades/screens/login_screen.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:provider/provider.dart';

import 'models/current_session.dart';

void main() async {
  FlutterError.onError = (details, {bool forceReport = false}) {
    try {
      sentry.captureException(
        exception: details.exception,
        stackTrace: details.stack,
      );
    } catch (e) {
      print('Sending report to sentry.io failed: $e');
    } finally {
      // Also use Flutter's pretty error logging to the device's console.
      FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
    }
  };
// fix force portrait
  //   await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runZoned(() => runApp(MyApp()),
      onError: (Object error, StackTrace stackTrace) {
    try {
      sentry.captureException(
        exception: error,
        stackTrace: stackTrace,
      );
      print('Error sent to sentry.io: $error');
    } catch (e) {
      print('Sending report to sentry.io failed: $e');
      print('Original error: $error');
    }
  });
}

class MyApp extends StatelessWidget {
  // root of application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => CurrentSession())],
        child: MaterialApp(
          title: 'Flutter Login UI',
          debugShowCheckedModeBanner: false,
          home: LoginScreen(),
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xff2a84d2),

            // DECIDE ON COLOR SCHEME
            //backgroundColor: Color(0xff2a84d2),
            // appBarTheme: AppBarTheme(color: Color(0xff2980b9)),
            appBarTheme: const AppBarTheme(color: Color(0xff2a84d2)),
            // scaffoldBackgroundColor: Color(0xff2980b9),
            scaffoldBackgroundColor: const Color(0xff2a84d2),
          ),
          routes: <String, WidgetBuilder>{
            '/courses': (BuildContext context) => CourseListScreen(),
            '/course_grades': (BuildContext context) => CourseGradesScreen(),
            '/academic_info': (BuildContext context) => AcademicInfoScreen(),
          },
        ));
  }
}
