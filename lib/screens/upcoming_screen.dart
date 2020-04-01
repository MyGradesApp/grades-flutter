import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grades/providers/current_session.dart';
import 'package:grades/sis-cache/sis_loader.dart';
import 'package:grades/utilities/helpers/date.dart';
import 'package:grades/utilities/helpers/error.dart';
import 'package:grades/utilities/refresh_offline_state.dart';
import 'package:grades/widgets/refreshable/refreshable_icon_message.dart';
import 'package:grades/widgets/upcoming_grade_item.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';
import 'package:sis_loader/sis_loader.dart';
import 'package:tuple/tuple.dart';

class UpcomingScreen extends StatefulWidget {
  UpcomingScreen({Key key}) : super(key: key);

  @override
  _UpcomingScreenState createState() => _UpcomingScreenState();
}

// TODO: Error handling
class _UpcomingScreenState extends State<UpcomingScreen>
    with AutomaticKeepAliveClientMixin<UpcomingScreen> {
  final Map<String, List<Grade>> _courseGrades = {};
  List<CachedCourse> _courses;
  bool _isLoading = true;
  int _numLoaded = 0;

  @override
  void initState() {
    super.initState();
    _refresh(force: false);
  }

  Future<void> _refresh({bool force = true}) async {
    if (Provider.of<CurrentSession>(context, listen: false).isOffline) {
      attemptSwitchToOnline(context);
    }
    _numLoaded = 0;
    setState(() {
      _isLoading = true;
    });
    _courses = await Provider.of<CurrentSession>(context, listen: false)
        .courses(force: force);
    // Update for _courses future
    setState(() {
      if (_courses.isEmpty) {
        _isLoading = false;
      }
    });
    var totalToLoad = _courses.length;

    // TODO: Switch to stream?
    unawaited(catchFutureHttpError(
      () => Future.wait(_courses.map((course) async {
        var grades = await course.getGrades(force: force);
        if (!mounted) {
          return;
        }
        setState(() {
          _courseGrades[course.courseName] = grades;
          _numLoaded += 1;
          if (_numLoaded == totalToLoad) {
            setState(() {
              _isLoading = false;
            });
          }
        });
      }), eagerError: true),
      onHttpError: () {
        _numLoaded += 1;
        if (_numLoaded == totalToLoad) {
          setState(() {
            _isLoading = false;
          });
        }
        Provider.of<CurrentSession>(context, listen: false)
            .setOfflineStatus(true);
        Provider.of<CurrentSession>(context, listen: false).setSisLoader(null);
      },
    ));

    return null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // TODO: Lift this restriction
    if (Provider.of<CurrentSession>(context, listen: false).isOffline) {
      return RefreshableIconMessage(
        onRefresh: _refresh,
        icon: Icon(
          Icons.signal_cellular_connected_no_internet_4_bar,
          color: Colors.white,
          size: 55,
        ),
        text: 'Upcoming grades are not available offline',
      );
    }

    var courses = _courseGrades;

    var out = <DateGrouping, List<Tuple2<String, Grade>>>{};

    courses.forEach((courseName, grades) {
      grades.where((item) => item.dueDate != null).toList()
        ..sort((grade, otherGrade) {
          return grade.dueDate.compareTo(otherGrade.dueDate);
        })
        ..forEach((grade) {
          if (grade.dueDate != null) {
            var n = DateTime.now();
            var now = DateTime(n.year, n.month, n.day)
                .subtract(const Duration(seconds: 1));
            if (grade.dueDate.isAfter(now)) {
              var dateGrouping = DateGroupingExt.fromDate(grade.dueDate);
              // We assume any "upcoming" grade will be "Not Graded"
              if (grade.grade == 'Not Graded') {
                if (out[dateGrouping] == null) {
                  out[dateGrouping] = [];
                }
                out[dateGrouping].add(Tuple2(courseName, grade));
              }
            }
          }
        });
    });

    if (out.isEmpty && !_isLoading) {
      return RefreshableIconMessage(
        onRefresh: _refresh,
        icon: Icon(
          FontAwesomeIcons.inbox,
          size: 55,
          color: Colors.white,
        ),
        child: const Text(
          'No new grades available',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.0,
          ),
        ),
      );
    } else if (out.isEmpty && _isLoading) {
      return RefreshIndicator(
        onRefresh: _refresh,
        child: _buildLoader(),
      );
    }

    var listChildren = <Widget>[];

    // Iterate over _courses to keep the original order
    DateGrouping.values.forEach((dateGrouping) {
      var grades = (out[dateGrouping] ?? []);
      // Header
      listChildren.add(
        Padding(
          padding: const EdgeInsets.only(left: 11.0),
          child: Text(
            dateGrouping.toHumanFormat(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

      // Show 10 most recent
      const maxItems = 10;
      var endIndex = min(maxItems, grades.length);
      List<Grade> clipped;
      if (grades.length > maxItems) {
        clipped = grades.map((e) => e.item2).toList().sublist(endIndex);
      }

      listChildren.addAll(
        grades.sublist(0, endIndex).map((entry) => UpcomingGradeItem(
            entry.item2,
            Theme.of(context).primaryColorLight,
            Theme.of(context).cardColor,
            false,
            entry.item1)),
      );
      // Show indicator if we clipped some grades
      if (clipped != null) {
        listChildren.add(
          Padding(
            padding: const EdgeInsets.only(right: 11.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Container()),
                Text(
                  'and ${clipped.length} more',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Trailing padding for the next header
      listChildren.add(const SizedBox(height: 3));
    });

    if (_isLoading) {
      listChildren.add(_buildLoader());
    }

    return RefreshIndicator(
      onRefresh: () {
        return _refresh(force: true);
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ListView(
          children: listChildren,
          shrinkWrap: true,
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 12),
        const SpinKitThreeBounce(
          color: Colors.white,
          size: 30,
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
