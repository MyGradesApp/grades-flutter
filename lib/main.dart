import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grades/screens/academic_information_screen.dart';
import 'package:grades/screens/course_grades_screen.dart';
import 'package:grades/screens/course_list_screen.dart';
import 'package:grades/screens/login_screen.dart';
import 'package:grades/screens/splash_screen.dart';
import 'package:grades/screens/terms_screen.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:provider/provider.dart';

import 'models/current_session.dart';

void main() async {
  FlutterError.onError = (details, {bool forceReport = false}) {
    try {
      reportException(
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
  runZoned(() => runApp(MyApp()),
      onError: (Object error, StackTrace stackTrace) {
    try {
      reportException(
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

class MyApp extends StatelessWidget with PortraitModeMixin {
  // root of application.
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CurrentSession())],
      child: Builder(
        builder: (context) => MaterialApp(
          title: 'Flutter Login UI',
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: const Color(0xff2a84d2),
            appBarTheme: const AppBarTheme(color: Color(0xff2a84d2)),
            scaffoldBackgroundColor: const Color(0xff2a84d2),
          ),
          routes: <String, WidgetBuilder>{
            '/login': (BuildContext context) => LoginScreen(),
            '/terms': (BuildContext context) => TermsScreen(),
            '/courses': (BuildContext context) {
              // Use a key here to prevent overlap in sessions
              return CourseListScreen(
                  key: Provider.of<CurrentSession>(context).navKey);
            },
            '/course_grades': (BuildContext context) => CourseGradesScreen(),
            '/academic_info': (BuildContext context) => AcademicInfoScreen(),
          },
        ),
      ),
    );
  }
}

mixin PortraitModeMixin on StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return null;
  }
}

/// Forces portrait-only mode in mixin
mixin PortraitStatefulModeMixin<T extends StatefulWidget> on State<T> {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return null;
  }

  @override
  void dispose() {
    _enableRotation();
    super.dispose();
  }
}

/// blocks rotation; sets orientation to: portrait
void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

void _enableRotation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}
