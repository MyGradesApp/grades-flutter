import 'dart:async';
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
                    buildUpdateCardWidget(),
                    buildStatusCardWidget(),
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
}
