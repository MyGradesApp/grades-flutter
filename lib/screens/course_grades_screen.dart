import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grades/providers/current_session.dart';
import 'package:grades/providers/theme_controller.dart';
import 'package:grades/sis-cache/sis_loader.dart';
import 'package:grades/utilities/helpers/error.dart';
import 'package:grades/utilities/patches/stacked_future_builder.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:grades/widgets/course_grades_display.dart';
import 'package:grades/widgets/loader_widget.dart';
import 'package:grades/widgets/refreshable/refreshable_error_message.dart';
import 'package:grades/widgets/refreshable/refreshable_icon_message.dart';
import 'package:provider/provider.dart';

class CourseGradesScreen extends StatefulWidget {
  @override
  _CourseGradesScreenState createState() => _CourseGradesScreenState();
}

class _CourseGradesScreenState extends State<CourseGradesScreen> {
  bool _hasCategories = false;

  // Track whether we have set the above variable ot prevent repeated updates
  bool _hasSetCategories = false;
  GroupingMode _currentGroupingMode;

  @override
  void initState() {
    super.initState();
    _currentGroupingMode =
        Provider.of<ThemeController>(context, listen: false).defaultGroupMode;
  }

  // Handle exception for RefreshIndicator
  Future<FetchedCourseData> _refresh() async {
    var result = await catchFutureHttpError(
      () => _getData(),
      onHttpError: () {
        Provider.of<CurrentSession>(context, listen: false)
            .setOfflineStatus(true);
        Provider.of<CurrentSession>(context, listen: false).setSisLoader(null);
      },
    );
    setState(() {});
    return result;
  }

  Future<FetchedCourseData> _getData({bool force = true}) {
    final course = ModalRoute.of(context).settings.arguments as CachedCourse;
    if (Provider.of<CurrentSession>(context, listen: false).isOffline) {
      return Provider.of<CurrentSession>(context, listen: false)
          .courseData(context, course, force: force, offlineOnly: true);
    }
    try {
      return Provider.of<CurrentSession>(context, listen: false)
          .courseData(context, course, force: force);
    } catch (_) {
      Provider.of<CurrentSession>(context, listen: false)
          .setOfflineStatus(true);
      Provider.of<CurrentSession>(context, listen: false).setSisLoader(null);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = ModalRoute.of(context).settings.arguments as CachedCourse;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text('${course.courseName}'),
        leading: IconButton(
          tooltip: 'Back',
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: [
          if (_hasCategories)
            IconButton(
              icon: Icon(_currentGroupingMode == GroupingMode.Category
                  ? Icons.today
                  : Icons.format_list_bulleted),
              onPressed: () {
                setState(() {
                  _currentGroupingMode = _currentGroupingMode.toggled();
                });
              },
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: StackedFutureBuilder<FetchedCourseData>(
            future: _getData(force: false),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (!_hasSetCategories) {
                  Future.microtask(
                    () => setState(() {
                      _hasCategories = snapshot.data.hasCategories;
                      _hasSetCategories = true;
                    }),
                  );
                }
                if (snapshot.data.grades.isEmpty) {
                  return RefreshableIconMessage(
                    onRefresh: _refresh,
                    icon: Icon(
                      FontAwesomeIcons.inbox,
                      size: 55,
                      color: Colors.white,
                    ),
                    child: const Text(
                      'There are no grades listed in this class',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                  );
                }
                return CourseGradesDisplay(
                  snapshot.data.grades,
                  snapshot.data.categoryWeights,
                  snapshot.data.hasCategories
                      ? _currentGroupingMode
                      : GroupingMode.Date,
                  course.courseName,
                );
              } else if (snapshot.hasError) {
                if (isHttpError(snapshot.error)) {
                  return RefreshableErrorMessage(
                    onRefresh: _refresh,
                    text: 'Issue connecting to SIS',
                  );
                }
                reportException(
                  exception: snapshot.error,
                  stackTrace: snapshot.stackTrace,
                );

                return RefreshableErrorMessage(
                  onRefresh: _refresh,
                  text:
                      'An error occured fetching grades:\n\n${snapshot.error}\n\nPull to refresh.\nIf the error persists, restart the app.',
                );
              }

              return Center(child: LoaderWidget());
            }),
      ),
    );
  }
}
