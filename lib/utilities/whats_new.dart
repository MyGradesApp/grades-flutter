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
                            'Critical Fixes',
                            'Recently, issues with the grades data source resulted in many users unable to access SwiftGrade.\n \nAlthough we patched this within 24 hours, there was a period of time where we understand many users were frustrated.\n \nThis update aims to ensure that communication is better in the future, through the following: ',
                          ),
                          _buildNewItem('Feedback/Support',
                              'A feedback/support button on the login and settings screens'),
                          _buildNewItem('Essential Notifications',
                              'Push notifications allowing us to let you know about critical issues for now - and some fun stuff in the future ;)'),
                          _buildNewItem(
                            'Status/Update Indicator',
                            'A message at the top of the app when issues are occuring and when new updates are available',
                          ),
                          _buildNewItem(
                            'Instagram',
                            'Follow @getswiftgrade to always know the latest info!',
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
