import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade_core/grade_core.dart';
import 'package:grades/widgets/loading_indicator.dart';
import 'package:grades/widgets/refreshable/fullscreen_error_message.dart';

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
            if (state is NetworkLoaded || state is NetworkActionError) {
              _refreshCompleter?.complete();
              _refreshCompleter = Completer();
            }
          },
          builder: (context, NetworkActionState state) {
            if (state is NetworkLoading) {
              return Center(child: LoadingIndicator());
            }
            if (state is NetworkLoaded<AcademicInfo>) {
              if (state.data == null) {
                return SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Center(child: Text('No data available offline')),
                );
              }
              var profile = state.data.profile;
              var absences = state.data.absences;
              return SizedBox.expand(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      _buildCard(
                        'Cumulative GPA:',
                        profile.cumulative_gpa.toString(),
                      ),
                      _buildCard(
                        'Weighted GPA:',
                        profile.cumulative_weighted_gpa.toString(),
                      ),
                      if (profile.class_rank_numerator != null &&
                          profile.class_rank_denominator != null)
                        _buildCard(
                          'Class Rank:',
                          '${profile.class_rank_numerator} / ${profile.class_rank_denominator}',
                        ),
                      _buildCard(
                        'Absences:',
                        '${absences.days} days in ${absences.periods} periods',
                      )
                    ],
                  ),
                ),
              );
            }
            if (state is NetworkActionError) {
              return FullscreenErrorMessage(
                text: 'There was an unknown error',
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildCard(String title, String body) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: const Color(0xff226baa),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            body,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
