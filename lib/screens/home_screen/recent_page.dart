import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grades/blocs/feed/feed_event.dart';
import 'package:grades/blocs/feed/recent/recent_bloc.dart';
import 'package:grades/screens/home_screen/widgets/grades_section.dart';

class RecentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentBloc, RecentState>(
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
              Center(child: CircularProgressIndicator()),
            ],
          );
        }

        if (state is RecentLoaded) {
          var courses = state.courses.entries.toList();
          return RefreshIndicator(
            onRefresh: () {
              BlocProvider.of<RecentBloc>(context).add(RefreshData());
              return Future.value();
            },
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: courses.length,
              itemBuilder: (context, i) {
                return CourseGrades(
                  courses[i].key.courseName,
                  courses[i].value,
                );
              },
            ),
          );
        }

        if (state is RecentError) {
          return Text('An error occurred');
        }
        return Container(color: Colors.blue);
      },
    );
  }
}
