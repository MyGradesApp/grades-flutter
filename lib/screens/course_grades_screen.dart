import 'package:flutter/material.dart';
import 'package:grades/widgets/course_grades_full_display.dart';
import 'package:grades/widgets/course_grades_minimal_display.dart';
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

  _fetchGrades([bool force = false]) {
    final Course course = ModalRoute.of(context).settings.arguments;

    _grades = course.getGrades(force).then((grades) {
      _loaded = true;
      return grades;
    });
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
          child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _grades,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (_displayStyle == DisplayStyle.Full) {
                    return CourseGradesFullDisplay(snapshot.data);
                  } else {
                    return CourseGradesMinimalDisplay(snapshot.data);
                  }
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text(
                          "An error occured fetching grades:\n${snapshot.error}"));
                }

                return const Center(child: CircularProgressIndicator());
              }),
          onRefresh: () {
            _fetchGrades(true);
            return _grades;
          },
        ));
  }
}
