import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void showUpdatedDialog(BuildContext context) {
  showDialog<CupertinoAlertDialog>(
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
                                // const Text(
                                //   'SwiftGrade',
                                //   style: TextStyle(
                                //     fontWeight: FontWeight.bold,
                                //     fontSize: 26,
                                //   ),
                                // ),
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
                            'Our most requested feature by far! Want to know what you need to get on the next test? How many assignments can you skip and still pass? Now, SwiftGrade should help you find out. Accessible within each course in the top-right',
                          ),
                          _buildNewItem('Offline Mode',
                              'View past assignments without a network connection'),
                          _buildNewItem('Faster Loading',
                              'A new and improved backend to quicken login times'),
                          _buildNewItem(
                            'Updated Icons',
                            'Almost every button throughout the app has been tweaked for clarity',
                          ),
                          const Divider(
                            color: Colors.white,
                            endIndent: 40,
                            indent: 40,
                          ),
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 32, right: 22, top: 10),
                            child: Text(
                              'Thank you to everyone using SwiftGrade! If you like the app, please, share it with your friends',
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
