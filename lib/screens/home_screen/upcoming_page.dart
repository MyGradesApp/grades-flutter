import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';

import 'widgets/course_grades.dart';

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

            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: <Widget>[
                  for (var group in groupsList)
                    CourseGrades(
                      group.item1.toHumanFormat(),
                      group.item2,
                    ),
                  if (firstLoad) Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          }

          if (state is UpcomingLoaded) {
            var groupsList = state.sortedGroups();
            if (groupsList.isNotEmpty) {
              return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: groupsList.length,
                itemBuilder: (context, i) {
                  return CourseGrades(
                    groupsList[i].item1.toHumanFormat(),
                    groupsList[i].item2,
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
          if (state is UpcomingError) {
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
