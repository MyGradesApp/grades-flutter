import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grades/widgets/course_grades_full_display.dart';
import 'package:grades/widgets/course_grades_minimal_display.dart';
import 'package:grades/widgets/loader_widget.dart';
import 'package:grades/widgets/refreshable_error_message.dart';
import 'package:grades/widgets/refreshable_icon_message.dart';
import 'package:sis_loader/sis_loader.dart';

enum DisplayStyle { Full, Minimal }

class CourseGradesScreen extends StatefulWidget {
  @override
  _CourseGradesScreenState createState() => _CourseGradesScreenState();
}

class _CourseGradesScreenState extends State<CourseGradesScreen> {
  Future<List<Map<String, dynamic>>> _grades;
  bool _loaded = false;
  DisplayStyle _displayStyle = DisplayStyle.Minimal;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _fetchGrades();
    }
  }

  void _fetchGrades([bool force = false]) {
    final Course course = ModalRoute.of(context).settings.arguments;

    _grades = course.getGrades(force).then((grades) {
      _loaded = true;
      return grades;
    });
  }

  Future<List<Map<String, dynamic>>> _refresh() {
    _fetchGrades(true);
    return _grades;
  }

  @override
  Widget build(BuildContext context) {
    final Course course = ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          title: Text("${course.courseName}"),
          leading: IconButton(
            tooltip: "Back",
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          actions: [
            IconButton(
              // TODO: Pick a better icon
              icon: Icon(_displayStyle == DisplayStyle.Minimal
                  ? Icons.unfold_more
                  : Icons.unfold_less),
              onPressed: () {
                setState(() {
                  _displayStyle = _displayStyle == DisplayStyle.Minimal
                      ? DisplayStyle.Full
                      : DisplayStyle.Minimal;
                });
              },
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _grades,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.isEmpty) {
                    return RefreshableIconMessage(
                      onRefresh: _refresh,
                      icon: Icon(
                        FontAwesomeIcons.inbox,
                        size: 55,
                        color: Colors.white,
                      ),
                      child: Text(
                        "There are no grades listed in this class",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                        ),
                      ),
                    );
                  }
                  if (_displayStyle == DisplayStyle.Full) {
                    return CourseGradesFullDisplay(cleanupData(snapshot.data));
                  } else {
                    return CourseGradesMinimalDisplay(snapshot.data);
                  }
                } else if (snapshot.hasError) {
                  return RefreshableErrorMessage(
                    onRefresh: _refresh,
                    text:
                        "An error occured fetching grades:\n\n${snapshot.error}",
                  );
                }

                return Center(child: LoaderWidget());
              }),
        ));
  }
}

List<Map<String, dynamic>> cleanupData(List<Map<String, dynamic>> data) {
  Map<String, bool> values = {};

  for (var record in data) {
    for (var e in record.entries) {
      if (e.value != null) {
        values[e.key] = true;
      }
    }
  }

  List<Map<String, dynamic>> out = [];
  for (var record in data) {
    Map<String, dynamic> outRecord = {};
    for (var e in record.entries) {
      if (values[e.key] != null) {
        outRecord[e.key] = e.value;
      }
    }
    out.add(outRecord);
  }

  return out;
}
