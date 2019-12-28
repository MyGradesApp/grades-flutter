import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sis_loader/sis_loader.dart';

class CourseGradesScreen extends StatefulWidget {
  @override
  _CourseGradesScreenState createState() => _CourseGradesScreenState();
}

class _CourseGradesScreenState extends State<CourseGradesScreen> {
  Future<List<Map<String, dynamic>>> _grades;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _fetchGrades();
    } else {}
  }

  _fetchGrades() {
    final Course course = ModalRoute.of(context).settings.arguments;

    _grades = course.getGrades().then((grades) {
      _loaded = true;
      return grades;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Course course = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("${course.courseName}"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _grades,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _createTable(snapshot);
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                      "An error occured fetching grades:\n${snapshot.error}"));
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  Widget _createTable(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    final tableCols = snapshot.data[0]
        .map((k, v) {
          return MapEntry(k, DataColumn(label: Text(k)));
        })
        .values
        .toList();

    final List<DataRow> tableRows = [];
    for (var row in snapshot.data) {
      final List<DataCell> tableCells = row
          .map((k, v) {
            if (v == null) {
              return MapEntry(k, DataCell(Text("")));
            }
            if (v is DateTime) {
              return MapEntry(k, DataCell(Text(DateFormat.yMMMd().format(v))));
            } else {
              return MapEntry(k, DataCell(Text(v.toString())));
            }
          })
          .values
          .toList();

      tableRows.add(DataRow(cells: tableCells));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: tableCols,
        rows: tableRows,
        columnSpacing: 5,
      ),
    );
  }
}
