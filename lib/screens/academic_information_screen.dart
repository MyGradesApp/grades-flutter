import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grades/models/current_session.dart';
import 'package:grades/utilities/sentry.dart';
import 'package:grades/utilities/stacked_future_builder.dart';
import 'package:grades/widgets/loader_widget.dart';
import 'package:grades/widgets/refreshable_error_message.dart';
import 'package:provider/provider.dart';
import 'package:sis_loader/sis_loader.dart';

class _Info {
  final Profile profile;
  final Absences absences;

  _Info(this.profile, this.absences);
}

class AcademicInfoScreen extends StatefulWidget {
  @override
  _AcademicInfoScreenState createState() => _AcademicInfoScreenState();
}

class _AcademicInfoScreenState extends State<AcademicInfoScreen> {
  Future<_Info> _refresh([bool force = true]) async {
    var sisLoader =
        Provider.of<CurrentSession>(context, listen: false).sisLoader;

    var profile = await sisLoader.getUserProfile(force: force);
    var absences = await sisLoader.getAbsences(force: force);

    return _Info(profile, absences);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text('Academic Information'),
        leading: IconButton(
          tooltip: 'Back',
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: StackedFutureBuilder<_Info>(
          future: _refresh(false),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var profile = snapshot.data.profile;
              var absences = snapshot.data.absences;
              return RefreshIndicator(
                onRefresh: _refresh,
                child: SizedBox.expand(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        _buildCard(
                            'Cumulative GPA',
                            profile.cumulative_gpa?.toString() ??
                                "Unavailable"),
                        _buildCard(
                            'Cumulative Weighted GPA',
                            profile.cumulative_weighted_gpa?.toString() ??
                                "Unavailable"),
                        if (profile.class_rank_numerator != null &&
                            profile.class_rank_denominator != null)
                          _buildCard(
                            'Class Rank',
                            '${profile.class_rank_numerator} / ${profile.class_rank_denominator}',
                          ),
                        _buildCard(
                          'Absences',
                          '${absences.days} days in ${absences.periods} periods',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              if (snapshot.error is SocketException ||
                  snapshot.error is HttpException ||
                  snapshot.error is HandshakeException ||
                  snapshot.error is OSError) {
                return RefreshableErrorMessage(
                  onRefresh: _refresh,
                  text: "Issue connecting to SIS",
                );
              }
              reportException(
                exception: snapshot.error,
                stackTrace: snapshot.stackTrace,
              );

              if (snapshot.error is UnknownMissingCookieException) {
                return RefreshableErrorMessage(
                  onRefresh: _refresh,
                  text: "Issue loading information",
                );
              }

              return RefreshableErrorMessage(
                onRefresh: _refresh,
                text:
                    'An error occured fetching information:\n\n${snapshot.error}\n\nPull to refresh.\nIf the error persists, restart the app.',
              );
            }

            // return const Center(child: CircularProgressIndicator());
            return Center(child: LoaderWidget());
          }),
    );
  }

  Widget _buildCard(String title, String body) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Theme.of(context).accentColor,
      margin: const EdgeInsets.all(10),
      child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              body,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          )),
    );
  }
}
