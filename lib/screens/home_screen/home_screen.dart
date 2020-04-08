import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/screens/home_screen/course_list_page.dart';
import 'package:grades/screens/home_screen/recent_page.dart';
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

  List<BlocProvider<dynamic>> providers;

  _HomeScreenState({@required SISRepository sisRepository})
      : assert(sisRepository != null),
        _sisRepository = sisRepository {
    providers = [
      BlocProvider<RecentBloc>(
        create: (_) =>
            RecentBloc(sisRepository: _sisRepository)..add(FetchData()),
      ),
      BlocProvider<CourseListBloc>(
        create: (_) => CourseListBloc(sisRepository: sisRepository)
          ..add(FetchNetworkData()),
      ),
      BlocProvider<UpcomingBloc>(
        create: (_) =>
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
      body: MultiBlocProvider(
        providers: providers,
        child: PageView.builder(
          controller: controller,
          itemCount: pages.length,
          itemBuilder: (context, position) => pages[position],
        ),
      ),
    );
  }
}
