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
                            'SwiftGrade is rebranding to MyGrades!',
                            'Find us on the app store as MyGrades, the web as mygrades.app, and insta as @mygradesapp',
                          ),
                          _buildNewItem('Beta Testing',
                              'If you want to be on the bleeding edge, join the beta in settings!'),
                          _buildNewItem(
                            'Leave a Review!',
                            'If you appreciate MyGrades, please leave a review on the App Store!',
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                                left: 32, right: 22, top: 0, bottom: 10),
                            child: Text(
                              'Thank you for using the app! \n\nIf you like MyGrades, share it with your friends!',
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
