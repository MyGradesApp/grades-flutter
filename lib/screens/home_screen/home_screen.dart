import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grades/blocs/course_list/course_list_bloc.dart';
import 'package:grades/blocs/feed/feed_event.dart';
import 'package:grades/blocs/feed/recent/recent_bloc.dart';
import 'package:grades/blocs/feed/upcoming/upcoming_bloc.dart';
import 'package:grades/repos/sis_repository.dart';
import 'package:grades/screens/home_screen/course_list_page.dart';
import 'package:grades/screens/home_screen/recent_page.dart';
import 'package:grades/screens/home_screen/upcoming_page.dart';
import 'package:grades/widgets/offline_bar.dart';

import '../../widgets/offline_bar.dart';

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

  List<BlocProvider<dynamic>> providers;

  _HomeScreenState({@required SISRepository sisRepository})
      : assert(sisRepository != null),
        _sisRepository = sisRepository {
    providers = [
      BlocProvider<RecentBloc>(
        create: (BuildContext context) =>
            RecentBloc(sisRepository: _sisRepository)..add(FetchData()),
      ),
      BlocProvider<CourseListBloc>(
        create: (BuildContext context) =>
            CourseListBloc(sisRepository: _sisRepository)..add(FetchCourses()),
      ),
      BlocProvider<UpcomingBloc>(
        create: (BuildContext context) =>
            UpcomingBloc(sisRepository: _sisRepository)..add(FetchData()),
      ),
    ];
    pages = [
      RecentPage(),
      CourseListPage(),
      UpcomingPage(),
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
            child: MultiBlocProvider(
              providers: providers,
              child: PageView.builder(
                controller: controller,
                itemCount: pages.length,
                itemBuilder: (context, position) => pages[position],
              ),
            ),
          ),
          OfflineBar(),
        ],
      ),
    );
  }
}
