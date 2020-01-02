import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourseGradesFullDisplay extends StatelessWidget {
  final List<Map<String, dynamic>> _data;

  CourseGradesFullDisplay(this._data);

  @override
  Widget build(BuildContext context) {
    final tableCols = _data[0]
        .map((k, v) {
          return MapEntry(
              k,
              DataColumn(
                  label: Text(k,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))));
        })
        .values
        .toList();

    final List<DataRow> tableRows = [];
    for (var row in _data) {
      final List<DataCell> tableCells = row
          .map((k, v) {
            if (v == null) {
              return MapEntry(
                  k,
                  const DataCell(Text("",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))));
            }
            if (v is DateTime) {
              return MapEntry(
                  k,
                  DataCell(Text(DateFormat.yMMMd().format(v),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))));
            } else {
              return MapEntry(
                  k,
                  DataCell(Text(
                    v.toString(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )));
            }
          })
          .values
          .toList();

      tableRows.add(DataRow(cells: tableCells));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: const AlwaysScrollableScrollPhysics(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: tableCols,
          rows: tableRows,
          columnSpacing: 5,
        ),
      ),
    );
  }
}
