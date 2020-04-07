import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grades/blocs/course_list/course_list_bloc.dart';
import 'package:grades/blocs/network_action_bloc/network_action_bloc.dart';
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
        listener: (BuildContext context, NetworkActionState state) {
          if (state is NetworkLoaded) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
        },
        builder: (context, state) {
          if (state is NetworkLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is NetworkLoaded<List<Course>>) {
            return ListView.builder(
              itemCount: state.data.length,
              itemBuilder: (context, i) {
                var course = state.data[i];
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
            );
          }
          if (state is NetworkError) {
            return RefreshIndicator(
              onRefresh: () {
                BlocProvider.of<CourseListBloc>(context)
                    .add(RefreshNetworkData());
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
      ),
    );
  }
}
