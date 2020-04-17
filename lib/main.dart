import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/screens/academic_info_screen.dart';
import 'package:grades/screens/course_grades/course_grades_screen.dart';
import 'package:grades/screens/grade_info_screen.dart';
import 'package:grades/screens/home_screen/home_screen.dart';
import 'package:grades/screens/login/login_screen.dart';
import 'package:grades/screens/settings_screen.dart';
import 'package:grades/screens/splash_screen.dart';
import 'package:grades/simple_bloc_delegate.dart';
import 'package:grades/widgets/offline_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();

  var package_info = await getPackageInfo();
  // Used for sentry error reporting and settings page version number
  GRADES_VERSION = '${package_info.version}+${package_info.buildNumber}';

  var offlineBloc = OfflineBloc();
  var prefs = await SharedPreferences.getInstance();
  var dataPersistence = DataPersistence(prefs);
  var sisRepository = SISRepository(offlineBloc, dataPersistence);

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
          create: (_) => offlineBloc,
        ),
      ],
      child: App(
        sisRepository: sisRepository,
      ),
    ),
  ));
}

class App extends StatelessWidget {
  final SISRepository _sisRepository;

  App({@required SISRepository sisRepository})
      : assert(sisRepository != null),
        _sisRepository = sisRepository;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeMode>(
      builder: (context, ThemeMode themeMode) {
        return MaterialApp(
          title: 'SwiftGrade',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          builder: (context, child) {
            return Column(
              children: [
                Expanded(child: child),
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
            );
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
