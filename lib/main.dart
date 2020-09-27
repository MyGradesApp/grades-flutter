import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/logging_bloc_observer.dart';
import 'package:grades/screens/academic_info_screen.dart';
import 'package:grades/screens/course_grades/course_grades_screen.dart';
import 'package:grades/screens/grade_info_screen.dart';
import 'package:grades/screens/home_screen.dart';
import 'package:grades/screens/login/login_screen.dart';
import 'package:grades/screens/settings_screen.dart';
import 'package:grades/screens/sis_webview.dart';
import 'package:grades/screens/splash_screen.dart';
import 'package:grades/screens/tos_display_screen.dart';
import 'package:grades/screens/tos_query_screen.dart';
import 'package:grades/widgets/offline_bar.dart';
import 'package:grades/widgets/parent_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = LoggingBlocObserver();

  await runZoned(
    () async {
      var package_info = await getPackageInfo();
      // Used for sentry error reporting and settings page version number
      GRADES_VERSION = '${package_info.version}+${package_info.buildNumber}';

      FlutterError.onError = (details, {bool forceReport = false}) {
        reportException(
          exception: details.exception,
          stackTrace: details.stack,
        );
        // Also use Flutter's pretty error logging to the device's console.
        FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
      };

      var offlineBloc = OfflineBloc();
      var prefs = await SharedPreferences.getInstance();
      var dataPersistence = DataPersistence(prefs);
      var sisRepository = SISRepository(offlineBloc, dataPersistence);

      // OneSignal Debugging
      await OneSignal.shared.setLogLevel(OSLogLevel.info, OSLogLevel.none);

      if (Platform.isIOS) {
        await OneSignal.shared.init('41c3762a-0f67-4a24-9976-02826fa6d726',
            iOSSettings: <OSiOSSettings, bool>{
              OSiOSSettings.autoPrompt: false,
              OSiOSSettings.inAppLaunchUrl: true
            });
        await OneSignal.shared
            .setInFocusDisplayType(OSNotificationDisplayType.notification);

        // TODO: shows the iOS push notification prompt. At some point replace with an In-App Message to prompt for notification permission
        await OneSignal.shared
            .promptUserForPushNotificationPermission(fallbackToSettings: true);
      } else if (Platform.isAndroid) {
        await OneSignal.shared.init('41c3762a-0f67-4a24-9976-02826fa6d726');
        await OneSignal.shared
            .setInFocusDisplayType(OSNotificationDisplayType.notification);
      }

      // TODO: Initial notifications for grades implementation
      // on silent notif received
      // OneSignal.shared
      //     .setNotificationReceivedHandler((OSNotification notification) {

      // });

      runApp(MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (_) => dataPersistence),
          RepositoryProvider(create: (_) => sisRepository)
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AuthenticationBloc(
                sisRepository: sisRepository,
                offlineBloc: offlineBloc,
              )..add(AppStarted()),
            ),
            BlocProvider(
              create: (_) => SettingsBloc(
                initialStateSource: () {
                  try {
                    var settings = serializers.deserializeWith(
                      SettingsState.serializer,
                      jsonDecode(prefs.getString('settings')),
                    );
                    return settings;
                  } catch (_) {
                    return SettingsState.defaultSettings();
                  }
                },
                stateSaver: (settings) {
                  prefs.setString(
                    'settings',
                    jsonEncode(
                      serializers.serializeWith(
                          SettingsState.serializer, settings),
                    ),
                  );
                },
              ),
            ),
            BlocProvider(
              create: (_) => ThemeBloc(
                initialStateSource: () {
                  var themeStr = prefs.getString('theme');
                  return ThemeModeExt.fromString(themeStr) ?? ThemeMode.system;
                },
                stateSaver: (theme) {
                  prefs.setString('theme', theme.toPrefsString());
                },
              ),
            ),
            BlocProvider(
              create: (_) => ParentBloc(),
            ),
            BlocProvider(
              create: (_) => offlineBloc,
            ),
          ],
          child: App(
            sisRepository: sisRepository,
          ),
        ),
      ));
    },
    onError: (Object error, StackTrace stackTrace) {
      reportException(
        exception: error,
        stackTrace: stackTrace,
      );
    },
  );
}

class App extends StatelessWidget {
  final SISRepository _sisRepository;

  App({
    @required SISRepository sisRepository,
  })  : assert(sisRepository != null),
        _sisRepository = sisRepository;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeMode>(
      builder: (context, ThemeMode themeMode) {
        return MaterialApp(
          title: 'SwiftGrade',
          theme: ThemeData(
            primaryColor: const Color(0xff2a84d2),
            scaffoldBackgroundColor: const Color(0xff2a84d2),
            accentColor: const Color(0xff216bac),
            cardColor: const Color(0xffffffff),
            primaryColorLight: Colors.black,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            primaryColor: const Color(0xff195080),
            scaffoldBackgroundColor: const Color(0xff195080),
            accentColor: const Color(0xff216bac),
            cardColor: const Color(0xff226baa),
            primaryColorLight: Colors.white,
            brightness: Brightness.dark,
          ),
          themeMode: themeMode,
          builder: (context, child) {
            return Material(
                child: Column(
              children: [
                Expanded(child: child),
                BlocBuilder<ParentBloc, ParentState>(
                  builder: (context, parentState) {
                    if (parentState.isParent) {
                      return ParentBar();
                    } else {
                      return Container();
                    }
                  },
                ),
                BlocBuilder<OfflineBloc, OfflineState>(
                  builder: (context, offlineState) {
                    if (offlineState.offline) {
                      return OfflineBar();
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ));
          },
          routes: {
            '/course_grades': (_) => CourseGradesScreen(),
            '/grade_info': (_) => GradeInfoScreen(),
            '/settings': (_) => SettingsScreen(),
            '/academic_info': (_) => BlocProvider(
                  create: (context) =>
                      AcademicInfoBloc(sisRepository: _sisRepository)
                        ..add(FetchNetworkData()),
                  child: AcademicInfoScreen(),
                ),
            '/sis_webview': (_) => SISWebview(),
            '/terms_query': (_) => TermsQueryScreen(),
            '/terms_display': (_) => TermsDisplayScreen(),
          },
          home: AppRoot(),
        );
      },
    );
  }
}

class AppRoot extends StatelessWidget {
  const AppRoot({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, AuthenticationState state) {
        if (state is Uninitialized) {
          SharedPreferences.getInstance().then((prefs) {
            var hasAcceptedTerms = prefs.getBool('accepted_terms') ?? false;
            if (!hasAcceptedTerms) {
              Navigator.pushNamed(context, '/terms_query');
            }
          });
          return SplashScreen();
        } else if (state is Unauthenticated) {
          return LoginScreen();
        } else if (state is Authenticated) {
          return HomeScreen();
        }
        return null;
      },
    );
  }
}
