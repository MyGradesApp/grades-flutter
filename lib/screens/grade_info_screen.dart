import 'package:flutter/material.dart';
import 'package:flutter_circular_chart_two/flutter_circular_chart_two.dart';
import 'package:intl/intl.dart';
import 'package:sis_loader/sis_loader.dart';

var gradeRegExp = RegExp(r'([\d.]+) / ([\d.]+)');

class GradeInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var grade = ModalRoute.of(context).settings.arguments as Grade;

    double pointsUpper, pointsLower;
    if (grade.pointsEarned != null && grade.pointsPossible != null) {
      pointsUpper = double.tryParse(grade.pointsEarned ?? '0');
      pointsLower = double.tryParse(grade.pointsPossible ?? '0');
    }

    List<CircularSegmentEntry> items;
    if (pointsUpper == 0 && pointsLower == 0) {
      items = [
        CircularSegmentEntry(
          1,
          const Color(0xff2ad5d5),
          rankKey: 'achieved',
        )
      ];
    } else {
      items = [
        CircularSegmentEntry(
          pointsUpper ?? 0,
          const Color(0xff2ad5d5),
          rankKey: 'achieved',
        ),
        CircularSegmentEntry(
          (pointsLower ?? 0) - (pointsUpper ?? 0),
          Colors.blueGrey,
          rankKey: 'missed',
        ),
      ];
    }

    var pointsChartData = [
      CircularStackEntry(items),
    ];

    var rawData = <String, dynamic>{
      'Assignment': grade.name,
      'Points': grade.grade,
      'Grade': grade.letter,
      'Assigned': grade.assignedDate,
      'Due': grade.dueDate,
      'Last Modified': grade.dateLastModified,
      'Category': grade.category,
      'Comment': grade.comment,
    };
    rawData.removeWhere((key, dynamic value) => value == null);
    var assignmentName = rawData.remove('Assignment') as String;

    var keys = rawData.keys.toList();
    var values = rawData.values.toList();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(assignmentName),
      ),
      body: ListView.builder(
        itemCount: rawData.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: Card(
              color: keys[i] == 'Points' &&
                      values[i] is String &&
                      gradeRegExp.hasMatch(values[i] as String)
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).cardColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: _buildItem(
                keys[i],
                values[i],
                Theme.of(context).textTheme.bodyText1.color,
                pointsData: pointsChartData,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem(
    String key,
    dynamic value,
    Color textColor, {
    List<CircularStackEntry> pointsData,
  }) {
    if (key == 'Points' && value is String && gradeRegExp.hasMatch(value)) {
      return AnimatedCircularChart(
        size: const Size(240.0, 240.0),
        holeLabel: value,
        labelStyle: TextStyle(
          fontSize: 36,
          color: Colors.white,
        ),
        initialChartData: pointsData,
        chartType: CircularChartType.Radial,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 100,
            child: Text(
              key.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(_formatItem(value)),
        ],
      ),
    );
  }

  String _formatItem(dynamic item) {
    if (item is DateTime) {
      return DateFormat('MMMM d yyyy hh:mm aa').format(item);
    } else {
      return item.toString();
    }
  }
}
