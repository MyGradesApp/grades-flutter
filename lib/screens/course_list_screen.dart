import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grades/models/current_session.dart';
import 'package:grades/sis-cache/sis_loader.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:grades/utilities/stacked_future_builder.dart';
import 'package:grades/widgets/class_list_item_widget.dart';
import 'package:grades/widgets/loader_widget.dart';
import 'package:grades/widgets/refreshable_error_message.dart';
import 'package:provider/provider.dart';
import 'package:sis_loader/sis_loader.dart';

class CourseListScreen extends StatelessWidget {
  const CourseListScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: StackedFutureBuilder<List<CachedCourse>>(
        future: Provider.of<CurrentSession>(context).courses(force: false),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () =>
                  Provider.of<CurrentSession>(context, listen: false).courses(),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var course = snapshot.data[index];
                  return ClassListItemWidget(
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
            if (snapshot.error is SocketException ||
                snapshot.error is HttpException ||
                snapshot.error is HandshakeException ||
                snapshot.error is OSError) {
              return RefreshableErrorMessage(
                onRefresh: () =>
                    Provider.of<CurrentSession>(context, listen: false)
                        .courses(),
                text: "Issue connecting to SIS",
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
                onRefresh: () =>
                    Provider.of<CurrentSession>(context, listen: false)
                        .courses(),
                text: "There was an unknown error.\nYou may need to log out.",
              );
            }

            return RefreshableErrorMessage(
              onRefresh: () =>
                  Provider.of<CurrentSession>(context, listen: false).courses(),
              text:
                  "An error occured loading courses:\n\n${snapshot.error}\n\nPull to refresh.\nIf the error persists, restart the app.",
            );
          }
          return Center(
            child: LoaderWidget(),
          );
        },
      ),
    );
  }
}
