import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showUpdatedDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.4,
            child: DefaultTextStyle(
              style: const TextStyle(color: Colors.white),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 25),
                          Center(
                            child: Column(
                              children: <Widget>[
                                const Text(
                                  'SwiftGrade',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                  ),
                                ),
                                const Text(
                                  "What's New:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildNewItem(
                            'Recent Grades',
                            'Swipe left from the home screen to see new and upcoming assignments',
                          ),
                          _buildNewItem(
                            'Improved Sorting',
                            'Switch between sorting your class grades by category or by date',
                          ),
                          _buildNewItem('Absences',
                              'View your absences on the Academic Information screen'),
                          _buildNewItem('Updated Icon', ''),
                          const Divider(
                            color: Colors.white,
                            endIndent: 40,
                            indent: 40,
                          ),
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 32, right: 22, top: 10),
                            child: Text(
                              'Thank you to everyone using SwiftGrade! We are so happy you are enjoying it. If you like SwiftGrade, share it with your friends',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          'AWESOME',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      });
}

Widget _buildNewItem(String title, String desc) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 22, top: 3),
          child: Text(
            desc,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ],
    ),
  );
}
