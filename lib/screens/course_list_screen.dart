import 'package:flutter/material.dart';
import 'package:grades/models/current_session.dart';
import 'package:grades/widgets/class_list_item_widget.dart';
import 'package:provider/provider.dart';
import 'package:sis_loader/sis_loader.dart';

class CourseListScreen extends StatefulWidget {
  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  Future<List<Course>> _courses;
  bool _complete = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_complete) {
      _courses = Provider.of<CurrentSession>(context)
          .sisLoader
          .getCourses()
          .then((courses) {
        setState(() {
          _complete = true;
        });
        return courses;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('COURSES'),
      ),
      body: FutureBuilder<List<Course>>(
        future: _courses,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  var course = snapshot.data[index];
                  return ClassListItemWidget(
                      onTap: () {
                        Navigator.pushNamed(context, '/course_grades',
                            arguments: course);
                        style:
                        TextStyle(
                          color: Colors.black,
                          fontFamily: 'OpenSans',
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        );
                      },
                      course: course.courseName,
                      letterGrade: course.gradeLetter,
                      teacher: course.teacherName,
                      percent: course.gradePercent);
                });
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    "An error occured loading courses:\n${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
