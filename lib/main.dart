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

  var offlineBloc = OfflineBloc();
  var prefs = await SharedPreferences.getInstance();
  var sisRepository = SISRepository(offlineBloc, prefs);
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) =>
            AuthenticationBloc(sisRepository: sisRepository, prefs: prefs)
              ..add(AppStarted()),
      ),
      BlocProvider(
        create: (context) => ThemeBloc(
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
        create: (context) => offlineBloc,
      ),
    ],
    child: App(
      sisRepository: sisRepository,
      prefs: prefs,
    ),
  ));
}

class App extends StatelessWidget {
  final SharedPreferences prefs;
  final SISRepository _sisRepository;

  App({@required SISRepository sisRepository, @required this.prefs})
      : assert(sisRepository != null),
        _sisRepository = sisRepository;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'SwiftGrade',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          builder: (BuildContext context, Widget child) {
            return Column(
              children: [
                Expanded(child: child),
                BlocBuilder<OfflineBloc, bool>(
                  builder: (BuildContext context, offline) {
                    if (offline) {
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
            '/course_grades': (context) => CourseGradesScreen(
                  sisRepository: _sisRepository,
                ),
            '/grade_info': (context) => GradeInfoScreen(),
            '/settings': (context) => SettingsScreen(),
            '/academic_info': (context) => BlocProvider(
                  create: (context) =>
                      AcademicInfoBloc(sisRepository: _sisRepository)
                        ..add(FetchNetworkData()),
                  child: AcademicInfoScreen(),
                ),
          },
          home: AppRoot(
            sisRepository: _sisRepository,
            prefs: prefs,
          ),
        );
      },
    );
  }
}

class AppRoot extends StatelessWidget {
  final SharedPreferences prefs;
  final SISRepository _sisRepository;

  const AppRoot({
    Key key,
    @required SISRepository sisRepository,
    @required this.prefs,
  })  : _sisRepository = sisRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (BuildContext context, AuthenticationState state) {
        if (state is Uninitialized) {
          return SplashScreen();
        } else if (state is Unauthenticated) {
          return LoginScreen(
            sisRepository: _sisRepository,
            prefs: prefs,
          );
        } else if (state is Authenticated) {
          return HomeScreen(
            sisRepository: _sisRepository,
          );
        }
        return null;
      },
    );
  }
}
