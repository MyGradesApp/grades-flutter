import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/screens/home_screen/widgets/upcoming_grade_item.dart';
import 'package:grades/widgets/loading_indicator.dart';
import 'package:grades/widgets/refreshable/fullscreen_error_message.dart';
import 'package:grades/widgets/refreshable/fullscreen_simple_icon_message.dart';

import '../../widgets/headered_group.dart';

class UpcomingPage extends StatefulWidget {
  @override
  _UpcomingPageState createState() => _UpcomingPageState();
}

class _UpcomingPageState extends State<UpcomingPage>
    with AutomaticKeepAliveClientMixin<UpcomingPage> {
  Completer<void> _refreshCompleter = Completer<void>();
  bool firstLoad = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () {
        BlocProvider.of<UpcomingBloc>(context).add(RefreshData());
        return _refreshCompleter.future;
      },
      child: BlocConsumer<UpcomingBloc, UpcomingState>(
        listener: (context, state) {
          if (state is UpcomingLoaded || state is UpcomingError) {
            firstLoad = false;
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
        },
        builder: (context, state) {
          if (state is UpcomingLoading) {
            var groupsList = state.sortedGroups();

            return ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                for (var group in groupsList)
                  HeaderedGroup(
                    title: group.item1.toHumanFormat(),
                    children: group.item2,
                    maxCount: 10,
                    builder: (CourseGrade item) {
                      return UpcomingGradeItem(
                        courseName: item.course.courseName,
                        grade: item.grade,
                      );
                    },
                  ),
                if (firstLoad)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(child: LoadingIndicator()),
                  ),
              ],
            );
          }

          if (state is UpcomingLoaded) {
            var groupsList = state.sortedGroups();
            if (groupsList != null && groupsList.isNotEmpty) {
              return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: groupsList.length,
                itemBuilder: (context, i) {
                  return HeaderedGroup(
                    title: groupsList[i].item1.toHumanFormat(),
                    children: groupsList[i].item2,
                    maxCount: 10,
                    builder: (CourseGrade item) {
                      return UpcomingGradeItem(
                        courseName: item.course.courseName,
                        grade: item.grade,
                      );
                    },
                  );
                },
              );
            } else {
              return FullscreenSimpleIconMessage(
                icon: FontAwesomeIcons.solidFolderOpen,
                text: 'No upcoming grades',
              );
            }
          }
          if (state is UpcomingError) {
            return FullscreenErrorMessage(
              text: 'There was an unknown error',
            );
          }
          return Container();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
