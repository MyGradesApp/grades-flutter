import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/widgets/class_list_item.dart';
import 'package:grades/widgets/loading_indicator.dart';
import 'package:grades/widgets/refreshable/fullscreen_error_message.dart';
import 'package:grades/widgets/refreshable/fullscreen_simple_icon_message.dart';
import 'package:sis_loader/sis_loader.dart';

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
        BlocProvider.of<CourseListBloc>(context).add(RefreshNetworkData());
        return _refreshCompleter.future;
      },
      child: BlocConsumer<CourseListBloc, NetworkActionState>(
        listener: (context, NetworkActionState state) {
          if (state is NetworkLoaded || state is NetworkActionError) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
        },
        builder: (context, state) {
          if (state is NetworkLoading) {
            return Center(child: LoadingIndicator());
          }
          if (state is NetworkLoaded<List<Course>>) {
            if (state.data == null) {
              return FullscreenSimpleIconMessage(
                icon: FontAwesomeIcons.inbox,
                text: 'No courses available offline',
              );
            }
            if (state.data.isEmpty) {
              return FullscreenSimpleIconMessage(
                icon: FontAwesomeIcons.inbox,
                text: 'No courses',
              );
            }
            return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, i) {
                var course = state.data[i];
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
          if (state is NetworkActionError) {
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
