import 'package:flutter/material.dart';
import 'package:grades/widgets/circle_progress.dart';
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
                color: Theme.of(context).accentColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 100,
                        child: Text(
                          keys[i].toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      Text(
                        _formatItem(values[i]),
                        style: TextStyle(color: Colors.white),
                      ),
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

class _CircleProgressState extends State with SingleTickerProviderStateMixin {
  AnimationController progressController;
  Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    progressController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    animation = Tween(begin: 0, end: 80).animate(progressController)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        foregroundPainter: CircleProgress(
            animation.value), // this will add custom painter after child
        child: Container(
          width: 200,
          height: 200,
          child: GestureDetector(
              onTap: () {
                if (animation.value == 80) {
                  progressController.reverse();
                } else {
                  progressController.forward();
                }
              },
              child: Center(
                  child: Text(
                "${animation.value.toInt()}%",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ))),
        ),
      ),
    );
  }
}
