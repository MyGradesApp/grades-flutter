import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grades/blocs/course_grades/course_grades_bloc.dart';

class CourseGradesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseGradesBloc, CourseGradesState>(
      builder: (BuildContext context, state) {
        if (state is CourseGradesLoading) {
          return CircularProgressIndicator();
        }
        if (state is CourseGradesError) {
          return Text('An error occured');
        }
        if (state is CourseGradesLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.grades.length,
            itemBuilder: (context, i) {
              var grade = state.grades[i];
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
