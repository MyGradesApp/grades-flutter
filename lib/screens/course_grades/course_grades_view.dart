import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grades/blocs/course_grades/course_grades_bloc.dart';
import 'package:grades/blocs/network_action_bloc/network_action_bloc.dart';
import 'package:sis_loader/sis_loader.dart';

class CourseGradesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseGradesBloc, NetworkActionState>(
      builder: (BuildContext context, state) {
        if (state is NetworkLoading) {
          return CircularProgressIndicator();
        }
        if (state is NetworkError) {
          return Text('An error occured');
        }
        if (state is NetworkLoaded<List<Grade>>) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.data.length,
            itemBuilder: (context, i) {
              var grade = state.data[i];
              return RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/grade_info', arguments: grade);
                },
                child: Row(
                  children: <Widget>[
                    Expanded(child: Text(grade.name)),
                    Text(grade.grade)
                  ],
                ),
              );
            },
          );
        }
        return Container();
      },
    );
  }
}
