import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';

class AcademicInfoScreen extends StatefulWidget {
  @override
  _AcademicInfoScreenState createState() => _AcademicInfoScreenState();
}

class _AcademicInfoScreenState extends State<AcademicInfoScreen> {
  Completer<void> _refreshCompleter = Completer<void>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Academic Info'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          BlocProvider.of<AcademicInfoBloc>(context).add(RefreshNetworkData());
          return _refreshCompleter.future;
        },
        child: BlocConsumer<AcademicInfoBloc, NetworkActionState>(
          listener: (context, NetworkActionState state) {
            if (state is NetworkLoaded || state is NetworkError) {
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            }
          },
          builder: (context, NetworkActionState state) {
            if (state is NetworkLoading) {
              return CircularProgressIndicator();
            }
            if (state is NetworkLoaded<AcademicInfo>) {
              var profile = state.data.profile;
              var absences = state.data.absences;
              return SizedBox.expand(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      _buildRow(
                        'Cumulative GPA:',
                        profile.cumulative_gpa.toString(),
                      ),
                      _buildRow(
                        'Weighted GPA:',
                        profile.cumulative_weighted_gpa.toString(),
                      ),
                      if (profile.class_rank_numerator != null &&
                          profile.class_rank_denominator != null)
                        _buildRow(
                          'Class Rank:',
                          '${profile.class_rank_numerator} / ${profile.class_rank_denominator}',
                        ),
                      _buildRow(
                        'Absences:',
                        '${absences.days} days in ${absences.periods} periods',
                      )
                    ],
                  ),
                ),
              );
            }
            if (state is NetworkError) {
              return Text('An error occured');
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildRow(String left, String right) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(left),
        ),
        Text(right),
      ],
    );
  }
}
