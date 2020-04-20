import 'package:flutter/material.dart';
import 'package:sis_loader/sis_loader.dart';

class GradeInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final grade = ModalRoute.of(context).settings.arguments as Grade;

    var gradeItems = grade.raw.entries.toList();
    gradeItems.removeWhere((e) => e.value == null);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Grade Info'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text(grade.name),
            ListView.builder(
              shrinkWrap: true,
              itemCount: gradeItems.length,
              itemBuilder: (context, i) {
                return Row(
                  children: <Widget>[
                    Expanded(child: Text(gradeItems[i].key)),
                    Text(gradeItems[i].value),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
