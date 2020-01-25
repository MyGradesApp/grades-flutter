import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grades/screens/academic_information_screen.dart';
import 'package:grades/screens/course_grades_screen.dart';
import 'package:grades/screens/course_list_screen.dart';
import 'package:grades/screens/grade_item_detail_screen.dart';
import 'package:grades/screens/login_screen.dart';
import 'package:grades/screens/settings_screen.dart';
import 'package:grades/screens/splash_screen.dart';
import 'package:grades/screens/terms_screen.dart';
import 'package:grades/screens/terms_settings_screen.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:grades/utilities/theme_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/current_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // load the shared preferences from disk before the app is started
  final prefs = await SharedPreferences.getInstance();
  final themeController = ThemeController(prefs);

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
  runZoned(() => runApp(MyApp(themeController: themeController)),
      onError: (Object error, StackTrace stackTrace) {
    try {
      reportException(
        exception: error,
        stackTrace: stackTrace,
      );
    } catch (e) {
      print('Sending report to sentry.io failed: $e');
    }
  });
}

class MyApp extends StatelessWidget with PortraitModeMixin {
  // root of application.
  final ThemeController themeController;
  const MyApp({Key key, this.themeController}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    super.build(context);
    WidgetsBinding.instance.renderView.automaticSystemUiAdjustment = false;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // statusBarColor: Colors.white, //top bar color
      // statusBarIconBrightness: Brightness.dark, //top bar icons
      systemNavigationBarColor: Color(0xffebebeb),
      // Theme.of(context).primaryColor, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
    ));
    return AnimatedBuilder(
        animation: themeController,
        builder: (context, _) {
          // wrap app in inherited widget to provide the ThemeController to all pages
          return ThemeControllerProvider(
            controller: themeController,
            child: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => CurrentSession())
              ],
              child: Builder(
                builder: (context) => MaterialApp(
                  title: 'Flutter Login UI',
                  debugShowCheckedModeBanner: false,
                  home: SplashScreen(),
                  theme: _buildCurrentTheme(),
                  routes: <String, WidgetBuilder>{
                    '/login': (BuildContext context) => LoginScreen(),
                    '/terms': (BuildContext context) => TermsScreen(),
                    '/terms_settings': (BuildContext context) =>
                        TermsSettingsScreen(),
                    '/settings': (BuildContext context) => SettingsScreen(),
                    '/courses': (BuildContext context) {
                      // Use a key here to prevent overlap in sessions
                      return CourseListScreen(
                          key: Provider.of<CurrentSession>(context).navKey);
                    },
                    '/course_grades': (BuildContext context) =>
                        CourseGradesScreen(),
                    '/grades_detail': (BuildContext context) =>
                        GradeItemDetailScreen(),
                    '/academic_info': (BuildContext context) =>
                        AcademicInfoScreen(),
                  },
                ),
              ),
            ),
          );
        });
  }

  ThemeData _buildCurrentTheme() {
    switch (themeController.currentTheme) {
      case "dark":
        return ThemeData(
          primaryColor: const Color(0xff195080),
          accentColor: const Color(0xff216bac),
          cardColor: const Color(0xff226baa),
          brightness: Brightness.dark,
          primaryColorLight: Colors.white,
        );
      case "light":
      default:
        return ThemeData(
          primaryColor: const Color(0xff2a84d2),
          accentColor: const Color(0xff216bac),
          cardColor: const Color(0xffffffff),
          primaryColorLight: Colors.black,
          brightness: Brightness.light,
        );
    }
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
