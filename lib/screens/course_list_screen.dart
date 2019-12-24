import 'package:flutter/material.dart';
import 'package:grades/widgets/class_list_item_widget.dart';

class CourseListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            ClassListItemWidget(
              course: "Sample Class 1",
              letterGrade: "A",
              percent: 98,
              teacher: "Phillip",
            ),
            ClassListItemWidget(
              course: "Sample Class 2",
              letterGrade: "B",
              percent: 88,
              teacher: "Samson",
            )
          ],
        ),
      ),
    );
  }
}
