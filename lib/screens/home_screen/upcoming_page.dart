import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grades/blocs/upcoming/upcoming_bloc.dart';
import 'package:sis_loader/sis_loader.dart';

class UpcomingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpcomingBloc, UpcomingState>(
      builder: (context, state) {
        if (state is UpcomingLoading) {
          var courses = state.partialCourses.entries.toList();
          return Column(
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: courses.length,
                itemBuilder: (context, i) {
                  return _CourseGrades(
                    courses[i].key.courseName,
                    courses[i].value,
                  );
                },
              ),
              Center(child: CircularProgressIndicator()),
            ],
          );
        }

        if (state is UpcomingLoaded) {
          var courses = state.courses.entries.toList();
          return RefreshIndicator(
            onRefresh: () {
              BlocProvider.of<UpcomingBloc>(context).add(RefreshData());
              return Future.value();
            },
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: courses.length,
              itemBuilder: (context, i) {
                return _CourseGrades(
                  courses[i].key.courseName,
                  courses[i].value,
                );
              },
            ),
          );
        }

        if (state is UpcomingError) {
          return Text('An error occurred');
        }
        return Container(color: Colors.blue);
      },
    );
  }
}

class _CourseGrades extends StatelessWidget {
  final String courseName;
  final List<Grade> grades;

  _CourseGrades(this.courseName, this.grades);

  @override
  Widget build(BuildContext context) {
    if (grades.isNotEmpty) {
      return Column(
        children: <Widget>[
          Text(courseName),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: grades.length,
            itemBuilder: (context, i) {
              return Text(grades[i].name);
            },
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
