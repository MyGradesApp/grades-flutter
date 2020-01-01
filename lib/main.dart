import 'package:flutter/material.dart';
import 'package:grades/screens/academic_information_screen.dart';
import 'package:grades/screens/course_grades_screen.dart';
import 'package:grades/screens/course_list_screen.dart';
import 'package:grades/screens/login_screen.dart';
import 'package:provider/provider.dart';

import 'models/current_session.dart';

void main() => runApp(MyApp());

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
            brightness: Brightness.dark,
            primaryColor: Colors.blueGrey,
//            backgroundColor: Color(0xff2a84d2),
            appBarTheme: AppBarTheme(color: Color(0xff2a84d2)),
            scaffoldBackgroundColor: Color(0xff2a84d2),
          ),
          routes: <String, WidgetBuilder>{
            '/courses': (BuildContext context) => CourseListScreen(),
            '/course_grades': (BuildContext context) => CourseGradesScreen(),
            '/academic_info': (BuildContext context) => AcademicInfoScreen(),
          },
        ));
  }
}
