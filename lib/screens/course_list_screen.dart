import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grades/providers/current_session.dart';
import 'package:grades/sis-cache/sis_loader.dart';
import 'package:grades/utilities/helpers/error.dart';
import 'package:grades/utilities/patches/stacked_future_builder.dart';
import 'package:grades/utilities/refresh_offline_state.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:grades/widgets/class_list_item.dart';
import 'package:grades/widgets/loader_widget.dart';
import 'package:grades/widgets/refreshable/refreshable_error_message.dart';
import 'package:grades/widgets/refreshable/refreshable_icon_message.dart';
import 'package:provider/provider.dart';
import 'package:sis_loader/sis_loader.dart';

class CourseListScreen extends StatefulWidget {
  CourseListScreen({Key key}) : super(key: key);

  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  Future<List<CachedCourse>> _refresh(BuildContext context) async {
    if (Provider.of<CurrentSession>(context, listen: false).isOffline) {
      attemptSwitchToOnline(context);
    }
    var result = await catchFutureHttpError(
      () => Provider.of<CurrentSession>(context, listen: false).courses(),
      onHttpError: () {
        Provider.of<CurrentSession>(context, listen: false)
            .setOfflineStatus(true);
        Provider.of<CurrentSession>(context, listen: false).setSisLoader(null);
      },
    );
    setState(() {});
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return StackedFutureBuilder<List<CachedCourse>>(
      future: Provider.of<CurrentSession>(context).courses(force: false),
      builder: (context, snapshot) {
        var isOffline = Provider.of<CurrentSession>(context).isOffline;
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            if (isOffline) {
              return RefreshableIconMessage(
                onRefresh: () => _refresh(context),
                icon: Icon(
                  FontAwesomeIcons.inbox,
                  size: 55,
                  color: Colors.white,
                ),
                child: const Text(
                  'There are no classes available offline',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                  ),
                ),
              );
            }
          }

          return RefreshIndicator(
            onRefresh: () => _refresh(context),
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                var course = snapshot.data[index];
                return ClassListItem(
                  onTap: () {
                    Navigator.pushNamed(context, '/course_grades',
                        arguments: course);
                  },
                  course: course.courseName,
                  letterGrade: course.gradeLetter,
                  teacher: course.teacherName,
                  percent: course.gradePercent,
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          if (isHttpError(snapshot.error)) {
            return RefreshableErrorMessage(
              onRefresh: () => _refresh(context),
              text: 'Issue connecting to SIS',
            );
          }

          if (snapshot.error is UnknownReauthenticationException) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 66,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'You have been logged out',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 19,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 25),
                  RaisedButton(
                    onPressed: () async {
                      await Navigator.popUntil(
                          context, ModalRoute.withName('/'));
                    },
                    child: Text('Reload'),
                  ),
                  // Padding to push the content up
                  const SizedBox(height: 75),
                ],
              ),
            );
          }

          reportException(
            exception: snapshot.error,
            stackTrace: snapshot.stackTrace,
          );

          // TODO: Find the root cause of this
          if (snapshot.error is NoSuchMethodError ||
              snapshot.error is UnknownStructureException) {
            return RefreshableErrorMessage(
              onRefresh: () => _refresh(context),
              text: 'There was an unknown error.\nYou may need to log out.',
            );
          }

          return RefreshableErrorMessage(
            onRefresh: () => _refresh(context),
            text:
                'An error occured loading courses:\n\n${snapshot.error}\n\nPull to refresh.\nIf the error persists, restart the app.',
          );
        }
        return Center(
          child: LoaderWidget(),
        );
      },
    );
  }
}
