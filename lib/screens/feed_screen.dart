import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grades/models/current_session.dart';
import 'package:grades/models/grade_persistence.dart';
import 'package:grades/sis-cache/sis_loader.dart';
import 'package:grades/widgets/course_grades_display.dart';
import 'package:grades/widgets/refreshable_icon_message.dart';
import 'package:pedantic/pedantic.dart';
import 'package:provider/provider.dart';
import 'package:sis_loader/src/course.dart';

class FeedScreen extends StatefulWidget {
  FeedScreen({Key key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

// TODO: Error handling
class _FeedScreenState extends State<FeedScreen> {
  Map<String, List<Map<String, dynamic>>> _courseGrades = {};
  List<CachedCourse> _courses;
  bool _isLoading = true;
  int _numLoaded = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refresh();
  }

  Future<void> _refresh({bool force = false}) async {
    setState(() {
      _isLoading = true;
    });
    _numLoaded = 0;
    _courses = await Provider.of<CurrentSession>(context, listen: false)
        .courses(force: force);
    var totalToLoad = _courses.length;

    // TODO: Switch to stream?
    unawaited(Future.wait(_courses.map((course) async {
      var grades = await course.getGrades(force);
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
    })));

    return null;
  }

  @override
  Widget build(BuildContext context) {
    var courses = _courseGrades;

    Map<String, List<Map<String, dynamic>>> out = {};

    courses.forEach((courseName, grades) {
      var oldGrades = Provider.of<GradePersistence>(
        context,
      ).getData(courseName);

      grades.forEach((grade) {
        if (grade["Grade"] != "Not Graded") {
          var isNewGrade = !oldGrades
              .any((oldGrade) => oldGrade["Assignment"] == grade["Assignment"]);

          bool gradeIsRecent;
          if (grade["Date Last Modified"] != null &&
              grade["Date Last Modified"] is DateTime) {
            var gradeDate = grade["Date Last Modified"] as DateTime;
            gradeIsRecent = gradeDate
                .isAfter(DateTime.now().subtract(const Duration(days: 1)));
          } else {
            gradeIsRecent = false;
          }

          if (isNewGrade || gradeIsRecent) {
            if (out[courseName] == null) {
              out[courseName] = [];
            }
            out[courseName].add(grade);
          }
        }
      });
    });

    if (out.isEmpty && !_isLoading) {
      return RefreshableIconMessage(
        onRefresh: () => _refresh(force: true),
        icon: Icon(
          FontAwesomeIcons.inbox,
          size: 55,
          color: Colors.white,
        ),
        child: const Text(
          "No new grades available",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17.0,
          ),
        ),
      );
    } else if (out.isEmpty && _isLoading) {
      return _buildLoader();
    }

    List<Widget> listChildren = [];

    // Iterate over _courses to keep the original order
    _courses
        .where((course) => out.containsKey(course.courseName))
        .forEach((course) {
      var courseName = course.courseName;
      var grades = out[courseName] ?? [];
      // Header
      listChildren.add(
        Padding(
          padding: const EdgeInsets.only(left: 11.0),
          child: Text(
            courseName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

      // Only show 4 most recent
      const maxItems = 4;
      int endIndex = min(maxItems, grades.length);
      List<Map<String, dynamic>> clipped;
      if (grades.length > maxItems) {
        clipped = grades.sublist(endIndex);
      }

      listChildren.addAll(
        grades.sublist(0, endIndex).map((grade) => buildGradeItemCard(
            context,
            grade,
            Theme.of(context).primaryColorLight,
            Theme.of(context).cardColor,
            false)),
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
                  "and ${clipped.length} more",
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
      child: ListView(
        children: listChildren,
        shrinkWrap: true,
      ),
    );
  }

  Widget _buildLoader() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 12),
        SpinKitThreeBounce(
          color: Colors.white,
          size: 30,
        )
      ],
    );
  }
}
