import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:intl/intl.dart';
import 'package:sis_loader/sis_loader.dart';

var gradeRegExp = RegExp(r'([\d.]+) / ([\d.]+)');

class GradeInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var grade = ModalRoute.of(context).settings.arguments as Grade;

    double pointsUpper, pointsLower;
    if (grade.raw.containsKey('Points')) {
      var matches = gradeRegExp?.firstMatch(grade.points);

      pointsUpper = double.tryParse(matches?.group(1) ?? '0');
      pointsLower = double.tryParse(matches?.group(2) ?? '0');
    }
    var pointsChartData = [
      CircularStackEntry([
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
      ]),
    ];

    var rawData = Map<String, String>.from(grade.raw);
    rawData.removeWhere((key, value) => value == null);
    var assignmentName = rawData.remove('Assignment');

    var keys = rawData.keys.toList();
    var values = rawData.values.toList();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(assignmentName),
        leading: IconButton(
          tooltip: 'Back',
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: rawData.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: Card(
              color: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child:
                  _buildItem(keys[i], values[i], pointsData: pointsChartData),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem(String key, dynamic value,
      {List<CircularStackEntry> pointsData}) {
    if (key == 'Points' && value is String && gradeRegExp.hasMatch(value)) {
      return AnimatedCircularChart(
        size: const Size(240.0, 240.0),
        holeLabel: value,
        labelStyle: const TextStyle(
          fontSize: 28,
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            _formatItem(value),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  String _formatItem(dynamic item) {
    if (item is DateTime) {
      return DateFormat.yMMMMd().format(item);
    } else {
      return item as String;
    }
  }
}
