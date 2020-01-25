import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GradeItemDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> grade =
        Map.from(ModalRoute.of(context).settings.arguments);

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
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 100,
                        child: Text(
                          keys[i].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(_formatItem(values[i])),
                    ],
                  ),
                ),
              ),
            );
          }),
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
