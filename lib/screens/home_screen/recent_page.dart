import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/widgets/grade_item_card.dart';
import 'package:sis_loader/src/grade.dart';

import 'widgets/course_grades.dart';

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
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  for (var course in courses)
                    HeaderedGroup(
                      course.key.courseName,
                      course.value,
                      _buildGradeItemCard,
                    ),
                  if (firstLoad) Center(child: CircularProgressIndicator())
                ],
              ),
            );
          }

          if (state is RecentLoaded) {
            var courses = state.courses.entries.toList();
            if (courses.isNotEmpty) {
              return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: courses.length,
                itemBuilder: (context, i) {
                  return HeaderedGroup(
                    courses[i].key.courseName,
                    courses[i].value,
                    _buildGradeItemCard,
                  );
                },
              );
            } else {
              return Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Center(
                    child: Text('No recent grades'),
                  ),
                ),
              );
            }
          }
          if (state is RecentError) {
            return Text('An error occurred');
          }
          return Container();
        },
      ),
    );
  }

  GradeItemCard _buildGradeItemCard(Grade grade) {
    return GradeItemCard(
      grade: grade,
      onTap: () {
        Navigator.pushNamed(
          context,
          '/grade_info',
          arguments: grade,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
