import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grades/models/current_session.dart';
import 'package:grades/models/data_persistence.dart';
import 'package:grades/sis-cache/sis_loader.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:grades/utilities/stacked_future_builder.dart';
import 'package:grades/widgets/class_list_item_widget.dart';
import 'package:grades/widgets/loader_widget.dart';
import 'package:grades/widgets/refreshable_error_message.dart';
import 'package:grades/widgets/refreshable_icon_message.dart';
import 'package:provider/provider.dart';
import 'package:sis_loader/sis_loader.dart';

class CourseListScreen extends StatefulWidget {
  CourseListScreen({Key key}) : super(key: key);

  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  Future<List<CachedCourse>> _refresh(BuildContext context) {
    // Trigger ui update
    setState(() {});
    return Provider.of<CurrentSession>(context, listen: false).courses();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: StackedFutureBuilder<List<CachedCourse>>(
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
                    "There are no classes available offline",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                    ),
                  ),
                );
              }
            }

            if (!isOffline) {
              Future.microtask(() {
                // Update persisted courses
                Provider.of<DataPersistence>(context, listen: false)
                    .setCourses(snapshot.data);
              });
            }

            return RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var course = snapshot.data[index];
                  return ClassListItemWidget(
                    onTap: () {
                      Navigator.pushNamed(context, '/course_grades',
                          arguments: course);
                    },
                  ),
                ),
              ],
            ));
          } else if (snapshot.hasError) {
            if (snapshot.error is SocketException ||
                snapshot.error is HttpException ||
                snapshot.error is HandshakeException ||
                snapshot.error is OSError) {
              return RefreshableErrorMessage(
                onRefresh: () => _refresh(context),
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
                onRefresh: () => _refresh(context),
                text: "There was an unknown error.\nYou may need to log out.",
              );
            }

            return RefreshableErrorMessage(
              onRefresh: () => _refresh(context),
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
