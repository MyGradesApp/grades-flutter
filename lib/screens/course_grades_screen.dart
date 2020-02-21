import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grades/models/current_session.dart';
import 'package:grades/models/theme_controller.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:grades/utilities/stacked_future_builder.dart';
import 'package:grades/widgets/course_grades_display.dart';
import 'package:grades/widgets/loader_widget.dart';
import 'package:grades/widgets/refreshable_error_message.dart';
import 'package:grades/widgets/refreshable_icon_message.dart';
import 'package:provider/provider.dart';
import 'package:sis_loader/sis_loader.dart';

class CourseGradesScreen extends StatefulWidget {
  @override
  _CourseGradesScreenState createState() => _CourseGradesScreenState();
}

class _CourseGradesScreenState extends State<CourseGradesScreen> {
  bool _hasCategories = false;
  GroupingMode _currentGroupingMode;

  @override
  void initState() {
    super.initState();
    _currentGroupingMode =
        Provider.of<ThemeController>(context, listen: false).defaultGroupMode;
  }

  Future<FetchedCourseData> _getData({bool force = true}) {
    final Course course = ModalRoute.of(context).settings.arguments as Course;
    return Provider.of<CurrentSession>(context, listen: false)
        .fetchCourseData(context, course, force: force);
  }

  @override
  Widget build(BuildContext context) {
    final Course course = ModalRoute.of(context).settings.arguments as Course;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        // title: Text("${course.courseName}"),
        leading: IconButton(
          tooltip: "Back",
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
                  _currentGroupingMode =
                      getToggledGroupingMode(_currentGroupingMode);
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // : MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "${course.gradePercent}.7%",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "${course.courseName}",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'OpenSans',
                fontSize: 20.0,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            RefreshIndicator(
              onRefresh: () => _getData(force: true),
              child: StackedFutureBuilder<FetchedCourseData>(
                  future: _getData(force: false),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Future.microtask(
                        () => setState(() {
                          _hasCategories = snapshot.data.hasCategories;
                        }),
                      );
                      if (snapshot.data.grades.isEmpty) {
                        return RefreshableIconMessage(
                          onRefresh: () => _getData(force: true),
                          icon: Icon(
                            FontAwesomeIcons.inbox,
                            size: 55,
                            color: Colors.white,
                          ),
                          child: const Text(
                            "There are no grades listed in this class",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                          ),
                        );
                        //   ],
                        // ));

                      }
                      return CourseGradesMinimalDisplay(
                        snapshot.data.grades,
                        snapshot.data.categoryWeights,
                        snapshot.data.hasCategories
                            ? _currentGroupingMode
                            : GroupingMode.Date,
                        course.courseName,
                      );
                    } else if (snapshot.hasError) {
                      if (snapshot.error is SocketException ||
                          snapshot.error is HttpException ||
                          snapshot.error is HandshakeException ||
                          snapshot.error is OSError) {
                        return RefreshableErrorMessage(
                          onRefresh: () => _getData(),
                          text: "Issue connecting to SIS",
                        );
                      }
                      reportException(
                        exception: snapshot.error,
                        stackTrace: snapshot.stackTrace,
                      );

                      return RefreshableErrorMessage(
                        onRefresh: () => _getData(),
                        text:
                            "An error occured fetching grades:\n\n${snapshot.error}\n\nPull to refresh.\nIf the error persists, restart the app.",
                      );
                    }

                    return Center(child: LoaderWidget());
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
