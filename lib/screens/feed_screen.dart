import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grades/models/current_session.dart';
import 'package:grades/models/grade_persistence.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:grades/utilities/stacked_future_builder.dart';
import 'package:grades/widgets/course_grades_display.dart';
import 'package:grades/widgets/loader_widget.dart';
import 'package:grades/widgets/refreshable_error_message.dart';
import 'package:grades/widgets/refreshable_icon_message.dart';
import 'package:provider/provider.dart';
import 'package:sis_loader/sis_loader.dart';

class FeedScreen extends StatefulWidget {
  FeedScreen({Key key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Future<Map<String, List<Map<String, dynamic>>>> _refresh(
      {bool force = false}) async {
    var courses = await Provider.of<CurrentSession>(context, listen: false)
        .sisLoader
        .getCourses(force: force);

    Map<String, List<Map<String, dynamic>>> out = {};
    await Future.wait(courses.map((course) async {
      var grades = await course.getGrades(force);
      out[course.courseName] = grades;
    }));

    return out;
  }

  @override
  Widget build(BuildContext context) {
    return StackedFutureBuilder<Map<String, List<Map<String, dynamic>>>>(
        future: _refresh(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final courses = snapshot.data;

            Map<String, List<Map<String, dynamic>>> out = {};
            courses.forEach((courseName, grades) {
              var oldGrades =
                  Provider.of<GradePersistence>(context, listen: false)
                      .getOriginalData(courseName);

              grades.forEach((grade) {
                var isNewGrade = !oldGrades.any((oldGrade) =>
                    oldGrade["Assignment"] == grade["Assignment"]);
                if (isNewGrade) {
                  if (out[courseName] == null) {
                    out[courseName] = [];
                  }
                  out[courseName].add(grade);
                }
              });
            });

            if (out.isEmpty) {
              return RefreshableIconMessage(
                onRefresh: () => _refresh(force: true),
                icon: Icon(
                  FontAwesomeIcons.inbox,
                  size: 55,
                  color: Colors.white,
                ),
                child: const Text(
                  "There are no new grades",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                  ),
                ),
              );
            }

            out.forEach((key, value) {
              print(key);
              value.forEach((e) => print('- ${e["Assignment"]}'));
            });

            List<Widget> listChildren = [];
            out.forEach((courseName, grades) {
              // Header
              listChildren.add(
                Padding(
                  padding: const EdgeInsets.only(left: 11.0),
                  child: Text(
                    courseName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );

              // Only show 4 most recent
              const maxItems = 3;
              int endIndex = min(maxItems, grades.length);
              List<Map<String, dynamic>> clipped;
              if (grades.length > maxItems) {
                clipped = grades.sublist(endIndex);
              }

              listChildren.addAll(
                grades.sublist(0, endIndex).map((grade) => buildGradeItemCard(
                    context,
                    grade,
                    Theme.of(context).primaryColorLight,
                    Theme.of(context).cardColor,
                    false)),
              );
              if (clipped != null) {
                listChildren.add(
                  Padding(
                    padding: const EdgeInsets.only(right: 11.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(child: Container()),
                        Text(
                          "and ${clipped.length} more",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // Trailing padding for the next header
              listChildren.add(const SizedBox(height: 3));
            });

            return ListView(children: listChildren);
          }
          if (snapshot.hasError) {
            // This path is untested
            reportException(
              exception: snapshot.error,
              stackTrace: snapshot.stackTrace,
            );

            return RefreshableErrorMessage(
              onRefresh: () => _refresh(force: true),
              text: "An error occured fetching new grades",
            );
          }
          return LoaderWidget();
        });
  }
}
