import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grades/blocs/course_list/course_list_bloc.dart';
import 'package:grades/repos/sis_repository.dart';
import 'package:grades/screens/home_screen/course_list_page.dart';

class HomeScreen extends StatelessWidget {
  final SISRepository _sisRepository;

  HomeScreen({@required SISRepository sisRepository})
      : assert(sisRepository != null),
        _sisRepository = sisRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home screen'),
        leading: IconButton(
          tooltip: 'Profile',
          icon: Icon(
            Icons.person,
          ),
          onPressed: () => Navigator.pushNamed(context, '/academic_info'),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Settings',
            icon: Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: BlocProvider<CourseListBloc>(
        create: (BuildContext context) =>
            CourseListBloc(sisRepository: _sisRepository)..add(FetchCourses()),
        child: CourseListPage(),
      ),
    );
  }
}
