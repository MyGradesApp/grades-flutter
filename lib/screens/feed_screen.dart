import 'package:flutter/material.dart';
import 'package:grades/models/grade_persistence.dart';
import 'package:grades/utilities/stacked_future_builder.dart';
import 'package:provider/provider.dart';
import 'package:sis_loader/sis_loader.dart';

class FeedScreen extends StatefulWidget {
  FeedScreen({Key key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  Map<String, String> _newgrades = {};

  @override
  Widget build(BuildContext context) {
    final gradePersistence = Provider.of<GradePersistence>(context);
    return StackedFutureBuilder<List<Course>>(builder: (context, snapshot) {
      return SizedBox.expand();
    });

    //   return WillPopScope(
    //     onWillPop: () async {
    //       return false;
    //     },
    //     child: Scaffold(
    //       backgroundColor: Theme.of(context).primaryColor,
    //       appBar: AppBar(
    //           elevation: 0.0,
    //           centerTitle: true,
    //           title: const Text('Recent'),
    //           leading: IconButton(
    //             tooltip: "Profile",
    //             icon: Icon(
    //               Icons.person,
    //             ),
    //             onPressed: () => Navigator.pushNamed(context, '/academic_info'),
    //           )),
    //       body: StackedFutureBuilder<List<Course>>(
    //           builder: (context, snapshot) {
    //         return SizedBox.expand(
    //           child: SingleChildScrollView(
    //             physics: const AlwaysScrollableScrollPhysics(),
    //             child: Column(
    //               children: [
    //                 _buildCard("Unit 4 Test", Colors.white, Theme.of(context).accentColor),
    //               ],
    //             ),
    //           ),
    //         );
    //       }),
    //     ),
    //   );
    // }

    // Widget _buildCard(BuildContext context, Map<String, dynamic> grade,
    //     Color textColor, Color cardColor) {
    //   var gradeString = grade["Grade"].toString();
    //   var percentIndex = gradeString.indexOf('%');
    //   String gradeLetter;
    //   if (percentIndex != -1) {
    //     var extractedGradePercent =
    //         double.tryParse(gradeString.substring(0, percentIndex));

    //     if (extractedGradePercent != null) {
    //       gradeLetter = letterGradeForPercent(extractedGradePercent);
    //     }
    //   }
    //   double gradeSize;
    //   if (grade != null && gradeLetter != null) {
    //     gradeSize = 50;
    //   } else {
    //     gradeSize = 100;
    //   }

    //   return  Card(
    //     color: cardColor,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10.0),
    //     ),
    //     margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    //     child: InkWell(
    //       customBorder: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(10.0),
    //       ),
    //       onTap: () {
    //         Navigator.pushNamed(context, '/grades_detail', arguments: grade);
    //       },
    //       child: Padding(
    //         padding: const EdgeInsets.all(17.0),
    //         child: Row(
    //           children: <Widget>[
    //             Expanded(
    //               child: Row(
    //                 children: <Widget>[
    //                   Text(
    //                     grade["Assignment"] as String,
    //                     style: TextStyle(color: textColor),
    //                   ),
    //                   const SizedBox(width: 6),
    //                 ],
    //               ),
    //             ),
    //             if (grade != null && gradeLetter != null)
    //               ColoredGradeDot.grade(gradeLetter),
    //             const SizedBox(width: 4),
    //             if (gradeLetter != null)
    //               Text(
    //                 gradeLetter,
    //                 style:
    //                     TextStyle(color: textColor, fontWeight: FontWeight.bold),
    //               ),
    //             Container(
    //               width: gradeSize,
    //               alignment: Alignment.centerRight,
    //               child: Text(
    //                 gradeString,
    //                 textAlign: TextAlign.end,
    //                 style:
    //                     TextStyle(color: textColor, fontWeight: FontWeight.bold),
    //               ),
    //             ),
    //             const Icon(
    //               Icons.chevron_right,
    //               color: Colors.black26,
    //               size: 18.0,
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
  }
}
