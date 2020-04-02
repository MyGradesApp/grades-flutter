import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grades/blocs/course_list/course_list_bloc.dart';
import 'package:grades/blocs/offline/offline_bloc.dart';
import 'package:grades/blocs/upcoming/upcoming_bloc.dart';
import 'package:grades/repos/sis_repository.dart';
import 'package:grades/screens/home_screen/course_list_page.dart';
import 'package:grades/screens/home_screen/upcoming_page.dart';

class HomeScreen extends StatefulWidget {
  final SISRepository _sisRepository;

  HomeScreen({@required SISRepository sisRepository})
      : assert(sisRepository != null),
        _sisRepository = sisRepository;

  @override
  _HomeScreenState createState() =>
      _HomeScreenState(sisRepository: _sisRepository);
}

class _HomeScreenState extends State<HomeScreen> {
  final SISRepository _sisRepository;
  final PageController controller = PageController(initialPage: 1);
  List<Widget> pages;

  _HomeScreenState({@required SISRepository sisRepository})
      : assert(sisRepository != null),
        _sisRepository = sisRepository {
    pages = [
      BlocProvider<UpcomingBloc>(
        create: (BuildContext context) =>
            UpcomingBloc(sisRepository: _sisRepository)..add(FetchData()),
        child: UpcomingPage(),
      ),
      BlocProvider<CourseListBloc>(
        create: (BuildContext context) =>
            CourseListBloc(sisRepository: _sisRepository)..add(FetchCourses()),
        child: CourseListPage(),
      ),
    ];
  }

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
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: pages.length,
              itemBuilder: (context, position) => pages[position],
            ),
          ),
          BlocBuilder<OfflineBloc, OfflineState>(
            builder: (BuildContext context, OfflineState state) {
              return Text('Offline: ${state.offline}');
            },
          ),
        ],
      ),
    );
  }
}
