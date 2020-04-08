import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/screens/home_screen/widgets/grades_section.dart';

class RecentPage extends StatefulWidget {
  @override
  _RecentPageState createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage>
    with AutomaticKeepAliveClientMixin<RecentPage> {
  Completer<void> _refreshCompleter = Completer<void>();
  bool firstLoad = true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () {
        BlocProvider.of<RecentBloc>(context).add(RefreshData());
        return _refreshCompleter.future;
      },
      child: BlocConsumer<RecentBloc, RecentState>(
        listener: (context, state) {
          if (state is RecentLoaded || state is RecentError) {
            firstLoad = false;
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
        },
        builder: (context, state) {
          if (state is RecentLoading) {
            var courses = state.partialCourses.entries.toList();
            return Column(
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: courses.length,
                  itemBuilder: (context, i) {
                    return CourseGrades(
                      courses[i].key.courseName,
                      courses[i].value,
                    );
                  },
                ),
                if (firstLoad) Center(child: CircularProgressIndicator()),
              ],
            );
          }

          if (state is RecentLoaded) {
            var courses = state.courses.entries.toList();
            return ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: courses.length,
              itemBuilder: (context, i) {
                return CourseGrades(
                  courses[i].key.courseName,
                  courses[i].value,
                );
              },
            );
          }
          if (state is RecentError) {
            return Text('An error occurred');
          }
          return Container();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}