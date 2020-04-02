import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grades/blocs/course_list/course_list_bloc.dart';
import 'package:grades/repos/authentication_repository.dart';
import 'package:grades/screens/course_list_screen.dart';

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
      ),
      body: BlocProvider<CourseListBloc>(
        create: (BuildContext context) =>
            CourseListBloc(sisRepository: _sisRepository)..add(FetchCourses()),
        child: CourseListScreen(),
      ),
    );
  }
}
