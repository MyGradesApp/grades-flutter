import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/utilities/status.dart';
import 'package:grades/utilities/update.dart';
import 'package:grades/widgets/class_list_item.dart';
import 'package:grades/widgets/loading_indicator.dart';
import 'package:grades/widgets/refreshable/fullscreen_error_message.dart';
import 'package:grades/widgets/refreshable/fullscreen_simple_icon_message.dart';

import '../settings_screen.dart';

class CourseListPage extends StatefulWidget {
  @override
  _CourseListPageState createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  Completer<void> _refreshCompleter = Completer();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        BlocProvider.of<CourseListBloc>(context).add(RefreshCourseList());
        return _refreshCompleter.future;
      },
      child: BlocConsumer<CourseListBloc, CourseListState>(
        listener: (context, CourseListState state) {
          if (state is CourseListLoaded || state is CourseListError) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
        },
        builder: (context, state) {
          if (state is CourseListLoading) {
            return Center(child: LoadingIndicator());
          }
          if (state is CourseListLoaded) {
            if (state.data == null) {
              return FullscreenSimpleIconMessage(
                icon: FontAwesomeIcons.solidFolderOpen,
                text: 'No courses available offline',
              );
            }
            if (state.data.isEmpty) {
              return FullscreenSimpleIconMessage(
                icon: FontAwesomeIcons.solidFolderOpen,
                text: 'No courses',
              );
            }
            return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, i) {
                var course = state.data[i];
                if (i == 0) {
                  return Column(children: [
                    getUpdateCard(),
                    FutureBuilder(
                        future: getStatus(),
                        builder: (context, state) {
                          if (state.data != null && state.hasData) {
                            if (state.data.message.toString().isNotEmpty) {
                              return getStatusCard(
                                  state.data.message.toString());
                            }
                          }
                          return Container();
                        }),
                    ClassListItem(
                      course: course.courseName,
                      letterGrade: course.gradeLetter,
                      percent: course.gradePercent,
                      teacher: course.teacherName,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/course_grades',
                          arguments: course,
                        );
                      },
                    )
                  ]);
                }
                return ClassListItem(
                  course: course.courseName,
                  letterGrade: course.gradeLetter,
                  percent: course.gradePercent,
                  teacher: course.teacherName,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/course_grades',
                      arguments: course,
                    );
                  },
                );
              },
            );
          }
          if (state is CourseListError) {
            if (state.error is SISRepoReauthFailure) {
              reportException(
                exception: state.error,
                stackTrace: state.stackTrace,
              );
              return FullscreenErrorMessage(
                  text:
                      'Your session has expired and we couldn\'t log you back in.\n');
            }
            return FullscreenErrorMessage(
              text: 'There was an unknown error',
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget getUpdateCard() {
    return FutureBuilder<bool>(
      future: checkUpdateAvailable(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data && Platform.isIOS) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Color.fromARGB(255, 211, 117, 116),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                onPressed: () {
                  launchAppstorePage();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, top: 26, bottom: 26),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(children: [
                      const Expanded(
                        child: Text(
                          'Update Available',
                          style: HEADER_TEXT_STYLE,
                        ),
                      ),
                      const Text(
                        'Click to update now',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
