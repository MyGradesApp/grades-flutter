import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grades/blocs/course_list/course_list_bloc.dart';

class CourseListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseListBloc, CourseListState>(
      builder: (context, state) {
        if (state is CourseListLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is CourseListLoaded) {
          return RefreshIndicator(
            onRefresh: () {
              // TODO: Future this up
              BlocProvider.of<CourseListBloc>(context).add(RefreshCourses());
              return Future.value();
            },
            child: ListView.builder(
              itemCount: state.courses.length,
              itemBuilder: (context, i) {
                var course = state.courses[i];
                return RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/course_grades',
                      arguments: course,
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text(course.courseName)),
                      Text(course.gradePercent.toString()),
                    ],
                  ),
                );
              },
            ),
          );
        }
        if (state is CourseListError) {
          return RefreshIndicator(
            onRefresh: () {
              BlocProvider.of<CourseListBloc>(context).add(RefreshCourses());
              return Future.value();
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Center(child: Text('An error occurred')),
            ),
          );
        }
        return Container();
      },
    );
  }
}
