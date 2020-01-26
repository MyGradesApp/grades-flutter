import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:intl/intl.dart';

class GradeItemDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> grade =
        Map.from(ModalRoute.of(context).settings.arguments);

    var pointsUpper, pointsLower;
    if (grade.containsKey('Points')) {
      var matches = RegExp(r"(\d+) / (\d+)")?.firstMatch(grade['Points']);

      // TODO: Rework null propigation
      pointsUpper = double.tryParse(matches?.group(1) ?? "0");
      pointsLower = double.tryParse(matches?.group(2) ?? "0");
    }
    var pointsChartData = [
      CircularStackEntry([
        CircularSegmentEntry(pointsUpper ?? 0, Theme.of(context).primaryColor,
            rankKey: 'achieved'),
        CircularSegmentEntry(
            (pointsLower ?? 0) - (pointsUpper ?? 0), Colors.blueGrey,
            rankKey: 'missed'),
      ]),
    ];

    grade.removeWhere((key, value) => value == null);
    var assignmentName = grade.remove("Assignment");

    var keys = grade.keys.toList();
    var values = grade.values.toList();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(assignmentName),
        leading: IconButton(
          tooltip: "Back",
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: grade.length,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(1.0),
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
    if (key == "Points" && (value as String).contains('/')) {
      return AnimatedCircularChart(
        size: const Size(300.0, 300.0),
        holeLabel: value,
        // TODO: Adjust font family
        labelStyle: TextStyle(
          fontSize: 32,
          color: Colors.black,
        ),
        initialChartData: pointsData,
        chartType: CircularChartType.Radial,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(12.0),
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
      return DateFormat.yMMMMd().format(item);
    } else {
      return item;
    }
  }
}