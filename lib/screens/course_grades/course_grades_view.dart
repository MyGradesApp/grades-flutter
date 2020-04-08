import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';
import 'package:sis_loader/sis_loader.dart';

class CourseGradesView extends StatefulWidget {
  @override
  _CourseGradesViewState createState() => _CourseGradesViewState();
}

class _CourseGradesViewState extends State<CourseGradesView> {
  Completer<void> _refreshCompleter = Completer<void>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        BlocProvider.of<CourseGradesBloc>(context).add(RefreshNetworkData());
        return _refreshCompleter.future;
      },
      child: BlocConsumer<CourseGradesBloc, NetworkActionState>(
        listener: (context, state) {
          if (state is NetworkLoaded || state is NetworkError) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          }
        },
        builder: (context, state) {
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
                    Navigator.pushNamed(context, '/grade_info',
                        arguments: grade);
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
      ),
    );
  }
}
