import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showUpdatedDialog(BuildContext context) {
  showDialog<AlertDialog>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.blue,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
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
                                  "What's New",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildNewItem(
                            'Grade Calculator',
                            'Our most requested feature!\nWant to know what you need to get on the next test? Now, SwiftGrade will help you find out. Accessible within each course in the top-right',
                          ),
                          _buildNewItem('Offline Mode',
                              'View past grades without a network connection'),
                          _buildNewItem('Faster Loading',
                              'A new and improved backend to speed up login times'),
                          _buildNewItem(
                            'Updated Icons',
                            'Almost every button throughout the app has been tweaked for clarity',
                          ),
                          _buildNewItem(
                            'Bug Fixes',
                            '',
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 32, right: 22, top: 0, bottom: 10),
                            child: Text(
                              'Thank you for using the app! \n\nIf you like SwiftGrade, share it with your friends!',
                              style: TextStyle(
                                fontSize: 18,
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
                                    fontSize: 17,
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
