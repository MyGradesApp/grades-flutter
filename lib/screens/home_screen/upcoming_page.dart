import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grades/blocs/feed/feed_event.dart';
import 'package:grades/blocs/feed/upcoming/upcoming_bloc.dart';
import 'package:grades/screens/home_screen/widgets/grades_section.dart';
import 'package:grades/utilties/date.dart';

class UpcomingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpcomingBloc, UpcomingState>(
      builder: (context, state) {
        if (state is UpcomingLoading) {
          var groupsList = state.sortedGroups();

          return Column(
            children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: groupsList.length,
                itemBuilder: (context, i) {
                  return CourseGrades(
                    groupsList[i].item1.toHumanFormat(),
                    groupsList[i].item2,
                  );
                },
              ),
              Center(child: CircularProgressIndicator()),
            ],
          );
        }

        if (state is UpcomingLoaded) {
          var groupsList = state.sortedGroups();
          return RefreshIndicator(
            onRefresh: () {
              BlocProvider.of<UpcomingBloc>(context).add(RefreshData());
              return Future.value();
            },
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: groupsList.length,
              itemBuilder: (context, i) {
                return CourseGrades(
                  groupsList[i].item1.toHumanFormat(),
                  groupsList[i].item2,
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
